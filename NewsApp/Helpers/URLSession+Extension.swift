//
//  URLSession+Extension.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/13/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

extension URLSession {
    
    func request<T:Decodable> (
        for: T.Type = T.self,
        _ endpoint: Endpoint,
        completion: @escaping (Swift.Result<T, RequestError>) -> Void) {
        let request = createRequest(from: endpoint)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let jsonData = data else {
                    completion(.failure(.noData))
                    return
                }
                
                guard error == nil else {
                    completion(.failure(.withParameter(message: error!.localizedDescription)))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let jsonResponse = try decoder.decode(T.self, from: jsonData)
                    completion(.success(jsonResponse))
                } catch {
                    if let data = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? NSDictionary {
                        completion(.failure(.withDic(data: data)))
                    } else {
                        completion(.failure(.undefined))
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    func createRequest (from endpoint: Endpoint) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = endpoint.baseURL
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        return URLRequest(url: urlComponents.url!)
    }
}
