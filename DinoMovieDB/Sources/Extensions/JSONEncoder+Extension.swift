//
//  JSONEncoder+Extension.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/24/21.
//

import Foundation

extension JSONEncoder {
    // MARK: Extension to map an object and convert it into an dictionary
    func encodeAsDictionary<T: Encodable>(_ encode: T) -> [String: Any]? {
        guard let data = try? self.encode(encode) else { return nil }
        
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }

        return dictionary
    }
}
