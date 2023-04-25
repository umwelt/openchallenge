//
//  ImageFromURL.swift
//  OpenChallenge
//
//  Created by Hugo Perez on 24/4/23.
//

import UIKit

struct ImageFromURL {

    static func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Error loading image from URL: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }
}
