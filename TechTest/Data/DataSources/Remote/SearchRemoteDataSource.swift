//
//  SearchRemoteDataSource.swift
//  TechTest
//
//  Created by Mario on 09/11/2026.
//

import Foundation

final class SearchRemoteDataSource: SearchRemoteDataSourceProtocol {
    private let api: RickAndMortyAPIProtocol

    init(api: RickAndMortyAPIProtocol) {
        self.api = api
    }

    func searchCharacters(by name: String, page: Int) async throws -> SearchResultsEntity {
        try await api.searchCharacters(by: name, page: page)
    }
}
