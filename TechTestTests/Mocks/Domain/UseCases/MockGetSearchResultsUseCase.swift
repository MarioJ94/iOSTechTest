//
//  MockGetSearchResultsUseCase.swift
//  TechTestTests
//
//  Created by Mario on 09/11/2026.
//

import Foundation
@testable import TechTest

final class MockGetSearchResultsUseCase: GetSearchResultsUseCaseProtocol {
    var onRun: ((GetSearchResultsParams) async throws -> Void)?
    var result: Result<SearchResultsModel, Error>?

    func run(params: GetSearchResultsParams) async throws -> SearchResultsModel {
        guard let onRun, let result else {
            throw MockError.notConfigured
        }
        try await onRun(params)
        switch result {
        case .success(let model):
            return model
        case .failure(let error):
            throw error
        }
    }
}

enum MockError: Error, Equatable {
    case notConfigured
}
