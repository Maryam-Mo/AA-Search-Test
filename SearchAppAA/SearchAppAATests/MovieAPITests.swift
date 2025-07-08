//
//  MovieAPITests.swift
//  SearchAppAA
//
//  Created by Maryam on 7/9/25.
//

import Combine
import XCTest
@testable import SearchAppAA

@MainActor
final class MovieAPITests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func test_searchMoviesDecoding() {
        let jsonString = """
      {
        "results": [
          {
            "id": 1,
            "title": "movie1",
            "overview": "movie1 overview",
            "popularity": 9.9,
            "release_date": "2025-01-23",
            "vote_average": 8.2,
            "vote_count": 123
          },
          {
            "id": 2,
            "title": "movie2",
            "overview": "movie2 overview",
            "popularity": 4.2,
            "release_date": "2024-12-12",
            "vote_average": 7.0,
            "vote_count": 77
          }
        ]
      }
      """
        let data = jsonString.data(using: .utf8)!
        
        MockURLProtocol.mockResponseData = data
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "https://api.themoviedb.org")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockError = nil
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        let api = MovieAPI(apiKey: "fake", urlSession: session)
        
        let expectation = self.expectation(description: "decode")
        var received: [Movie]?
        var receivedError: Error?
        
        api.searchMovies(query: "foo", page: 1, perPage: 10)
            .sink { completion in
                if case .failure(let err) = completion {
                    receivedError = err
                }
                expectation.fulfill()
            } receiveValue: { movies in
                received = movies
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
        
        XCTAssertNil(receivedError)
        XCTAssertEqual(received?.count, 2)
        
        XCTAssertEqual(received?[0].id, 1)
        XCTAssertEqual(received?[0].title, "movie1")
        XCTAssertEqual(received?[0].overview, "movie1 overview")
        XCTAssertEqual(received?[0].popularity, 9.9)
        
        XCTAssertEqual(received?[1].id, 2)
        XCTAssertEqual(received?[1].title, "movie2")
    }
}
