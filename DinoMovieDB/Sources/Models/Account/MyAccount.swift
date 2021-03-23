//
//  MyAccount.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/22/21.
//

import Foundation

struct MyAccount: Codable {
    let id: Int
    let name: String
    let username: String
    let avatar: Avatar?
}
