//
//  GetCharacterDetailUseCaseProtocol.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

protocol GetCharacterDetailUseCaseProtocol {
    func run(id: Int) async throws -> CharacterDetailModel
}
