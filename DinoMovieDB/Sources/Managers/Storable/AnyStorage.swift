//
//  AnyStorage.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/19/21.
//

import Foundation
import KeychainSwift

// Protocol for storage methods
protocol Storage {
    func get(key: String) -> Data?
    func save(data: Data, key: String) throws
    func remove(key: String)
}

// Handler of any kind of storage type
struct AnyStorage {
    private let storage: Storage
    
    init(using storage: Storage) {
        self.storage = storage
    }
    
    func save(data: Data, key value: String) throws {
        try storage.save(data: data, key: value)
    }
    
    func get(key value: String) -> Data? {
        storage.get(key: value)
    }
    
    func remove(key value: String) {
        storage.remove(key: value)
    }
}

extension AnyStorage {
    static let keychainSwift = AnyStorage(using: KeychainSwift())
}

// MARK: Implementation
extension KeychainSwift: Storage {
    func get(key: String) -> Data? {
        getData(key)
    }
    
    func save(data: Data, key: String) throws {
        set(data, forKey: key)
    }
    
    func remove(key: String) {
        delete(key)
    }
}
