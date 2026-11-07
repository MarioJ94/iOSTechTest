//
//  SearchRemoteDataSourceProtocol.swift
//  TechTest
//
//  Created by Mario on 09/11/2026.
//

import Foundation

protocol SearchRemoteDataSourceProtocol {
    func searchCharacters(by name: String, page: Int) async throws -> SearchResultsEntity
}
