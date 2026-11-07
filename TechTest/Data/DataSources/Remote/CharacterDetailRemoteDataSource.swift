//
//  CharacterDetailRemoteDataSource.swift
//  TechTest
//
//  Created by Mario on 09/11/2026.
//

import Foundation

final class CharacterDetailRemoteDataSource: CharacterDetailRemoteDataSourceProtocol {
    private let api: RickAndMortyAPIProtocol

    init(api: RickAndMortyAPIProtocol) {
        self.api = api
    }

    func getCharacterDetail(by id: Int) async throws -> CharacterDetailEntity {
        try await api.getCharacterDetail(by: id)
    }
}
