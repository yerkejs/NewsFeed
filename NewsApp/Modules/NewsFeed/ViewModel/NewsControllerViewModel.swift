//
//  NewsFeedViewController.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/11/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RealmSwift


final class NewsControllerViewModel {
    var isPaginationEnable: Bool = false
    var newsVCType: NewsApiType = .topHeadings
    
    var articles = BehaviorRelay<[Article]>(value: [])
    var errorMessage = PublishSubject<RequestError>()
    var isLoading: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    
    var currentPage = 1
    let apiKey = "e65ee0938a2a43ebb15923b48faed18d"
    let defaultArticlesCount = 15
    
    private var requestTimer: Timer!
}


extension NewsControllerViewModel {
    
    public func loadData (isSync: Bool = false) {
        let endpoint: Endpoint = newsVCType == .topHeadings ? Endpoint.getTopHeadlines(apiKey: apiKey, quote: "Apple", page: currentPage) : Endpoint.getEverything(apiKey: apiKey, quote: "Messi", page: currentPage)
        isLoading.onNext(true)
        
        URLSession.shared.request(for: ArticleResponse.self, endpoint) { (result) in
            self.isLoading.onNext(false)
            switch result {
            case .failure(let err):
                self.errorMessage.onNext(err)
            case .success(let response):
                if response.status == .ok {
                    if isSync {
                        self.addBySync(response: response)
                    } else {
                        self.justReplaceData(with: response)
                    }
                } else {
                    self.errorMessage.onNext(.withParameter(message: response.message ?? ""))
                }
            }
        }
    }

    public func loadArticlesFromLocalDB () {
        let localArticles = DBHelper.shared.getArticles(newsApiType: self.newsVCType)
        self.articles.accept(localArticles)
    }
    
    public func saveToArchive (index: Int) {
        var update = self.articles.value
        update[index].isSaved = !(update[index].isSaved ?? false)
        
        if !(update[index].isSaved ?? false) {
            update[index].categories.removeAll(where: { $0 == self.newsVCType })
        } else if !update[index].categories.contains(newsVCType) {
            update[index].categories.append(newsVCType)
        }
        
        DBHelper.shared.saveArticle(article: update[index], apiType: self.newsVCType, notSavedToArchive: !(update[index].isSaved ?? false))
    
        self.articles.accept(update)
    }
    
    public func loadNewsRepeatitively (timeInterval: TimeInterval = 5) {
        requestTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (_) in
            self.loadData(isSync: true)
        })
    }
}

extension NewsControllerViewModel {
    private func syncSavedArticles (_ articles: [Article]) -> [Article] {
        let localArticles = DBHelper.shared.getArticles(newsApiType: self.newsVCType)
        var resultArticles: [Article] = articles
        
        for (i, article) in resultArticles.enumerated() {
            if let localArticle = localArticles.first(where: { $0.title == article.title }) {
                resultArticles[i].isSaved = localArticle.isSaved
            }
        }
         
        return resultArticles
    }
    
    private func justReplaceData (with articleResponse: ArticleResponse) {
        self.isPaginationEnable = articleResponse.totalResults > self.defaultArticlesCount
        DBHelper.shared.saveArticles(articles: self.syncSavedArticles(articleResponse.articles), apiType: self.newsVCType)
        self.loadArticlesFromLocalDB()
        self.currentPage += 1
    }
    
    private func addBySync (response: ArticleResponse) {
        var currentArticles = self.articles.value
        let responseArticles = self.syncSavedArticles(response.articles)
        
        for responseArticle in responseArticles {
            if let newArticle = currentArticles.first(where: {$0.title != responseArticle.title}) {
                var _newArticle = newArticle
                
                if !_newArticle.categories.contains(self.newsVCType) {
                    _newArticle.categories.append(self.newsVCType)
                }
                
                currentArticles.append(_newArticle)
            }
        }
        
        self.articles.accept(currentArticles)
        DBHelper.shared.saveArticles(articles: currentArticles, apiType: self.newsVCType)
    }
}

