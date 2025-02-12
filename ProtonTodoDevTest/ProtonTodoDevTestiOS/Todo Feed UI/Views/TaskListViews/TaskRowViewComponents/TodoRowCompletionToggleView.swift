//
//  TaskRowCompletionToggle.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct TodoRowCompletionToggleView: View {
    @Binding var isCompleted: Bool
    @State private var localIsCompleted: Bool
    var onToggle: () async -> Bool
    
    init(
        isCompleted: Binding<Bool>,
        onToggle: @escaping () async -> Bool
    ) {
        self._isCompleted = isCompleted
        self._localIsCompleted = State(initialValue: isCompleted.wrappedValue)
        self.onToggle = onToggle
    }
    
    var body: some View {
        
        HStack {
            Toggle("Done", isOn: $localIsCompleted)
                .onChange(of: localIsCompleted) { _, _ in
                    Task {
                        let success = await onToggle()
                        if !success {
                            localIsCompleted = isCompleted
                        }
                    }
                }
        }
    }
}
