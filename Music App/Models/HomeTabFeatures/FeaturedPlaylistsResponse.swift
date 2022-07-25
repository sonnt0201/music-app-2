//
//  FeaturedPlaylistsResponse.swift
//  Music App
//
//  Created by Sơn Nguyễn on 16/07/2022.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistsResponse
}

struct PlaylistsResponse: Codable {
    let items: [Playlist]
}



struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}
