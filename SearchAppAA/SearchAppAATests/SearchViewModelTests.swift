//
//  SearchAppAATests.swift
//  SearchAppAATests
//
//  Created by Maryam on 7/4/25.
//

import XCTest
import Combine
@testable import SearchAppAA

@MainActor
final class SearchViewModelTests: XCTestCase {
    private var api = MockMovieAPI()
    private var historyRepository = MockHistoryRepository()
    private var viewModel: SearchViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        api = MockMovieAPI()
        historyRepository = MockHistoryRepository()
        viewModel = SearchViewModel(api: api, historyRepository: historyRepository)
    }
    
    func test_emptyQuery() async {
        viewModel?.query = ""
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertTrue(((viewModel?.movies.isEmpty) != nil))
    }
    
    func test_searchIsSuccessful() async {
        let movie = [Movie(id: 1, title: "mov", overview: nil, releaseDate: nil, popularity: 0, voteAverage: 0, voteCount: 0)]
        api.mode = .success(movie)
        
        viewModel?.query = "mov"
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(viewModel?.movies, movie)
        XCTAssertNil(viewModel?.errorMessage)
    }
    
    func test_searchIsFailed() async {
        api.mode = .failure(.badResponse(statusCode: 500))
        
        viewModel?.query = "something"
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        let expected = MovieAPIError.badResponse(statusCode: 500).localizedDescription
        
        XCTAssertEqual(viewModel?.errorMessage, expected)
        XCTAssertTrue(((viewModel?.movies.isEmpty) != nil))
    }
    
    func test_addHistory() {
        let movie = Movie(id: 1, title: "mov", overview: nil, releaseDate: nil, popularity: 0, voteAverage: 0, voteCount: 0)
        viewModel?.addHistory(movie: movie)
        viewModel?.addHistory(movie: movie)
        
        XCTAssertEqual(viewModel?.history.count, 1)
        
        for i in 0..<15 {
            viewModel?.addHistory(movie: Movie(id: i, title: "\(i)", overview: nil, releaseDate: nil, popularity: 0, voteAverage: 0, voteCount: 0))
        }
        
        XCTAssertEqual(viewModel?.history.count, AppLayout.maxResultsCount)
        XCTAssertEqual(historyRepository.saved, viewModel?.history)
    }
}
