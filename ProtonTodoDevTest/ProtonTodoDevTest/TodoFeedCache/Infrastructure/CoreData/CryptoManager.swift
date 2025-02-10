//
//  CryptoManager.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/9/25.
//

import Foundation
import CryptoKit
import Security

enum CryptoManagerError: Error {
    case encryptionFailed
    case decryptionFailed
    case invalidData
    case keyGenerationFailed
}

class CryptoManager {
    
    // MARK: - Keychain Secure Storage
    private static var cryptoKey: SymmetricKey = {
        if let keyData = KeychainHelper.loadKey() {
            return SymmetricKey(data: keyData)
        } else {
            let newKey = SymmetricKey(size: .bits256)
            KeychainHelper.saveKey(newKey)
            return newKey
        }
    }()
    
    // MARK: - Encryption and Decryption Helpers
    private static func encrypt(_ data: Data) throws -> Data {
        let sealBox = try AES.GCM.seal(data, using: cryptoKey)
        return sealBox.combined ?? Data()
    }
    
    private static func decrypt(_ data: Data) throws -> Data {
        let sealBox = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(sealBox, using: cryptoKey)
    }
    
    // MARK: - Encrypt and Decrypt String
    static func encryptString(_ string: String) -> Data? {
        guard let data = string.data(using: .utf8) else { return nil }
        return try? encrypt(data)
    }
    
    static func decryptString(_ data: Data) -> String? {
        guard let decryptedData = try? decrypt(data) else { return nil }
        return String(data: decryptedData, encoding: .utf8)
    }
    
    // MARK: - Encrypt and Decrypt Date
    private static func dateToData(_ date: Date) -> Data {
        let timeInterval = date.timeIntervalSinceReferenceDate
        return withUnsafeBytes(of: timeInterval) { Data($0) }
    }
    
    private static func dataToDate(_ data: Data) -> Date? {
        guard data.count == MemoryLayout<TimeInterval>.size else { return nil }
        let timeInterval = data.withUnsafeBytes { $0.load(as: TimeInterval.self) }
        return Date(timeIntervalSinceReferenceDate: timeInterval)
    }
    
    static func encryptDate(_ date: Date) -> Data? {
        let encryptedData = dateToData(date)
        return try? encrypt(encryptedData)
    }
    
    static func decryptDate(_ data: Data) -> Date? {
        guard let decryptedData = try? decrypt(data) else { return nil }
        return dataToDate(decryptedData)
    }
    
    // MARK: - Encrypt and Decrypt Bool
    private static func boolToData(_ bool: Bool) -> Data? {
        try? JSONEncoder().encode(bool)
    }
    
    private static func dataToBool(_ data: Data) -> Bool? {
        try? JSONDecoder().decode(Bool.self, from: data)
    }
    
    static func encryptBool(_ bool: Bool) -> Data? {
        let encryptedBool = boolToData(bool) ?? Data()
        return try? encrypt(encryptedBool)
    }
    
    static func decryptBool(_ data: Data) -> Bool? {
        guard let decryptedData = try? decrypt(data) else { return nil }
        return dataToBool(decryptedData)
    }
    
    // MARK: - Encrypt and Decrypt Data
    static func encryptData(_ data: Data) -> Data? {
        return try? encrypt(data)
    }
    
    static func decryptData(_ data: Data) -> Data? {
        guard let decryptedData = try? decrypt(data) else { return nil }
        return decryptedData
    }
}
