//
//  TaskRowCompletionToggle.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct TodoRowCompletionToggleView: View {
    @Binding var isCompleted: Bool
    var onCompletionStatusChange: (Bool) async -> Void
    
    var body: some View {
        
        HStack {
            Toggle("Done", isOn: $isCompleted)
                .onChange(of: isCompleted) { _, newValue in
                    Task {
                        await onCompletionStatusChange(newValue)
                    }
                }
        }
    }
}
