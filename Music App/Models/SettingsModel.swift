//
//  SettingsModel.swift
//  Music App
//
//  Created by Sơn Nguyễn on 15/07/2022.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title:String
    let handler: () -> ()
}
