//
//  Cache.swift
//  TechTest
//
//  Created by Mario on 09/11/2026.
//

import Foundation

actor Cache<Key: Hashable & Sendable, Model: Sendable> {
    private struct Entry: Sendable {
        let value: Model
        let timestamp: Date
    }
    
    private var storage = [Key: Entry]()
    private let maxAge: TimeInterval
    private let maxEntries: Int

    init(maxAge: TimeInterval = 120, maxEntries: Int = 100) {
        self.maxAge = maxAge
        self.maxEntries = maxEntries
    }
    
    func get(key: Key) async -> Model? {
        guard let entry = storage[key] else { return nil }
        if expired(entry.timestamp) {
            storage[key] = nil
            return nil
        }
        return entry.value
    }
    
    func set(key: Key, value: Model) async {
        if storage.count >= maxEntries {
            cleanupExpiredOrLast()
        }
        storage[key] = Entry(value: value, timestamp: Date())
    }
    
    func remove(key: Key) async {
        storage[key] = nil
    }

    func clear() async {
        storage.removeAll()
    }
    
    private func expired(_ timestamp: Date) -> Bool {
        Date().timeIntervalSince(timestamp) > maxAge
    }
    
    private func cleanupExpiredOrLast() {
        var oldest = Date.distantFuture
        var oldestKey: Key?
        var expiredKeys = [Key]()
        for (key, entry) in storage {
            if expired(entry.timestamp) {
                expiredKeys.append(key)
            }
            if oldest.compare(entry.timestamp) == .orderedDescending {
                oldestKey = key
                oldest = entry.timestamp
            }
        }
        if !expiredKeys.isEmpty {
            expiredKeys.forEach { storage[$0] = nil }
        } else if let oldestKey {
            storage[oldestKey] = nil
        }
    }
}
