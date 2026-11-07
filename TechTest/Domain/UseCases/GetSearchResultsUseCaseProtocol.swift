//
//  GetSearchResultsUseCaseProtocol.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

struct GetSearchResultsParams {
    let term: String
    let page: Int
}

protocol GetSearchResultsUseCaseProtocol {
    func run(params: GetSearchResultsParams) async throws -> SearchResultsModel
}