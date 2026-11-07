//
//  CharacterDetailScreen.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import SwiftUI

struct CharacterDetailScreen: View {
    @StateObject private var viewModel: CharacterDetailViewModel

    init(viewModel: CharacterDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            content
        }
        .navigationTitle(.characterDetailScreenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.notifyAppearance()
        }
    }
    
    @ViewBuilder
    var content: some View {
        if viewModel.showError {
            backgroundColor
                .overlay{
                    Text(.characterDetailScreenError)
                        .foregroundStyle(.foreground)
                }
        } else if viewModel.isLoading {
            backgroundColor
                .overlay(ProgressView())
        } else if let character = viewModel.character {
            characterDetail(character)
                .background(backgroundColor)
        } else {
            EmptyView()
        }
    }
    
    var backgroundColor: some View {
        Color(uiColor: UIColor.systemGroupedBackground)
            .ignoresSafeArea(.all, edges: .all)
    }

    @ViewBuilder
    func characterDetail(_ character: CharacterDetailModel) -> some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                AsyncImage(url: URL(string: character.image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundStyle(.secondary)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 8) {
                    Text(character.name)
                        .font(.title)

                    Divider()
                    detailRow(label: .characterDetailInfoStatus, value: character.status)
                    detailRow(label: .characterDetailInfoSpecies, value: character.species)
                    detailRow(label: .characterDetailInfoType, value: character.type)
                    detailRow(label: .characterDetailInfoGender, value: character.gender)
                    detailRow(label: .characterDetailInfoOrigin, value: character.origin.name)
                    detailRow(label: .characterDetailInfoLocation, value: character.location.name)
                    detailRow(label: .characterDetailInfoEpisodes, value: .characterDetailInfoEpisodesValue(character.episode.count))
                }
                .padding(.horizontal, 20)
                .padding(.vertical)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
            }
        }
    }

    @ViewBuilder
    func detailRow(label: LocalizedStringResource, value: String) -> some View {
        detailRow(label: Text(label), value: Text(value))
    }
    
    @ViewBuilder
    func detailRow(label: LocalizedStringResource, value: LocalizedStringResource) -> some View {
        detailRow(label: Text(label), value: Text(value))
    }
    
    @ViewBuilder
    func detailRow(label: Text, value: Text) -> some View {
        HStack {
            label.foregroundStyle(.secondary)
                .layoutPriority(1)
            Spacer()
            value
                .lineLimit(3)
        }
    }
}
