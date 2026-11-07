//
//  CharacterDetailLocalDataSource.swift
//  TechTest
//
//  Created by Mario on 09/11/2026.
//

import Foundation

actor CharacterDetailLocalDataSource: LocalDataSourceProtocol {
    typealias Entity = CharacterDetailModel
    typealias Key = Int

    private let cache = Cache<Key, Entity>(maxAge: 120, maxEntries: 100)

    func get(key: Key) async -> Entity? {
        await cache.get(key: key)
    }

    func set(key: Key, value: Entity) async {
        await cache.set(key: key, value: value)
    }

    func remove(key: Key) async {
        await cache.remove(key: key)
    }

    func clear() async {
        await cache.clear()
    }
}
