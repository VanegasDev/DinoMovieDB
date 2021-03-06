//
//  TMDBLogin.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/5/21.
//

import Foundation

struct LoginParameters: Encodable {
    let username: String
    let password: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case requestToken = "request_token"
    }
}

struct SessionToken: Decodable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
