//
//  CharacterDetailModel.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

struct CharacterDetailModel {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterDetailOriginModel
    let location: CharacterDetailLocationModel
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct CharacterDetailOriginModel {
    let name: String
    let url: String?
}

struct CharacterDetailLocationModel {
    let name: String
    let url: String?
}
