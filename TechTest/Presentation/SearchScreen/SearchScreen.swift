//
//  SearchScreen.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import SwiftUI
import Combine

struct SearchScreen: View {
    @StateObject private var viewModel: SearchScreenViewModel
    @State private var searchText: String = ""
    
    init(viewModel: SearchScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            content
                .searchable(text: $searchText, placement: .automatic, prompt: .characterSearchScreenSearchPlaceholder)
        }
        .navigationTitle(.characterSearchScreenTitle)
        .onAppear {
            viewModel.notifyAppearance()
        }
        .onChange(of: searchText) { _, newValue in
            viewModel.didInputSearchTerm(newValue)
        }
    }
}

private extension SearchScreen {
    @ViewBuilder
    var content: some View {
        Group {
            if viewModel.showError {
                backgroundColor
                    .overlay {
                        VStack(spacing: 16) {
                            Text(.characterSearchScreenErrorMessage)
                                .foregroundStyle(.foreground)
                            Button(.characterSearchScreenRetryButton) {
                                viewModel.didInputSearchTerm(searchText)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
            } else if viewModel.isLoading {
                backgroundColor
                    .overlay(ProgressView())
            } else if let results = viewModel.results {
                list(results: results)
            }
        }
    }
    
    @ViewBuilder
    func list(results: [SearchResultsItemModel]) -> some View {
        List {
            ForEach(results, id: \.id) { item in
                listItem(model: item)
            }
            
            if viewModel.hasNextPage {
                footerLoadingView
            }
        }
        .background(backgroundColor)
    }
    
    @ViewBuilder
    var footerLoadingView: some View {
        ZStack {
            Button(.characterSearchScreenRetryButton) {
                viewModel.didRequestNextPage()
            }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding()
                .opacity(viewModel.showPageError ? 1 : 0)
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)
                .opacity(viewModel.showPageError ? 0 : 1)
                .onAppear {
                    viewModel.didRequestNextPage()
                }
        }
    }

    @ViewBuilder
    func listItem(model: SearchResultsItemModel) -> some View {
        SearchResultRow(item: model)
            .onTapGesture {
                viewModel.tappedCharacter(id: model.id)
            }
    }
    
    var backgroundColor: some View {
        Color(uiColor: UIColor.systemGroupedBackground)
            .ignoresSafeArea(.all, edges: .all)
    }
}

private extension SearchScreen {
    struct SearchResultRow: View {
        let item: SearchResultsItemModel

        var body: some View {
            HStack(spacing: 12) {
                image
                info
            }
            .padding(.vertical, 4)
        }

        var image: some View {
            AsyncImage(url: URL(string: item.image)) { phase in
                Group {
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                            .background(Color(.systemGray5))
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }

        var info: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(1)
                Text("\(item.species) • \(item.status)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
    }
}
