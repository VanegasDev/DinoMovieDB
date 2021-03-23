//
//  Storable.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/19/21.
//

import Foundation

protocol Storable: Codable {
    func save(key value: String, on storage: AnyStorage, using encoder: JSONEncoder) throws
    static func get(key value: String, from storage: AnyStorage, using decoder: JSONDecoder) -> Self?
    static func remove(key value: String, from storage: AnyStorage)
}

extension Storable {
    func save(key value: String = String(describing: Self.self), on storage: AnyStorage, using encoder: JSONEncoder = JSONEncoder()) throws {
        let data = try encoder.encode(self)
        try storage.save(data: data, key: value)
    }
    
    static func get(key value: String = String(describing: Self.self), from storage: AnyStorage, using decoder: JSONDecoder = JSONDecoder()) -> Self? {
        guard let data = storage.get(key: value) else { return nil }
        
        return try? decoder.decode(Self.self, from: data)
    }
    
    static func remove(key value: String = String(describing: Self.self), from storage: AnyStorage) {
        storage.remove(key: value)
    }
}
