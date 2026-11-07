//
//  SearchScreenViewModelTests.swift
//  TechTestTests
//
//  Created by Mario on 09/11/2026.
//

import XCTest
import Combine
@testable import TechTest

@MainActor
final class SearchScreenViewModelTests: XCTestCase {
    private var viewModel: SearchScreenViewModel!
    private var mockUseCase: MockGetSearchResultsUseCase!
    private var mockCoordinator: MockNavigationCoordinator!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockUseCase = MockGetSearchResultsUseCase()
        mockCoordinator = MockNavigationCoordinator()
        viewModel = SearchScreenViewModel(
            getSearchResults: mockUseCase,
            coordinator: mockCoordinator
        )
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        mockCoordinator = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func testInitialState_propertiesAreDefaultValues() {
        XCTAssertNil(viewModel.results)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertFalse(viewModel.hasNextPage)
        XCTAssertFalse(viewModel.isLoadingPage)
        XCTAssertFalse(viewModel.showPageError)
    }

    // MARK: - notifyAppearance

    func testNotifyAppearance_firstCall_triggersSearchWithEmptyTerm() {
        // Given
        let onRunExpectation = expectation(description: "onRunExpectation")
        mockUseCase.onRun = { params in
            onRunExpectation.fulfill()
        }
        let model = makeSearchResultsModel()
        mockUseCase.result = .success(model)
        let resultsExpectation = expectation(description: "resultsExpectation")
        viewModel.$results
            .dropFirst()
            .sink { results in
                XCTAssertEqual(results?.count, model.items.count)
                XCTAssertEqual(results?.first?.name, model.items.first?.name)
                resultsExpectation.fulfill()
            }
            .store(in: &cancellables)
        // When
        viewModel.notifyAppearance()
        // Then
        waitForExpectations(timeout: 1.0)
        
    }

    func testNotifyAppearance_secondCall_doesNotTriggerSearch() {
        // Given
        let firstSearchExpect = expectation(description: "firstNotifyExpect")
        let secondSearchExpect = expectation(description: "secondNotifyExpect")
        secondSearchExpect.isInverted = true
        
        mockUseCase.onRun = { _ in }
        mockUseCase.result = .success(.dummy())
        viewModel.$results.dropFirst()
            .first()
            .sink { _ in
                firstSearchExpect.fulfill()
            }
            .store(in: &cancellables)
        viewModel.$results.dropFirst(2)
            .first()
            .sink { _ in
                secondSearchExpect.fulfill()
            }
            .store(in: &cancellables)
        // When
        viewModel.notifyAppearance()
        viewModel.notifyAppearance()
        // Then
        waitForExpectations(timeout: 0.5)
    }

    // MARK: - didInputSearchTerm

    func testDidInputSearchTerm_updatesResultsAndState() {
        // To implement
    }

    func testDidInputSearchTerm_setsLoadingThenClears() {
        // To implement
    }

    func testDidInputSearchTerm_cancelsPreviousRequest() {
        // Given
        let firstSearchExpect = expectation(description: "firstSearchExpect")
        let secondSearchExpect = expectation(description: "secondSearchExpect")
        secondSearchExpect.isInverted = true

        mockUseCase.onRun = { _ in }
        mockUseCase.result = .success(.dummy())
        viewModel.$results.dropFirst()
            .first()
            .sink { _ in
                firstSearchExpect.fulfill()
            }
            .store(in: &cancellables)
        viewModel.$results.dropFirst(2)
            .first()
            .sink { _ in
                secondSearchExpect.fulfill()
            }
            .store(in: &cancellables)
        // When
        viewModel.didInputSearchTerm("Ri")
        viewModel.didInputSearchTerm("Rick")
        // Then
        waitForExpectations(timeout: 0.5)
    }

    func testDidInputSearchTerm_onError_setsShowErrorTrue() {
        let errorExpectation = expectation(description: "Error state set")
        
        mockUseCase.onRun = { _ in }
        mockUseCase.result = .failure(URLError(.notConnectedToInternet))
        
        viewModel.$showError
            .collect(3)
            .sink { values in
                if values == [false, false, true] {
                    errorExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.didInputSearchTerm("Rick")
        
        waitForExpectations(timeout: 2.0)
    }

    // MARK: - didRequestNextPage
    
    func testDidRequestNextPage_whenHasNextPage_loadsNextPage() {
        let firstPageExpectation = expectation(description: "firstPageExpectation")
        let firstPageItems = [SearchResultsItemModel.dummy(id: 1, name: "Rick")]
        let secondPageExpectation = expectation(description: "secondPageExpectation")
        let secondPageItems = [SearchResultsItemModel.dummy(id: 2, name: "Morty")]
        
        mockUseCase.onRun = { _ in }
        mockUseCase.result = .success(makeSearchResultsModel(items: firstPageItems, hasNextPage: true))
        
        // First search
        viewModel.$results
            .dropFirst()
            .first()
            .sink { results in
                XCTAssertEqual(results?.count, 1)
                XCTAssertEqual(results?.last?.name, "Rick")
                firstPageExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.didInputSearchTerm("Rick")

        wait(for: [firstPageExpectation], timeout: 0.5)
        
        // Next search
        self.viewModel.$results
            .dropFirst()
            .first()
            .sink { results in
                XCTAssertEqual(results?.count, 2)
                XCTAssertEqual(results?.last?.name, "Morty")
                secondPageExpectation.fulfill()
            }
            .store(in: &self.cancellables)
        mockUseCase.result = .success(makeSearchResultsModel(items: secondPageItems, hasNextPage: true))
        viewModel.didRequestNextPage()
        
        wait(for: [secondPageExpectation], timeout: 0.5)
    }

    func testDidRequestNextPage_whenNoNextPage_doesNothing() {
        // To implement
    }

    func testDidRequestNextPage_whenAlreadyLoading_doesNothing() {
        // To implement
    }

    func testDidRequestNextPage_onError_setsShowPageErrorTrue() {
        // To implement
    }

    // MARK: - tappedCharacter

    func testTappedCharacter_navigatesToDetail() {
        let expect = expectation(description: "Navigation triggered")
        
        mockCoordinator.onNavigate = { destination in
            if case .characterDetail(let id) = destination {
                XCTAssertEqual(id, 42)
                expect.fulfill()
            }
        }
        
        viewModel.tappedCharacter(id: 42)
        waitForExpectations(timeout: 1.0)
    }

    // MARK: - Helpers

    func makeSearchResultsModel(items: [SearchResultsItemModel] = [.dummy()], hasNextPage: Bool = false) -> SearchResultsModel {
        .dummy(
            items: items,
            count: 10,
            pages: 99,
            nextURL: hasNextPage ? "nextUrl" : nil,
            prevURL: nil)
    }
}

private extension SearchResultsModel {
    static func dummy(items: [SearchResultsItemModel] = [.dummy()],
                      count: Int = 10,
                      pages: Int = 99,
                      nextURL: String? = nil,
                      prevURL: String? = nil) -> SearchResultsModel {
        SearchResultsModel(
            items: items,
            count: count,
            pages: pages,
            nextURL: nextURL,
            prevURL: prevURL)
    }
}
    
private extension SearchResultsItemModel {
    static func dummy(id: Int = 1, name: String = "name") -> SearchResultsItemModel {
        SearchResultsItemModel(
            id: id,
            name: name,
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: SearchResultsOriginModel(name: "Earth", url: ""),
            location: SearchResultsLocationModel(name: "Earth", url: ""),
            image: "",
            episode: [],
            url: "",
            created: "")
    }
}
