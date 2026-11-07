//
//  CharacterDetailRemoteDataSourceProtocol.swift
//  TechTest
//
//  Created by Mario on 09/11/2026.
//

import Foundation

protocol CharacterDetailRemoteDataSourceProtocol {
    func getCharacterDetail(by id: Int) async throws -> CharacterDetailEntity
}
