//
//  AppCoordinator.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/13/25.
//

import SwiftUI
import ProtonTodoDevTest
import ProtonTodoDevTestiOS

public final class AnyIdentifiable: Identifiable {
    public let destination: any Identifiable
    
    init(destination: any Identifiable) {
        self.destination = destination
    }
}

@MainActor
public final class Router: ObservableObject {
    @Published public var navigationPath = NavigationPath()
    @Published public var presentedSheet: AnyIdentifiable?
    
    public init() {}
    
    public func navigate(to destination: any Hashable) {
        navigationPath.append(destination)
    }
    
    public func navigateBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    public func navigateToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}
