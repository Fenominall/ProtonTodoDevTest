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
    static func encrypt(_ data: Data) throws -> Data {
        do {
            let sealBox = try AES.GCM.seal(data, using: cryptoKey)
            guard let combined = sealBox.combined else {
                throw CryptoManagerError.encryptionFailed
            }
            return combined
        } catch {
            throw CryptoManagerError.encryptionFailed
        }
    }
    
    static func decrypt(_ data: Data) throws -> Data? {
        do {
            let sealBox = try AES.GCM.SealedBox(combined: data)
            return try AES.GCM.open(sealBox, using: cryptoKey)
        } catch {
            throw CryptoManagerError.decryptionFailed
        }
    }
    
    // MARK: - Encrypt and Decrypt String
    static func encryptString(_ string: String) throws -> Data? {
        do {
            guard let data = string.data(using: .utf8) else {
                throw CryptoManagerError.invalidData
            }
            return try encrypt(data)
        } catch{
            throw CryptoManagerError.decryptionFailed
        }
    }
    
    static func decryptString(_ data: Data) throws -> String? {
        do {
            guard let decryptedData = try decrypt(data) else {
                throw CryptoManagerError.decryptionFailed
            }
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            throw CryptoManagerError.decryptionFailed
        }
    }
    
    // MARK: - Encrypt and Decrypt Date
    private static func dateToData(_ date: Date) throws -> Data {
        let timeInterval = date.timeIntervalSinceReferenceDate
        return withUnsafeBytes(of: timeInterval) { Data($0) }
    }
    
    private static func dataToDate(_ data: Data) throws -> Date? {
        guard data.count == MemoryLayout<TimeInterval>.size else { return nil }
        let timeInterval = data.withUnsafeBytes { $0.load(as: TimeInterval.self) }
        return Date(timeIntervalSinceReferenceDate: timeInterval)
    }
    
    static func encryptDate(_ date: Date) throws -> Data? {
        do {
            let encryptedData = try dateToData(date)
            return try? encrypt(encryptedData)
        } catch {
            throw CryptoManagerError.encryptionFailed
        }
    }
    
    static func decryptDate(_ data: Data) throws -> Date? {
        do {
            guard let decryptedData = try? decrypt(data) else {
                throw CryptoManagerError.decryptionFailed
            }
            return try dataToDate(decryptedData)
        } catch {
            throw CryptoManagerError.decryptionFailed
        }
    }
}
