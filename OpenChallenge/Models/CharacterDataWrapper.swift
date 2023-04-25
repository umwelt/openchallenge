//
//  CharacterDataWrapper.swift
//  OpenChallenge
//
//  Created by Hugo Perez on 24/4/23.
//

import Foundation

struct CharacterDataWrapper: Codable {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let data: CharacterDataContainer?
    let etag: String?
}
