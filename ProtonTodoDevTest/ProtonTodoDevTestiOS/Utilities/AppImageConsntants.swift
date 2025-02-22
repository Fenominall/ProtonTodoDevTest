//
//  AppImageConsntants.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

public enum AppImageConstants {
    case house
    case calendar
    case bell
    case refresh

    public var imageName: String {
        switch self {
        case .house:
            return "house"
        case .calendar:
            return "calendar"
        case .bell:
            return "bell"
        case .refresh:
            return "arrow.clockwise"
        }
    }

    public var image: Image {
        Image(systemName: imageName)
    }
}
