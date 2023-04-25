//
//  APIManager.swift
//  OpenChallenge
//
//  Created by Hugo Perez on 24/4/23.
//

import Foundation

protocol APIManagerProtocol {
    func getCharacters(completion: @escaping (Result<[Character], APIError>) -> Void)
    func getCharacterDetail(characterId: Int, completion: @escaping (Result<Character, Error>) -> Void)
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case networkError(Error)
    case limitGreaterThan100
    case limitInvalidOrBelow1
    case invalidOrUnrecognizedParameter
    case emptyParameter
    case invalidOrUnrecognizedOrderingParameter
    case tooManyValuesInFilter
    case invalidValueInFilter
}

class APIManager: APIManagerProtocol {
    private let publicKey: String
    private let privateKey: String

    init(publicKey: String, privateKey: String) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }


    private var baseURLComponents: URLComponents {
        var urlComponents = URLComponents(string: "https://gateway.marvel.com/v1/public")!
        let ts = "\(Date().timeIntervalSince1970)"
        let hash = Crypto.MD5("\(ts)\(privateKey)\(publicKey)")

        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "ts", value: ts),
            URLQueryItem(name: "hash", value: hash)
        ]

        return urlComponents
    }

    func getCharacters(completion: @escaping (Result<[Character], APIError>) -> Void) {
        var urlComponents = baseURLComponents
        urlComponents.path = "/v1/public/characters"

        let request = URLRequest(url: urlComponents.url!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
            } else if let httpResponse = response as? HTTPURLResponse,
                !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(.invalidResponse))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let response = try decoder.decode(CharacterDataWrapper.self, from: data)
                    if let results = response.data?.results {
                        completion(.success(results))
                    } else {
                        completion(.failure(.invalidResponse))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
            } else {
                completion(.failure(.invalidResponse))
            }
        }.resume()
    }

    func getCharacterDetail(characterId: Int, completion: @escaping (Result<Character, Error>) -> Void) {
        var urlComponents = baseURLComponents
        urlComponents.path = "/v1/public/characters/\(characterId)"

        let request = URLRequest(url: urlComponents.url!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let response = try decoder.decode(CharacterDataWrapper.self, from: data)
                    if let character = response.data?.results?.first {
                        completion(.success(character))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Character not found"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
