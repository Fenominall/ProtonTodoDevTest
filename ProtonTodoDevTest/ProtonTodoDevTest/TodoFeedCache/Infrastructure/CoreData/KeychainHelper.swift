//
//  KeyChainSercretKeyManager.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/9/25.
//

import Foundation
import Security
import CryptoKit

final class KeychainHelper {
    static let keyTag = "com.protontododevtestapp.cryptoKey"

    static func saveKey(_ key: SymmetricKey) {
        let keyData = key.withUnsafeBytes { Data($0) }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyTag,
            kSecValueData as String: keyData
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    static func loadKey() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyTag,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var data: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &data)
        return data as? Data
    }
}
