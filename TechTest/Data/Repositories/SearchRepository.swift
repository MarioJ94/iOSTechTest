//
//  SearchRepository.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

final class SearchRepository: SearchRepositoryProtocol {
    private let remote: SearchRemoteDataSourceProtocol
    private let local: SearchLocalDataSource
    private let mapper: SearchResultsEntityMapperProtocol

    init(remote: SearchRemoteDataSourceProtocol, local: SearchLocalDataSource, mapper: SearchResultsEntityMapperProtocol) {
        self.remote = remote
        self.local = local
        self.mapper = mapper
    }

    func searchCharacters(by name: String, page: Int) async throws -> SearchResultsModel {
        let key = "\(name)_\(page)"

        if let cached = await local.get(key: key) {
            return cached
        }

        let entity = try await remote.searchCharacters(by: name, page: page)
        let model = mapper.map(entity)

        try Task.checkCancellation()
        await local.set(key: key, value: model)

        return model
    }
}
