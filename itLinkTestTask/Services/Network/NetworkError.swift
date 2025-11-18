//
//  NetworkError.swift
//  autodocNews
//
//  Created by Alexander Abanshin on 27.10.2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingFailed(Error)
    case connectionFailed(Error)
    case invalidDataEncoding
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL or parameters"
        case .invalidResponse(let statusCode):
            return "Server returned unexpected status code: \(statusCode)"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .connectionFailed(let error):
            return "Network connection failed: \(error.localizedDescription)"
        case .invalidDataEncoding:
            return "Failed to decode response data"
        }
    }
}
