//
//  KeyChainModel.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/24.

import UIKit
import Security

class Keychain {
    
    class func save(key: String, data: Data) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        
        return status == noErr
    }
    
    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue as Any,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef: AnyObject?
        let status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        
        if status == errSecSuccess {
            if let data = dataTypeRef as! Data? {
                return data
            }
        }
        return nil
    }
    
    class func delete(key: String) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key ] as [String : Any]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status == noErr
    }
    
    
    class func clear() -> Bool {
        let query = [ kSecClass as String : kSecClassGenericPassword ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status == noErr
    }
    
}


////
////  KeyChainModel.swift
////  TripDiary
////
////  Created by taeuk on 2021/03/24.
////
//
//import Foundation
//import Security
//
//final class StorageManager {
//
//    // MARK: Shared instance
//    static let shared = StorageManager()
//    private init() { }
//
//    // MARK: Keychain
//
//    private let account = "Service"
//    private let service = Bundle.main.bundleIdentifier
//
//    private lazy var query: [CFString: Any]? = {
//        guard let service = self.service else { return nil }
//        return [kSecClass: kSecClassGenericPassword,
//                kSecAttrService: service,
//                kSecAttrAccount: account]
//    }()
//
//    func createUser(key: String, data: Data) -> Bool {
//
//
//        let query = [
//            kSecClass as String: kSecClassGenericPassword as String,
//            kSecAttrService as String: key
//            kSecValueData as String: data ] as [String : Any]
//
//        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
//    }
//
//    func readUser() -> User? {
//        guard let service = self.service else { return nil }
//        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
//                                      kSecAttrService: service,
//                                      kSecAttrAccount: account,
//                                      kSecMatchLimit: kSecMatchLimitOne,
//                                      kSecReturnAttributes: true,
//                                      kSecReturnData: true]
//
//        var item: CFTypeRef?
//        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }
//
//        guard let existingItem = item as? [String: Any],
//              let data = existingItem[kSecAttrGeneric as String] as? Data,
//              let user = try? JSONDecoder().decode(User.self, from: data) else { return nil }
//
//        return user
//    }
//
//    func updateUser(_ user: User) -> Bool {
//        guard let query = self.query,
//              let data = try? JSONEncoder().encode(user) else { return false }
//
//        let attributes: [CFString: Any] = [kSecAttrAccount: account,
//                                           kSecAttrGeneric: data]
//
//        return SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecSuccess
//    }
//
//    func deleteUser() -> Bool {
//        guard let query = self.query else { return false }
//        return SecItemDelete(query as CFDictionary) == errSecSuccess
//    }
//}
