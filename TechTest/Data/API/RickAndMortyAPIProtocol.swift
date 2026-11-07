//
//  RickAndMortyAPIProtocol.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

protocol RickAndMortyAPIProtocol {
    func searchCharacters(by name: String, page: Int) async throws -> SearchResultsEntity
    func getCharacterDetail(by id: Int) async throws -> CharacterDetailEntity
}
