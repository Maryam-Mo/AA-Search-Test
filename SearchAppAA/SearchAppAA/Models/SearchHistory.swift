//
//  SearchHistory.swift
//  SearchAppAA
//
//  Created by Maryam on 7/8/25.
//

import Foundation

struct SearchHistory: Identifiable, Codable {
    let id: UUID
    let movie: Movie
    let date: Date
    
    init(movie: Movie, date: Date = Date()) {
        self.id = UUID()
        self.movie = movie
        self.date = date
    }
}
