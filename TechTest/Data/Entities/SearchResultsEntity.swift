//
//  SearchResultsEntity.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

import Foundation

struct SearchResultsEntity: Decodable {
    let info: SearchResultsInfoEntity
    let results: [SearchResultsItemEntity]
}

struct SearchResultsInfoEntity: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct SearchResultsItemEntity: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: SearchResultsOriginEntity
    let location: SearchResultsLocationEntity
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct SearchResultsOriginEntity: Decodable {
    let name: String
    let url: String?
}

struct SearchResultsLocationEntity: Decodable {
    let name: String
    let url: String?
}