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
        if let data = imageData, !data.isEmpty {
            AsyncImageView(imageData: data)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing], 15)
                .padding(.bottom, 10)            
        } else {
            ProgressView("Loading image...")
        }
    }
}
