//
//  ComicList.swift
//  OpenChallenge
//
//  Created by Hugo Perez on 24/4/23.
//

import Foundation

struct ComicList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [ComicSummary]?
}
