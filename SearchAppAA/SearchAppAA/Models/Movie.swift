//
//  Untitled.swift
//  SearchAppAA
//
//  Created by Maryam on 7/8/25.
//

import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String?
    let releaseDate: String?
    let popularity: Double?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
