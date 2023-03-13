//
//  HTTPRequest.swift
//  trello-app1
//
//  Created by Luis Felipe on 15/02/23.
//

import Foundation

public final class HTTPRequest {
    
    private let urlTemplate: String = "https://api.nasa.gov/planetary/apod?api_key=11eo3Fq4MYriV9fpIX8xyPesobNoV4hwRtrjPxIp&date=2014-10-%@"
    
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func execute<T: Codable>(photoDate: String,
                             method httpMethod: HTTPMethod = .get,
                             body encodable: Encodable? = nil,
                             headers httpHeaders: HTTPHeaders? = nil,
                             decoder: JSONDecoder = .init(),
                             encoder: JSONEncoder = .init(),
                             completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        
        dataTask?.cancel()
        
        let urlString = String(format: urlTemplate, photoDate)
                                
        guard let url = URL(string: urlString) else {
            preconditionFailure("Unable to create URL.")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if let httpHeaders = httpHeaders {
            httpHeaders.forEach { (header, value) in
                request.setValue(value, forHTTPHeaderField: header)
            }
        }
        
        if let encodable = encodable {
            do {
                let data = try encoder.encode(encodable)
                
                request.httpBody = data
                request.setValue("application/json", forHTTPHeaderField: "Content-type")
                
            } catch let error {
                debugPrint(error)
                let contextError = NetworkError.invalidData(error)
                
                completionHandler(.failure(.unableToRequest(contextError)))
                return
            }
        }
        
        dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            let result: HTTPResult<T> = DataTaskResult(value: data, error: error)
                .mapError { error in
                    NetworkError.unableToRequest(error)
                }
                .flatMap { data in
                    return Result { try decoder.decode(T.self, from: data) }
                }
                .flatMapError { error in
                    if let error = error as? NetworkError {
                        return Result.failure(error)
                    }
                    
                    if let response = response as? HTTPURLResponse,
                       !response.inSuccessRange {
                        return Result.failure(.requestFailed(statusCode: response.statusCode))
                    }
                    
                    return Result.failure(.invalidData(error))
                }
            
            completionHandler(result)
        }
        
        dataTask?.resume()
    }
}
