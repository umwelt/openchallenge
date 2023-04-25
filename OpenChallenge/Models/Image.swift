//
//  Image.swift
//  OpenChallenge
//
//  Created by Hugo Perez on 24/4/23.
//

import Foundation

struct Image: Codable {
    let path: String?
    let fileExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case fileExtension = "extension"
    }
}
