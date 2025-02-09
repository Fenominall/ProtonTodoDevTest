//
//  TaskDetailImageView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct TodoDetailImageView: View {
    let imageData: Data?
    
    var body: some View {
        if let imageData = imageData, !imageData.isEmpty {
            AsyncImageView(imageData: imageData)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing], 15)
                .padding(.bottom, 10)
        } else {
            ProgressView("Loading image...")
        }
    }
}
