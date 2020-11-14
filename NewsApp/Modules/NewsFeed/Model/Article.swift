//
//  Article.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/11/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import RealmSwift

enum ArticleStatus: String, Decodable {
    case ok = "ok"
    case error = "error"
}

struct ArticleResponse: Decodable {
    var totalResults: Int
    var articles: [Article]
    var status: ArticleStatus
    var message: String?
}

struct Article: Decodable {
    var source: ArticleSource
    var author: String?
    var title: String
    var url: String
    var urlToImage: String?
    var isSaved: Bool? = false
    var parsedContent: String?
    @DefaultEmptyArray var categories: [NewsApiType] = []
    
    @DateFormatted<ISO8601Wrapper> var publishedAt: String
}

struct ArticleSource: Decodable {
    var name: String
}

extension Article: Persistable {
    public init(managedObject: ArticleObject) {
        source = ArticleSource(name: managedObject.sourceName ?? "")
        author = managedObject.author
        title = managedObject.title ?? ""
        url = managedObject.url ?? ""
        urlToImage = managedObject.urlToImage ?? ""
        isSaved = managedObject.isSaved
        publishedAt = managedObject.publishedAt ?? ""
        parsedContent = managedObject.content
        categories = managedObject.categories.map({ (category) -> NewsApiType in
            return NewsApiType(rawValue: category)!
        })
    }
    
    
    
    public func managedObject() -> ArticleObject {
        let articleCached = ArticleObject()
        articleCached.author = self.author
        articleCached.sourceName = self.source.name
        articleCached.url = self.url
        articleCached.urlToImage = self.urlToImage
        articleCached.isSaved = self.isSaved ?? false
        articleCached.publishedAt = self._publishedAt.value
        articleCached.title = self.title
        articleCached.categories.append(objectsIn: self.categories.map {$0.rawValue})
        articleCached.content = self.parsedContent
        return articleCached
    }
}

extension Article: Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.title == rhs.title && lhs.publishedAt == rhs.publishedAt && lhs.url == rhs.url
    }
}
