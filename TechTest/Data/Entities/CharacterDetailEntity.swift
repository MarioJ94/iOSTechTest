//
//  CharacterDetailEntity.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

struct CharacterDetailEntity: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterDetailOriginEntity
    let location: CharacterDetailLocationEntity
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct CharacterDetailOriginEntity: Decodable {
    let name: String
    let url: String?
}

struct CharacterDetailLocationEntity: Decodable {
    let name: String
    let url: String?
}