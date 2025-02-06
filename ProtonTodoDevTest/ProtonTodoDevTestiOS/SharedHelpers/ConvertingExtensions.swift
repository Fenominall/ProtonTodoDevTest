//
//  ConvertingExtensions.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

func iso8601FormattedString(from date: Date) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.string(from: date)
}

