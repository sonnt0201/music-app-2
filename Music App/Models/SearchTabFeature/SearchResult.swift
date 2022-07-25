//
//  SearchResult.swift
//  Music App
//
//  Created by Sơn Nguyễn on 22/07/2022.
//

import Foundation
enum SearchResult{
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
