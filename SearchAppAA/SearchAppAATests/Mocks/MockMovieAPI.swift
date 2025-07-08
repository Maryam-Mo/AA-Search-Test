//
//  MockMovieAPI.swift
//  SearchAppAA
//
//  Created by Maryam on 7/8/25.
//

import Combine
@testable import SearchAppAA

final class MockMovieAPI: MovieRepository {
    enum Mode {
        case success([Movie])
        case failure(MovieAPIError)
    }
    
    var mode: Mode = .success([])
    
    func searchMovies(query: String, page: Int, perPage: Int) -> AnyPublisher<[Movie], MovieAPIError> {
        switch mode {
        case .success(let movies):
            return Just(movies)
                .setFailureType(to: MovieAPIError.self)
                .eraseToAnyPublisher()
            
        case .failure(let apiError):
            return Fail(error: apiError)
                .eraseToAnyPublisher()
        }
    }
}
