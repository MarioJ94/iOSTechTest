//
//  RickAndMortyAPI.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

final class RickAndMortyAPI: RickAndMortyAPIProtocol {
    private let baseURL = "https://rickandmortyapi.com/api"

    func searchCharacters(by name: String, page: Int) async throws -> SearchResultsEntity {
        var components = URLComponents(string: "\(baseURL)/character")!
        components.queryItems = [
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "page", value: String(page))
        ]
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        return try JSONDecoder().decode(SearchResultsEntity.self, from: data)
    }

    func getCharacterDetail(by id: Int) async throws -> CharacterDetailEntity {
        let url = URL(string: "\(baseURL)/character/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(CharacterDetailEntity.self, from: data)
    }
}	
