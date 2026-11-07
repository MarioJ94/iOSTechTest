//
//  CharacterDetailEntityMapper.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

final class CharacterDetailEntityMapper: CharacterDetailEntityMapperProtocol {
    func map(_ entity: CharacterDetailEntity) -> CharacterDetailModel {
        CharacterDetailModel(
            id: entity.id,
            name: entity.name,
            status: entity.status,
            species: entity.species,
            type: entity.type,
            gender: entity.gender,
            origin: CharacterDetailOriginModel(name: entity.origin.name,
                                               url: entity.origin.url),
            location: CharacterDetailLocationModel(name: entity.location.name,
                                                   url: entity.location.url),
            image: entity.image,
            episode: entity.episode,
            url: entity.url,
            created: entity.created
        )
    }
}
