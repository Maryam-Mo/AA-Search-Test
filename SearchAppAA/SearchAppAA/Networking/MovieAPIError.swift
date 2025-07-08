//
//  MovieAPIError.swift
//  SearchAppAA
//
//  Created by Maryam on 7/8/25.
//

import Foundation

enum MovieAPIError: LocalizedError {
  case invalidURL
  case badResponse(statusCode: Int)
  case decoding(Error)
  case error(Error)
  
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "Failed to load URL."
    case let .badResponse(code):
      return "This is status code \(code)."
    case let .decoding(err):
      return "Failed to decode: \(err.localizedDescription)"
    case let .error(err):
      return err.localizedDescription
    }
  }
}
