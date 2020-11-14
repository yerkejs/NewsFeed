//
//  NewsDetailViewModel.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/13/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation
import SwiftSoup
import RxSwift
import RxRelay

final class NewsDetailViewModel {
    
    var article: Article! {
        didSet {
            if oldValue == nil || oldValue.isSaved != article.isSaved {
                isSaved.accept(article.isSaved ?? false)
            }
        }
    }
    
    var newsApiType: NewsApiType!
    
    var isSaved = BehaviorRelay<Bool>(value: false)
    
    func toggleSaveArticle () {
        self.article.isSaved = !(self.article.isSaved ?? false)
        DBHelper.shared.saveArticles(articles: [article], apiType: newsApiType, notSavedToArchive: !(self.article.isSaved ?? false))
    }
    
    func parseHTML () -> String {
        if let articleURL = URL(string: article.url) {
            do {
                let htmlString = try String(contentsOf: articleURL)
                let html = try SwiftSoup.parse(htmlString)
                let p = try html.getElementsByTag("p").text()
                return p
            } catch {
                return "Could not parse"
            }
        } else {
            return "Could not parse"
        }
    }
    
    func saveContentOfArticle (content: String) {
        article.parsedContent = content
        DBHelper.shared.saveArticle(article: article, apiType: self.newsApiType)
    }
}
