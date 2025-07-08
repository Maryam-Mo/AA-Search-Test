//
//  UserDefaultsHistoryRepository.swift
//  SearchAppAA
//
//  Created by Maryam on 7/8/25.
//

import Foundation

protocol HistoryRepository {
    func load() -> [SearchHistory]
    func save(history: [SearchHistory])
}

struct UserDefaultsHistoryRepository: HistoryRepository {
    private let key = "search_history"
    
    func load() -> [SearchHistory] {
        guard let data = UserDefaults.standard.data(forKey: key), let decoded = try? JSONDecoder().decode([SearchHistory].self, from: data) else {
            return []
        }
        return decoded
    }
    
    func save(history: [SearchHistory]) {
        guard let data = try? JSONEncoder().encode(history) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
