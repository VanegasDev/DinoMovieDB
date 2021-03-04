//
//  RequestToken.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/3/21.
//

import Foundation

struct RequestToken: Codable {
    let success: Bool
    let expiresAt: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case token = "request_token"
    }
}
