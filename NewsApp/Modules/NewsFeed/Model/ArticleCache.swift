//
//  ArticleCache.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/12/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//


import Foundation
import RealmSwift

protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject(newsApiType: NewsApiType) -> ManagedObject
}

@objcMembers
class ArticleCached: Object {
    dynamic var id: String?
    dynamic var author: String?
    dynamic var title: String?
    dynamic var url: String?
    dynamic var urlToImage: String?
    dynamic var publishedAt: String?
    dynamic var sourceName: String?
    dynamic var categoryName: String?
    dynamic var isSaved = false
    dynamic var content: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
