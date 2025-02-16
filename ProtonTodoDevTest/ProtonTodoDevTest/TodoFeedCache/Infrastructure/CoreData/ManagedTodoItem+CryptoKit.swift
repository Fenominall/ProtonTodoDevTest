//
//  CoreDataFeedStore+CryptoKit.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/9/25.
//

import Foundation

import Foundation

extension ManagedTodoItem {
    // Encrypt Data
    static func encryptTodoItemData(_ data: Data) -> Data? {
        do {
            return try CryptoManager.encrypt(data)
        } catch {
            print("Data Encryption failed: \(error)")
            return nil
        }
    }

    // Decrypt Data
    static func decryptTodoItemData(_ data: Data) -> Data? {
        do {
            return try CryptoManager.decrypt(data)
        } catch {
            print("Data Decryption failed: \(error)")
            return nil
        }
    }

    // Encrypt String
    static func encryptTodoItemString(_ string: String) -> Data? {
        do {
            return try CryptoManager.encryptString(string)
        } catch {
            print("String Encryption failed: \(error)")
            return nil
        }
    }

    // Decrypt String
    static func decryptTodoItemString(_ data: Data) -> String? {
        do {
            return try CryptoManager.decryptString(data)
        } catch {
            print("String Decryption failed: \(error)")
            return nil
        }
    }

    // Encrypt Date
    static func encryptTodoItemDate(_ date: Date) -> Data? {
        do {
            return try CryptoManager.encryptDate(date)
        } catch {
            print("Date Encryption failed: \(error)")
            return nil
        }
    }

    // Decrypt Date
    static func decryptTodoItemDate(_ data: Data) -> Date? {
        do {
            return try CryptoManager.decryptDate(data)
        } catch {
            print("Date Decryption failed: \(error)")
            return nil
        }
    }
}
