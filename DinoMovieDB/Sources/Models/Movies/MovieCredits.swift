//
//  MovieCredits.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/28/21.
//

import Foundation

struct CastPerson: Decodable {
    let id: Int
    let name: String
    let character: String
}

struct CrewPerson: Decodable {
    let id: Int
    let name: String
    let job: String
}

struct Credits: Decodable {
    let id: Int
    let cast: [CastPerson]
    let crew: [CrewPerson]
}
