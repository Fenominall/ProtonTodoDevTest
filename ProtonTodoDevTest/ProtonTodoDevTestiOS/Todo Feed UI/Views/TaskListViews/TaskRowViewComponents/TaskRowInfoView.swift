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
                Image(systemName: AppImageConsntants.calendar.rawValue)
                InfoRowView(label: "Created", timestamp: createdAt)
            }
            HStack {
                Image(systemName: AppImageConsntants.bell.rawValue)
                InfoRowView(label: "Due", timestamp: dueDate)
            }
        }
    }
}
