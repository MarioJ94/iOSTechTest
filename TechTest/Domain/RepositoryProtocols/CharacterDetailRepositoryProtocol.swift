//
//  CharacterDetailRepositoryProtocol.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

protocol CharacterDetailRepositoryProtocol {
    func getCharacterDetail(by id: Int) async throws -> CharacterDetailModel
}
