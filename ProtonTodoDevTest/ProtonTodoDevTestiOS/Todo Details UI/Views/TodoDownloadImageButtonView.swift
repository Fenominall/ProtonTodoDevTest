//
//  DownloadImageButton.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct TododownloadImageButtonView: View {
    private let action: () async -> Void
    
    init(action: @escaping () async -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Text("Download Image")
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
    }
}
