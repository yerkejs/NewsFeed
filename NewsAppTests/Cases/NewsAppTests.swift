

import XCTest
@testable import NewsApp

class NewsAppTests: XCTestCase {

    // MARK: - NewsControllerViewModel tests
    
    func testArticleDecode () {
        let filePath = Bundle(for: type(of: self)).path(forResource: "ArticleDemo", ofType: ".json")
        let jsonData =  try! Data(contentsOf: URL(fileURLWithPath: filePath!), options: .mappedIfSafe)
        let expectedArticle = Article(source: ArticleSource(name: "The Mac Observer"), author: "Andrew Orr", title: "Facebook Credit Card Scam Exposed via Data Leak", url: "https://www.macobserver.com/link/facebook-credit-card-scam/?utm_source=macobserver&utm_medium=rss&utm_campaign=rss_everything", urlToImage: nil, isSaved: false, parsedContent: nil, categories: [], publishedAt: "2020-11-13T16:25:13Z")
        let articleResponse = try! JSONDecoder().decode(Article.self, from: jsonData as Data)
        XCTAssertEqual(expectedArticle, articleResponse)
    }
    
    func testInitialPaginationParameters () {
        let viewModel = NewsControllerViewModel()
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.defaultArticlesCount, 15)
    }
    
    func testNewsViewModelInitialValues () {
        let viewModel = NewsControllerViewModel()
        XCTAssertEqual(viewModel.apiKey, "e65ee0938a2a43ebb15923b48faed18d")
        XCTAssertEqual(viewModel.articles.value, [])
        XCTAssertEqual(viewModel.isPaginationEnable, false)
        XCTAssertEqual(try! viewModel.isLoading.value(), false)
    }
    
    func testSavePropInDetailViewModel () {
        let expectedArticle = Article(source: ArticleSource(name: "The Mac Observer"), author: "Andrew Orr", title: "Facebook Credit Card Scam Exposed via Data Leak", url: "https://www.macobserver.com/link/facebook-credit-card-scam/?utm_source=macobserver&utm_medium=rss&utm_campaign=rss_everything", urlToImage: nil, isSaved: true, parsedContent: nil, categories: [], publishedAt: "2020-11-13T16:25:13Z")
        let viewModel = NewsDetailViewModel()
        viewModel.article = expectedArticle
        XCTAssertEqual(viewModel.isSaved.value, expectedArticle.isSaved)
    }
    
    // MARK: - Other
    
    func testUIWindow () {
        XCTAssertNotNil(UIWindow.mainWindow)
        
        if #available(iOS 13, *) {
            XCTAssertEqual(UIWindow.mainWindow, UIApplication.shared.windows.first)
        } else {
            XCTAssertEqual(UIWindow.mainWindow, UIApplication.shared.keyWindow)
        }
    }
    
    func testDefaultEmptyArray () {
        struct TestStruct: Decodable {
            @DefaultEmptyArray var array:[Int] = []
        }
        
        let filePath = Bundle(for: type(of: self)).path(forResource: "Empty", ofType: ".json")
        let jsonData =  try! Data(contentsOf: URL(fileURLWithPath: filePath!), options: .mappedIfSafe)
        let jsonResponse = try! JSONDecoder().decode(TestStruct.self, from: jsonData as Data)
        XCTAssertEqual(jsonResponse.array, [])
    }
    
    func testNavBarCreator () {
        let sceneDelegate = UIApplication.shared.connectedScenes[UIApplication.shared.connectedScenes.startIndex].delegate
        XCTAssertNotNil(sceneDelegate)
        
        XCTAssert(sceneDelegate is SceneDelegate)
        
        let navigationController = (sceneDelegate as! SceneDelegate).createVCForTab()
    
        XCTAssert(navigationController.topViewController is NewsViewController)
    }
    
    func testEndpoints () {
        let endpoints = [
            Endpoint.getEverything(apiKey: "apiKey", quote: "word", page: 1),
            Endpoint.getTopHeadlines(apiKey: "apiKey", quote: "word", page: 1)
        ]
        
        let expectedResults = [
            "https://newsapi.org/v2/everything?apiKey=apiKey&q=word&page=1",
            "https://newsapi.org/v2/top-headlines?apiKey=apiKey&q=word&page=1"
        ]
        
        for (i, endpoint) in endpoints.enumerated() {
            let request = URLSession.shared.createRequest(from: endpoint)
            XCTAssertNotNil(request.url)
            XCTAssertEqual(request.url?.absoluteString, expectedResults[i])
        }
    }
}
