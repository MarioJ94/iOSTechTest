//
//  SearchScreenViewModel.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation
import Combine

@MainActor
final class SearchScreenViewModel: ObservableObject {
    private var searchRequest: Task<Void, Never>?
    private var currentResultTerm: String?
    @Published private(set) var results: [SearchResultsItemModel]?
    @Published private(set) var isLoading = false
    @Published private(set) var showError = false
    @Published private(set) var currentPage = 1
    @Published private(set) var hasNextPage = false
    @Published private(set) var isLoadingPage = false
    @Published private(set) var showPageError = false
    private var firstAppear = true
    private let getSearchResults: GetSearchResultsUseCaseProtocol
    private let coordinator: NavigationCoordinatorProtocol

    init(getSearchResults: GetSearchResultsUseCaseProtocol, coordinator: NavigationCoordinatorProtocol) {
        self.getSearchResults = getSearchResults
        self.coordinator = coordinator
    }

    func notifyAppearance() {
        guard firstAppear else {
            return
        }
        firstAppear = false
        handleInputSearchTerm("", delay: .zero)
    }
    
    func didInputSearchTerm(_ text: String) {
        handleInputSearchTerm(text, delay: .seconds(0.3))
    }

    func didRequestNextPage() {
        handleRequestNextPage()
    }

    func tappedCharacter(id: Int) {
        coordinator.navigate(to: .characterDetail(id: id))
    }
}

private extension SearchScreenViewModel {
    func changeLoadingState(loadingNextPage: Bool, value: Bool) {
        if loadingNextPage {
            isLoadingPage = value
        } else {
            isLoading = value
        }
    }
    
    func changeErrorState(loadingNextPage: Bool, value: Bool) {
        if loadingNextPage {
            showPageError = value
        } else {
            showError = value
        }
    }
    
    func requestSearch(_ text: String, page: Int = 1) async throws {
        let loadingNextPage = page != 1
        changeLoadingState(loadingNextPage: loadingNextPage, value: true)
        changeErrorState(loadingNextPage: loadingNextPage, value: false)
        let response = try await getSearchResults.run(
            params: GetSearchResultsParams(term: text, page: page))
        try Task.checkCancellation()
        if !loadingNextPage {
            results = response.items
        } else {
            let existingItems = results ?? []
            results = existingItems + response.items
        }
        currentResultTerm = text
        currentPage = page
        hasNextPage = response.nextURL != nil
        changeLoadingState(loadingNextPage: loadingNextPage, value: false)
    }
}

private extension SearchScreenViewModel {
    func handleInputSearchTerm(_ text: String, delay: Duration) {
        searchRequest?.cancel()
        searchRequest = Task { [weak self] in
            guard let self else {
                return
            }
            do {
                try await Task.sleep(for: delay)
                try Task.checkCancellation()
                try await requestSearch(text, page: 1)
            } catch is CancellationError {
                // Nothing to do
            } catch {
                showError = true
                isLoading = false
            }
        }
    }
}

private extension SearchScreenViewModel {
    func handleRequestNextPage() {
        guard hasNextPage, !isLoadingPage else { return }
        isLoadingPage = true
        showPageError = false
        searchRequest = Task { [weak self] in
            guard let self else {
                return
            }
            do {
                try await requestSearch(currentResultTerm ?? "", page: currentPage + 1)
            } catch is CancellationError {
                isLoadingPage = false
            } catch {
                showPageError = true
                isLoadingPage = false
            }
        }
    }
}
