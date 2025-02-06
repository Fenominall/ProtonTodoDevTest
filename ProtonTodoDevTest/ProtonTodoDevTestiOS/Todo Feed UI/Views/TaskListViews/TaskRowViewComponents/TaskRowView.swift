//
//  TaskRowView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct TaskRowView: View {
    @Binding var task: TodoItemViewModel
    
    private let vSpacing: CGFloat = 5
    private let hSpacing: CGFloat = 5
    private let bottomPadding: CGFloat = 15
    private let iconSize: CGFloat = 50
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: hSpacing) {
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(width: iconSize, height: iconSize)
                    
                    VStack(alignment: .leading, spacing: vSpacing) {
                        TaskTitleDescriptionView(
                            title: task.title,
                            description: task.description
                        )
                        
                        TaskRowInfoVIew(
                            createdAt: task.createdAtString,
                            dueDate: task.dueDateString)
                    }
                }
                .padding(.bottom, bottomPadding)
                
                TaskRowCompletionToggle(isCompleted: $task.completed)
                TaskRowSeparator()
            }
        }
    }
}

//TaskRowInfoVIew(
//    topTimestamp: "12:30 PM, January 28, 2025",
//    bottomTimestamp: "12:30 PM, January 28, 2025"
//)
