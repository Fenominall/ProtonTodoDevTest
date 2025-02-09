//
//  InfoRowView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct InfoRowView: View {
    let label: String
    let timestamp: String

    var body: some View {
        HStack(alignment: .bottom) {
            Text(label)
                .bold()
                .lineLimit(1)
            Text(timestamp)
                .lineLimit(1)
                .font(.subheadline)
        }
    }
}

struct InfoRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 7) {
            InfoRowView(label: "Created", timestamp: "12:30 PM, January 28, 2025")
            InfoRowView(label: "Due", timestamp: "12:30 PM, January 28, 2025")
        }
        .previewLayout(.sizeThatFits)
    }
}
