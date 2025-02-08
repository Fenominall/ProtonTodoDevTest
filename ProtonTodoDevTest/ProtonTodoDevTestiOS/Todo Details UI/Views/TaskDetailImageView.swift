//
//  TaskDetailImageView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct TaskDetailImageView: View {
    let imageData: Data?
    
    var body: some View {
        if let data = imageData, !data.isEmpty ,let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing], 15)
                .padding(.bottom, 10)
        } else {
            ProgressView("Loading image...")
        }
    }
}
