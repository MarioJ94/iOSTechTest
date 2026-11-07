//
//  GetSearchResultsUseCase.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

final class GetSearchResultsUseCase: GetSearchResultsUseCaseProtocol {
    private let searchRepository: SearchRepositoryProtocol

    init(searchRepository: SearchRepositoryProtocol) {
        self.searchRepository = searchRepository
    }

    func run(params: GetSearchResultsParams) async throws -> SearchResultsModel {
        return try await searchRepository.searchCharacters(by: params.term, page: params.page)
    }
}
