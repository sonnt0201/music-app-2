//
//  AudioTrack.swift
//  Music App
//
//  Created by Sơn Nguyễn on 10/07/2022.
//

import Foundation

struct AudioTrack: Codable {
    var album: Album?
    var artists: [Artist]
    var available_markets: [String]
    var disc_number: Int
    var duration_ms: Int
    var explicit: Bool
    var external_urls: [String: String]
    var id: String
    var name: String
    var popularity: Int?
    var preview_url: String?
}
