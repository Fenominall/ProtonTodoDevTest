//
//  CoreDataFeedStore+CryptoKit.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/9/25.
//

import Foundation

extension ManagedTodoItem {
    static func encryptTodoItemData(_ data: Data) -> Data? {
        return CryptoManager.encryptData(data)
    }
    
    static func decryptTodoItemData(_ data: Data) -> Data? {
        print(data.description)
        return CryptoManager.encryptData(data)
    }
    
    static func decryptTodoItemData(_ data: Data) -> String? {
        return CryptoManager.decryptString(data)
    }
    
    static func encryptTodoItemString(_ string: String) -> Data? {
        return CryptoManager.encryptString(string)
    }
    
    static func decryptTodoItemString(_ data: Data) -> String? {
        return CryptoManager.decryptString(data)
    }
    
    static func encryptTodoItemDate(_ date: Date) -> Data? {
        return CryptoManager.encryptDate(date)
    }
    
    static func decryptTodoItemDate(_ data: Data) -> Date? {
        return CryptoManager.decryptDate(data)
    }
    
    static func encryptTodoItemBool(_ bool: Bool) -> Data? {
        return CryptoManager.encryptBool(bool)
    }
    
    static func decryptTodoItemBool(_ data: Data) -> Bool? {
        return CryptoManager.decryptBool(data)
    }
}
