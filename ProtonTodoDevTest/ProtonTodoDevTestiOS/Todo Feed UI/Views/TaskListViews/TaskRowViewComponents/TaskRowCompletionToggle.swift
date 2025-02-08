//
//  TaskRowCompletionToggle.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct TaskRowCompletionToggle: View {
    @Binding var isCompleted: Bool
    var onCompletionStatusChange: (Bool) -> Void
    
    var body: some View {
        
        HStack {
            Toggle("Done", isOn: $isCompleted)
                .onChange(of: isCompleted, { _, newValue in
                    onCompletionStatusChange(newValue)
                })
        }
    }
}
