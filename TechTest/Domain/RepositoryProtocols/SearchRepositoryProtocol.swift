//
//  SearchRepositoryProtocol.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

protocol SearchRepositoryProtocol {
    func searchCharacters(by name: String, page: Int) async throws -> SearchResultsModel
}
