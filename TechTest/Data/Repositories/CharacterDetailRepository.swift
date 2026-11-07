//
//  CharacterDetailRepository.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

final class CharacterDetailRepository: CharacterDetailRepositoryProtocol {
    private let remote: CharacterDetailRemoteDataSourceProtocol
    private let local: CharacterDetailLocalDataSource
    private let mapper: CharacterDetailEntityMapperProtocol

    init(remote: CharacterDetailRemoteDataSourceProtocol, local: CharacterDetailLocalDataSource, mapper: CharacterDetailEntityMapperProtocol) {
        self.remote = remote
        self.local = local
        self.mapper = mapper
    }

    func getCharacterDetail(by id: Int) async throws -> CharacterDetailModel {
        if let cached = await local.get(key: id) {
            return cached
        }

        let entity = try await remote.getCharacterDetail(by: id)
        let model = mapper.map(entity)

        try Task.checkCancellation()
        await local.set(key: id, value: model)

        return model
    }
}
