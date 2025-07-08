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
    ) -> AnyPublisher<[Movie], Error>
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
    ) -> AnyPublisher<[Movie], Error> {
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "region", value: "US")
        ]
        
        let url = (components?.url)!
        
        let request = URLRequest(url: url)
        
        struct Response: Codable {
            let results: [Movie]
        }
        
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let http = output.response as? HTTPURLResponse,
                      200..<300 ~= http.statusCode
                else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: Response.self, decoder: decoder)
            .map { response in
                let start = 0
                let end = min(perPage, response.results.count)
                return Array(response.results[start..<end])
            }
            .eraseToAnyPublisher()
    }
}
