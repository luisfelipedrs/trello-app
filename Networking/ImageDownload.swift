//
//  ImageDownload.swift
//  trello-app1
//
//  Created by Luis Felipe on 15/02/23.
//

import UIKit

class ImageDownload {
    
    var session: URLSession
    var cache: URLCache
    
    init(session: URLSession = .shared,
         cache: URLCache = .shared) {
        self.session = session
        self.cache = cache
    }
    
    func execute(for url: URL,
                        completeOn completionQueue: DispatchQueue = .main,
                        completionHandler: @escaping (UIImage?, Metadata?, Error?) -> Void) {
        let request = URLRequest(url: url)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            if let cached = self.cache.cachedResponse(for: request), let image = UIImage(data: cached.data) {
                completionQueue.async {
                    completionHandler(
                        image,
                        Metadata(fromCache: true, response: nil),
                        nil
                    )
                }
                
                debugPrint("cache hit for \(request.url!.absoluteURL)")
                return
            }
            
            debugPrint("cache miss for \(request.url!.absoluteURL)")
                        
            self.session.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    completionQueue.async {
                        completionHandler(nil, nil, Error.unableToRequest(error))
                    }
                    return
                }
                
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    
                    completionQueue.async {
                        completionHandler(
                            nil,
                            Metadata(fromCache: false, response: response),
                            Error.failedToFetch
                        )
                    }
                    return
                }
                
                DispatchQueue.global().async {
                    let response = CachedURLResponse(response: response, data: data)
                    
                    self?.cache.storeCachedResponse(response, for: request)
                    debugPrint("cached response for \(request.url!.absoluteURL)")
                }
                
                guard let loadedImage = UIImage(data: data) else {
                    completionQueue.async {
                        completionHandler(
                        nil,
                        Metadata(fromCache: false, response: response),
                        Error.invalidData
                        )
                    }
                    return
                }
                
                completionQueue.async {
                    completionHandler(
                    loadedImage,
                    Metadata(fromCache: false, response: response),
                    nil
                    )
                }
            }.resume()
        }
    }
}

extension ImageDownload {
    struct Metadata {
        let fromCache: Bool
        let response: URLResponse?
    }
}

extension ImageDownload {
    enum Error: Swift.Error, LocalizedError {
        case unableToRequest(Swift.Error)
        case failedToFetch
        case invalidData
        
        var errorDescription: String? {
            switch self {
            case .unableToRequest(let error):
                return "Could not perform the request. \(error.localizedDescription)"
            case .failedToFetch:
                return "Could not download the image."
            case .invalidData:
                return "Could not build image. Possible data corruption."
            }
        }
    }
}
