//
//  TaskRowInfoView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct TodoRowInfoVIew: View {
    let createdAt: String
    let dueDate: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                AppImageConstants.calendar.image
                InfoRowView(label: "Created", timestamp: createdAt)
            }
            HStack {
                AppImageConstants.bell.image
                InfoRowView(label: "Due", timestamp: dueDate)
            }
        }
    }
}
