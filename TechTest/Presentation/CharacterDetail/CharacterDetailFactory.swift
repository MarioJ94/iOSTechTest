//
//  CharacterDetailFactory.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import SwiftUI

final class CharacterDetailFactory {
    private let getCharacterDetail: GetCharacterDetailUseCaseProtocol

    init() {
        let api = RickAndMortyAPI()
        let remote = CharacterDetailRemoteDataSource(api: api)
        let local = CharacterDetailLocalDataSource()
        let mapper = CharacterDetailEntityMapper()
        let repository = CharacterDetailRepository(remote: remote, local: local, mapper: mapper)
        self.getCharacterDetail = GetCharacterDetailUseCase(repository: repository)
    }

    func make(id: Int) -> some View {
        CharacterDetailScreen(
            viewModel: CharacterDetailViewModel(id: id, getCharacterDetail: getCharacterDetail)
        )
    }
}
