//
//  TaskRowImageView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct TaskRowImageView: View {
    let imageData: Data?
    private let iconSize: CGFloat = 50
    
    var body: some View {
        Group {
            if let data = imageData, !data.isEmpty {
                AsyncImageView(imageData: data)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else {
                Rectangle()
                    .foregroundStyle(.gray)
            }
        }
        .frame(width: iconSize, height: iconSize)
        .padding([.leading, .trailing], 15)
        .padding(.bottom, 10)
    }
}

