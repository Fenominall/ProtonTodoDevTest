//
//  TaskTitleDescriptionView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct TaskTitleDescriptionView: View {
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.bold)
            Text(description)
                .italic()
                .lineLimit(1)
        }
    }
}
