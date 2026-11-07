//
//  SearchResultsEntityMapper.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

final class SearchResultsEntityMapper: SearchResultsEntityMapperProtocol {
    func map(_ entity: SearchResultsEntity) -> SearchResultsModel {
        SearchResultsModel(
            items: entity.results.map { item in
                SearchResultsItemModel(
                    id: item.id,
                    name: item.name,
                    status: item.status,
                    species: item.species,
                    type: item.type,
                    gender: item.gender,
                    origin: SearchResultsOriginModel(name: item.origin.name,
                                        url: item.origin.url),
                    location: SearchResultsLocationModel(name: item.location.name,
                                            url: item.location.url),
                    image: item.image,
                    episode: item.episode,
                    url: item.url,
                    created: item.created
                )
            },
            count: entity.info.count,
            pages: entity.info.pages,
            nextURL: entity.info.next,
            prevURL: entity.info.prev
        )
    }
}
