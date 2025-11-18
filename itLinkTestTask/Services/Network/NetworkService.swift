//
//  NetworkService.swift
//  itLinkTestTask
//
//  Created by Alexander Abanshin on 14.11.2025.
//

import Foundation

final class NetworkService {
    private let session: URLSession

      init() {
          let configuration = URLSessionConfiguration.default
          configuration.timeoutIntervalForRequest = 30
          configuration.timeoutIntervalForResource = 60
          self.session = URLSession(configuration: configuration)
      }
    
    func loadImageURLs(from urlString: String) async throws -> [URL] {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: 0)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        guard let text = String(data: data, encoding: .utf8) else {
            throw NetworkError.invalidDataEncoding
        }
        
        let urls = text
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .compactMap { URL(string: $0) }
            .filter { $0.scheme == "https" }
        
        return urls
    }
}

