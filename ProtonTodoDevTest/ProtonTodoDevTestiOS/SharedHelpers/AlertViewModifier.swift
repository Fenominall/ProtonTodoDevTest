//
//  AlertViewModifier.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/9/25.
//

import SwiftUI

struct AlertViewModifier: ViewModifier {
    @Binding var isShowingError: Bool
    let title: String?
    let buttonTitle: String
    let message: String?
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .alert(
                title ?? "",
                isPresented: $isShowingError) {
                    Button(buttonTitle) {
                        Task {
                            action()
                        }
                    }
                } message: {
                    if let message = message {
                        Text(message)
                    }
                }
    }
}

extension View {
    func todoFeedErrorAlert(
        error: Binding<TodoFeedError?>,
        retryAction: @escaping () -> Void = {}
    ) -> some View {
        self.modifier(AlertViewModifier(
            isShowingError: Binding(
                get: {
                    error.wrappedValue != nil
                }, set: { newValue in
                    if !newValue {
                        error.wrappedValue = nil
                    }
                }),
            title: error.wrappedValue?.errorDescription,
            buttonTitle: error.wrappedValue?.buttonTitle ?? "Ok",
            message: error.wrappedValue?.recoverySuggestion,
            action: {
                if error.wrappedValue == .networkError {
                    retryAction()
                }
                error.wrappedValue = nil
            })
        )
    }
}


