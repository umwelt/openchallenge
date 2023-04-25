//
//  APISecret.swift
//  OpenChallenge
//
//  Created by Hugo Perez on 24/4/23.
//

import Foundation
import Security

class APISecret {
    private static let keychainService = "com.open.zone.publicKey"
    private static let apiKeyAccount = ""

    private static let privateKeyAccount = ""
    private static let privateKeyService = "com.open.zone.privateKey"

}

// MARK: - Public Keys
extension APISecret {
    static func storeAPIKey(_ key: String) {
        if let data = key.data(using: .utf8) {
            let query: [NSString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: keychainService,
                kSecAttrAccount: apiKeyAccount,
                kSecValueData: data
            ]
            SecItemAdd(query as CFDictionary, nil)
        }
    }

    static func retrieveAPIKey() -> String? {
        let query: [NSString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: keychainService,
            kSecAttrAccount: apiKeyAccount,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: kCFBooleanTrue as Any
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
}

// MARK: - Private Key
extension APISecret {
    static func storePrivateKey(_ key: String) {
        if let data = key.data(using: .utf8) {
            let query: [NSString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: privateKeyService,
                kSecAttrAccount: privateKeyAccount,
                kSecValueData: data
            ]
            SecItemAdd(query as CFDictionary, nil)
        }
    }

    static func retrievePrivateKey() -> String? {
        let query: [NSString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: privateKeyService,
            kSecAttrAccount: privateKeyAccount,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: kCFBooleanTrue as Any
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
}
