//
//  NavigationCoordinator.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import SwiftUI
import Combine

enum NavigationDestination: Hashable {
    case characterDetail(id: Int)
}

final class NavigationCoordinator: NavigationCoordinatorProtocol, ObservableObject {
    @Published var path = NavigationPath()

    func navigate(to destination: NavigationDestination) {
        path.append(destination)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
