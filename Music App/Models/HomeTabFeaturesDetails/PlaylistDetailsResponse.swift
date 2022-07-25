//
//  PlaylistDetailsResponse.swift
//  Music App
//
//  Created by Sơn Nguyễn on 20/07/2022.
//

import Foundation

struct PlaylistsDetailResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTracksResponse
     
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}
