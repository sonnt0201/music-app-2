//
//  Artist.swift
//  Music App
//
//  Created by Sơn Nguyễn on 10/07/2022.
//

import Foundation


struct Artist: Codable {
    let external_urls: [String: String]
    let href: String
    let id: String
    let name: String
    let type: String
    let images : [APIImage]?
    let uri: String
}
