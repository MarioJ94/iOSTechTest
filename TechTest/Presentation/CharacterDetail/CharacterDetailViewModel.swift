//
//  CharacterDetailViewModel.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation
import Combine

@MainActor
final class CharacterDetailViewModel: ObservableObject {
    @Published private(set) var character: CharacterDetailModel?
    @Published private(set) var isLoading = false
    @Published private(set) var showError = false

    private let id: Int
    private let getCharacterDetail: GetCharacterDetailUseCaseProtocol
    private var firstAppear = true

    init(id: Int, getCharacterDetail: GetCharacterDetailUseCaseProtocol) {
        self.id = id
        self.getCharacterDetail = getCharacterDetail
    }
    
    func notifyAppearance() {
        guard firstAppear else {
            return
        }
        firstAppear = false
        loadCharacter(id: id)
    }

    func loadCharacter(id: Int) {
        Task { [weak self] in
            guard let self else { return }
            do {
                isLoading = true
                showError = false
                let character = try await getCharacterDetail.run(id: id)
                self.character = character
                isLoading = false
            } catch {
                showError = true
                isLoading = false
            }
        }
    }
}
