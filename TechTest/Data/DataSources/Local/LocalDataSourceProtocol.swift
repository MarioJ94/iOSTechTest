//
//  LocalDataSourceProtocol.swift
//  TechTest
//
//  Created by Mario on 09/11/2026.
//

import Foundation

protocol LocalDataSourceProtocol {
    associatedtype Entity: Sendable
    associatedtype Key: Hashable & Sendable

    func get(key: Key) async throws -> Entity?
    func set(key: Key, value: Entity) async throws
    func remove(key: Key) async throws
    func clear() async throws
}
