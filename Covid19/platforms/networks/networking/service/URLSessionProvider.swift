//
//  URLSessionProvider.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/29/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation

final class URLSessionProvider<EndPointProvider: EndPoint>: Provider {
    
    private var session: URLSessionProtocol
    private var task: URLSessionTask?
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request(_ endPoint: EndPointProvider, completion: @escaping (NetworkResponse) -> ()) {
        guard let request = URLRequest(endPoint: endPoint) else { return }
        // Can be log network request here
        print("URL  \(request.url!)")
        task = session.dataTask(request: request, completionHandler: { [weak self] data, response, error in
            guard error == nil else {
                completion(.failure(error!.localizedDescription))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                self?.handleDataResponse(data: data, response: httpResponse, completion: completion)
            } else {
                completion(.failure(NetworkError.noData.rawValue))
                return
            }
        })
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    private func handleDataResponse(data: Data?, response: HTTPURLResponse, completion: (NetworkResponse) -> ())  {
        
        switch response.statusCode {
        case 200...299:
            guard let data = data else { return completion(.failure(NetworkError.noData.rawValue)) }
        
            completion(.success(data))
            break
        case 401...500:
            completion(.failure(NetworkError.authenticationError.rawValue))
            break
        case 501...599:
            completion(.failure(NetworkError.badRequest.rawValue))
            break
        case 600:
            completion(.failure(NetworkError.outdated.rawValue))
            break
        default:
            completion(.failure(NetworkError.failed.rawValue))
            break
        }
    }
    
}
