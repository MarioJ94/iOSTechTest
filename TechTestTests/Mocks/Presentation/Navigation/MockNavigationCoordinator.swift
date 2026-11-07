//
//  MockNavigationCoordinator.swift
//  TechTestTests
//
//  Created by Mario on 09/11/2026.
//

import Foundation
import SwiftUI
@testable import TechTest

final class MockNavigationCoordinator: NavigationCoordinatorProtocol {
    var onNavigate: ((NavigationDestination) -> Void)?
    var onPop: (() -> Void)?
    var onPopToRoot: (() -> Void)?

    func navigate(to destination: NavigationDestination) {
        onNavigate?(destination)
    }

    func pop() {
        onPop?()
    }

    func popToRoot() {
        onPopToRoot?()
    }
}