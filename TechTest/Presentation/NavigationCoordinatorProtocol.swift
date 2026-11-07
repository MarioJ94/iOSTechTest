//
//  NavigationCoordinatorProtocol.swift
//  TechTest
//
//  Created by Mario on 09/11/2026.
//

import SwiftUI

protocol NavigationCoordinatorProtocol {    
    func navigate(to destination: NavigationDestination)
    func pop()
    func popToRoot()
}
