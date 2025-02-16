//
//  TaskRowImageView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

struct TodoRowImageView: View {
    private let imageData: Data?
    @Binding private var isImageLoadFail: Bool
    private let onRefresh: () async -> Void
    
    private let iconSize: CGFloat = 70
    
    init(
        imageData: Data?,
        isImageLoadFail: Binding<Bool>,
        onRefresh: @escaping () async -> Void
    ) {
        self.imageData = imageData
        self._isImageLoadFail = isImageLoadFail
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        Group {
            if let data = imageData, !data.isEmpty {
                AsyncImageView(imageData: data)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: iconSize, height: iconSize)
                    .clipped()
            } else {
                ZStack {
                    Color.gray
                    if isImageLoadFail {
                        RetryButton(action: onRefresh)
                    }
                }
            }
        }
        .frame(width: iconSize, height: iconSize)
        .padding([.leading, .trailing], 15)
        .padding(.bottom, 10)
    }
}

