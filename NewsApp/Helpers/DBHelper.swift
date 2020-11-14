//
//  DBHelper.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/12/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation
import RealmSwift

final class DBHelper {
    
    fileprivate lazy var realm = try! Realm(configuration: .defaultConfiguration)
    static let shared = DBHelper()
    
    /// Retrieving Articles from Realm, filtering by newsApiType
    /// - Parameter newsApiType: type of API (Top heading, everything)
    /// - Returns: Array of articles
    public func getArticles (newsApiType: NewsApiType) -> [Article]{
        let models = realm.objects(ArticleObject.self).filter({
            $0.categories.contains(newsApiType.rawValue)
        }).sorted { (a, b) -> Bool in
            return (a.publishedAt ?? "") < (b.publishedAt ?? "")
        }
        
        return Array(models).map {
            Article(managedObject: $0)
        }
    }
    
    /// Writing article to Realm Local Database
    /// - Parameters:
    ///   - article: single struct Article
    ///   - apiType: type of API (Top heading, everything)
    ///   - notSavedToArchive: Bool which means that articles is not in archive list
    public func saveArticle (article: Article, apiType: NewsApiType, notSavedToArchive: Bool = false) {
        var _article = article

        if !_article.categories.contains(apiType) && !notSavedToArchive {
            _article.categories.append(apiType)
        }

        self.writeArticle(article: _article)
    }
    
    /// Writing multiple articles
    /// - Parameters:
    ///   - articles: Array of articles
    ///   - apiType: type of API (Top heading, everything)
    ///   - notSavedToArchive: Bool which means that articles is not in archive list
    public func saveArticles (articles: [Article], apiType: NewsApiType, notSavedToArchive: Bool = false) {
        for article in articles {
            self.saveArticle(article: article, apiType: apiType, notSavedToArchive: notSavedToArchive)
        }
    }
}


// MARK: - Private methods

extension DBHelper {
    
    private func save(data: Object) {
        try! realm.write {
            self.realm.add(data, update: .modified)
        }
    }
    
    private func writeArticle (article: Article) {
        let articleCached = article.managedObject()
        save(data: articleCached)
    }
}
