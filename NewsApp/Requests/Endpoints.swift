//
//  Endpoints.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/11/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

enum Endpoint {
    
    case getTopHeadlines (apiKey: String, quote: String, page: Int)
    case getEverything (apiKey: String, quote: String, page: Int)
    
    var baseURL: String {
        return "newsapi.org"
    }
    
    var path: String {
        switch self {
        case .getEverything(_, _, _):
            return "/v2/everything"
        case .getTopHeadlines(_, _, _):
            return "/v2/top-headlines"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getEverything(apiKey: let key, quote: let quoteStr, let page):
            return [
                URLQueryItem(name: "apiKey", value: key),
                URLQueryItem(name: "q", value: quoteStr),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .getTopHeadlines(apiKey: let key, quote: let quoteStr, let page):
            return [
                URLQueryItem(name: "apiKey", value: key),
                URLQueryItem(name: "q", value: quoteStr),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        }
    }
}

enum RequestError: Error {
    case noData
    case withParameter (message: String)
    case withDic(data: NSDictionary)
    case undefined
}

extension RequestError {
    var errorMsg: String {
        switch self {
        case .noData:
            return "Не удалось найти данные"
        case .withParameter(message: let msg):
            return msg
        case .withDic(data: let data):
            return data["message"] as? String ?? "Ничего не найдено"
        case .undefined:
            return "Ничего не найдено"
        }
    }
}
