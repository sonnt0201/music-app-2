//  NewReleasesResponse.swift
//  Music App
//
//  Created by Sơn Nguyễn on 16/07/2022.
//

import Foundation

struct NewReleasesResponse: Codable {
    var albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    var items: [Album]
}

struct Album: Codable {
    let name: String
    let album_type: String
    let available_markets: [String]
    let id: String
    var images: [APIImage]
    let release_date: String
    let total_tracks: Int
    let type: String
    let artists: [Artist]
}

