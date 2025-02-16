//
//  RetryButton.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/16/25.
//

import Foundation
import SwiftUI

struct RetryButton: View {
    let action: () async -> Void
    let frameSize: CGFloat = 25
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            
            Image(
                systemName: AppImageConsntants.refresh.rawValue
            )
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.white)
            .frame(
                width: frameSize,
                height: frameSize
            )
            .clipped()
        }
    }
}
