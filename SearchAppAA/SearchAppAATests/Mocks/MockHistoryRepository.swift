//
//  MockHistoryRepository.swift
//  SearchAppAA
//
//  Created by Maryam on 7/8/25.
//

import XCTest
@testable import SearchAppAA

class MockHistoryRepository: HistoryRepository {
    private(set) var saved: [SearchHistory] = []
    
    func load() -> [SearchHistory] {
        return []
    }
    
    func save(history: [SearchHistory]) {
        saved = history
    }
}
