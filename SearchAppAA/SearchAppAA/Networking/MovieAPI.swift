//
//  MovieAPI.swift
//  SearchAppAA
//
//  Created by Maryam on 7/8/25.
//

import Foundation
import Combine

protocol MovieRepository {
    func searchMovies(
        query: String,
        page: Int,
        perPage: Int
    ) -> AnyPublisher<[Movie], MovieAPIError>
}

final class MovieAPI: MovieRepository {
    private let apiKey: String
    private let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")!
    private let urlSession: URLSession
    private let decoder: JSONDecoder
    
    init(
        apiKey: String,
        urlSession: URLSession = .shared,
        decoder: JSONDecoder = {
            let d = JSONDecoder()
            d.keyDecodingStrategy = .convertFromSnakeCase
            return d
        }()
    ) {
        self.apiKey = apiKey
        self.urlSession = urlSession
        self.decoder = decoder
    }
    
    func searchMovies(
        query: String,
        page: Int,
        perPage: Int
    ) -> AnyPublisher<[Movie], MovieAPIError> {
        
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "region", value: "US")
        ]
        
        guard let url = components.url else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url)
        
        struct Response: Codable {
            let results: [Movie]
        }
        
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let http = output.response as? HTTPURLResponse else {
                    throw MovieAPIError.error(URLError(.badServerResponse))
                }
                guard 200..<300 ~= http.statusCode else {
                    throw MovieAPIError.badResponse(statusCode: http.statusCode)
                }
                return output.data
            }
            .mapError { error in
                if let apiError = error as? MovieAPIError {
                    return apiError
                } else {
                    return MovieAPIError.error(error)
                }
            }
            .decode(type: Response.self, decoder: decoder)
            .mapError { error in
                if let apiError = error as? MovieAPIError {
                    return apiError
                } else {
                    return MovieAPIError.decoding(error)
                }
            }
            .map { response in
                let start = 0
                let end = min(perPage, response.results.count)
                return Array(response.results[start..<end])
            }
            .eraseToAnyPublisher()
    }
}
