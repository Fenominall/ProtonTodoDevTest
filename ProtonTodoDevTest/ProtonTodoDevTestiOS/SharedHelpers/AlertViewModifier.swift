//
//  AlertViewModifier.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/9/25.
//

import SwiftUI

struct AlertViewModifier: ViewModifier {
    @Binding var isShowingError: Bool
    let title: String
    let buttonTitle: String
    let message: String?
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isShowingError) {
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
    func alertView(isShowingError: Binding<Bool>,
                   title: String,
                   buttonTitle: String,
                   message: String?,
                   action: @escaping () -> Void) -> some View {
        self.modifier(AlertViewModifier(
            isShowingError: isShowingError,
            title: title,
            buttonTitle: buttonTitle,
            message: message,
            action: action)
        )
    }
}


