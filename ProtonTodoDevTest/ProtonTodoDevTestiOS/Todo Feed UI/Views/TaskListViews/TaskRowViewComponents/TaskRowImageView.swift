//
//  TaskRowImageView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct TaskRowImageView: View {
    let imageData: Data
    private let iconSize: CGFloat = 50
    
    var body: some View {
        if let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .padding([.leading, .trailing], 15)
                .padding(.bottom, 10)
        } else {
            Rectangle()
                .foregroundStyle(.gray)
                .frame(width: iconSize, height: iconSize)
        }
    }
}
