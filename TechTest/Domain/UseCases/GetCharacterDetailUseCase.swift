//
//  GetCharacterDetailUseCase.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

final class GetCharacterDetailUseCase: GetCharacterDetailUseCaseProtocol {
    private let repository: CharacterDetailRepositoryProtocol

    init(repository: CharacterDetailRepositoryProtocol) {
        self.repository = repository
    }

    func run(id: Int) async throws -> CharacterDetailModel {
        return try await repository.getCharacterDetail(by: id)
    }
}
