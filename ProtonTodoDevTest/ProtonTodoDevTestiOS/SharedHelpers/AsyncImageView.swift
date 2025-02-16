//
//  AsyncImageView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/9/25.
//

import Foundation
import SwiftUI

struct AsyncImageView: View {
    let imageData: Data
    @State private var uiImage: UIImage?
    
    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                ProgressView()
                    .onAppear {
                        Task {
                            let data = await processImageData(imageData)
                            await MainActor.run { uiImage = data }
                        }
                    }
            }
        }
    }
    
    private func processImageData(_ data: Data) async -> UIImage? {
        await Task.detached(priority: .userInitiated) {
            UIImage(data: data)
        }.value
    }
}
