//
//  TaskRowView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct TaskRowView: View {
    @Binding var task: TodoItemPresentationModel
    var onCompletionStatusChange: (UUID, Bool) -> Void
    
    private let vSpacing: CGFloat = 5
    private let hSpacing: CGFloat = 5
    private let bottomPadding: CGFloat = 15
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: hSpacing) {
                    TaskRowImageView(imageData: Data())
                    
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
