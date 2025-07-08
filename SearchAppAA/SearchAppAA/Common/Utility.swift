//
//  Utility.swift
//  SearchAppAA
//
//  Created by Maryam on 7/8/25.
//

import Combine
import Foundation

enum Config {
    static var appAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "AppAPIKey") as? String, !key.isEmpty else {
            fatalError("AppAPIKey in plist is missing")
        }
        return key
    }
}

protocol URLSessionType {
    func dataTaskPublisher(
        for request: URLRequest
    ) -> AnyPublisher<(data: Data, response: URLResponse), MovieAPIError>
}

extension URLSession: URLSessionType {
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), MovieAPIError> {
        let publisher = URLSession.DataTaskPublisher(request: request, session: self)
        return publisher
            .mapError { MovieAPIError.error($0) }
            .eraseToAnyPublisher()
    }
}
