//
//  PhotoApi.swift
//  trello-app1
//
//  Created by Luis Felipe on 15/02/23.
//

import Foundation

public class PhotoApi {
    
    private let httpRequest: HTTPRequest
    
    init(httpRequest: HTTPRequest = .init()) {
        self.httpRequest = httpRequest
    }
    
    func getPhoto(completionHandler: @escaping (PhotoApi.Result<ApiResponse>) -> Void,
                  completeOn completionQueue: DispatchQueue = .main) {
        
        httpRequest.execute { (result: HTTPResult<ApiResponse>) in
            
            switch result {
            case .success(let photo):
                completionQueue.async {
                    completionHandler(.success(photo))
                }
                
            case .failure(let error):
                debugPrint(error)
                
                completionQueue.async {
                    completionHandler(.failure(.failedToExecute(error)))
                }
            }
        }
    }
}

extension PhotoApi {
    
    typealias Result<Success> = Swift.Result<Success, PhotoApi.Error>
    
    enum Error: Swift.Error, LocalizedError {
        case failedToExecute(NetworkError)
        
        var errorDescription: String? {
            switch self {
            case .failedToExecute(let error):
                return error.localizedDescription
            }
        }
    }
}
