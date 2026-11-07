//
//  SearchScreenFactory.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import SwiftUI

final class SearchScreenFactory {
    private let getSearchResults: GetSearchResultsUseCaseProtocol

    init() {
        let api = RickAndMortyAPI()
        let remote = SearchRemoteDataSource(api: api)
        let local = SearchLocalDataSource()
        let mapper = SearchResultsEntityMapper()
        let repository = SearchRepository(remote: remote, local: local, mapper: mapper)
        self.getSearchResults = GetSearchResultsUseCase(searchRepository: repository)
    }

    func make(coordinator: NavigationCoordinatorProtocol) -> SearchScreen {
        let viewModel = SearchScreenViewModel(
            getSearchResults: getSearchResults,
            coordinator: coordinator
        )
        return SearchScreen(viewModel: viewModel)
    }
}
