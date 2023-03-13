//
//  NetworkingUtils.swift
//  trello-app1
//
//  Created by Luis Felipe on 15/02/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension HTTPURLResponse {
    var inSuccessRange: Bool {
        return statusCode >= 200 && statusCode <= 299
    }
}

typealias HTTPHeaders = [String: String]

enum NetworkError: Error, LocalizedError {
    case unableToRequest(Error)
    case requestFailed(statusCode: Int)
    case invalidData(Error)
    
    var errorDescription: String? {
        switch self {
        case .unableToRequest(let error):
            return "Unable to perform the request. \(error.localizedDescription)"
        case .requestFailed:
            return "Request failed."
        case .invalidData:
            return "Unable to parse request data."
        }
    }
}

extension Result {
    
    init(value: Success?, error: Failure?) {
        if let error = error {
            self = .failure(error)
            return
        }
        
        if let value = value {
            self = .success(value)
            return
        }
        
        fatalError()
    }
}

typealias DataTaskResult = Result<Data, Error>
typealias HTTPResult<Success> = Result<Success, NetworkError>
