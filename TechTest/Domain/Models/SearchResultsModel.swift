//
//  SearchResultsModel.swift
//  TechTest
//
//  Created by Mario on 07/11/2026.
//

struct SearchResultsModel {
    let items: [SearchResultsItemModel]
    let count: Int
    let pages: Int
    let nextURL: String?
    let prevURL: String?
}

struct SearchResultsItemModel {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: SearchResultsOriginModel
    let location: SearchResultsLocationModel
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct SearchResultsOriginModel {
    let name: String
    let url: String?
}

struct SearchResultsLocationModel {
    let name: String
    let url: String?
}