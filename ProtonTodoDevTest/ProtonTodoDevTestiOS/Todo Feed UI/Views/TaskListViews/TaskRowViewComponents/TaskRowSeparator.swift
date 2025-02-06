//
//  TaskRowSeparator.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

// TaskSeparator - Reusable separator line under the task row
struct TaskRowSeparator: View {
    var body: some View {
        Rectangle()
            .foregroundStyle(.gray)
            .opacity(0.1)
            .frame(height: 0.5)
            .frame(maxWidth: .infinity)
            .padding(.trailing, -30)
    }
}
