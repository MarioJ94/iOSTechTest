//
//  TechTestApp.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import SwiftUI

@main
struct TechTestApp: App {
    @StateObject private var coordinator = NavigationCoordinator()
    private let searchFactory = SearchScreenFactory()
    private let characterDetailFactory = CharacterDetailFactory()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                searchFactory.make(coordinator: coordinator)
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        switch destination {
                        case .characterDetail(let id):
                            characterDetailFactory.make(id: id)
                        }
                    }
            }
        }
    }
}
