//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/13/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class NewsDetailViewController: UIViewController {
    
    // MARK: - View
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var scrollContentView: UIView = {
        let contentView = UIView()
        contentView.addSubview(authorAndDateView)
        contentView.addSubview(titleLbl)
        contentView.addSubview(sourceLbl)
        contentView.addSubview(newsImageView)
        contentView.addSubview(contentLbl)
        return contentView
    }()
    
    private lazy var authorAndDateView = AuthorAndDateView()
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 28, weight: .bold)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var sourceLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var contentLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 17, weight: .regular)
        lbl.alpha = 0.8
        lbl.text = "Parsing ..."
        return lbl
    }()
    
    // MARK: - Props
    
    private var viewModel = NewsDetailViewModel()
    private let disposedBag = DisposeBag()
    
    // MARK: - UI actions
    
    @objc private func onSaveClicked (sender: UIBarButtonItem) {
        self.viewModel.toggleSaveArticle()
    }
    
    // MARK: - Life-Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.addViews()
        self.addUIConstraints()
        self.updateUI()
    }
}

// MARK: - Private methods

extension NewsDetailViewController {
    private func createContentLabelText (labelText: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: labelText)
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = 8
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    private func updateUI () {
        self.authorAndDateView.authorLbl.text = self.viewModel.article.author
        self.authorAndDateView.dateLbl.text = self.viewModel.article.publishedAt
        self.titleLbl.text = self.viewModel.article.title
        self.sourceLbl.text = "Источник: \(self.viewModel.article.source.name)"
        self.newsImageView.sd_setImage(with: URL(string: self.viewModel.article.urlToImage ?? ""))
        parseHTML()
    }
    
    private func parseHTML () {
        if let content = self.viewModel.article.parsedContent {
            self.contentLbl.attributedText = self.createContentLabelText(labelText: content)
        } else {
            let parseThread = DispatchQueue(label: "parseHTML", qos: .userInitiated)
            parseThread.async {
                let parsedText = self.viewModel.parseHTML()
                DispatchQueue.main.async {
                    self.contentLbl.attributedText = self.createContentLabelText(labelText: parsedText)
                    self.viewModel.saveContentOfArticle(content: parsedText)
                }
            }
        }
    }
    
    private func updateScrollHeight () {
        var scrollViewHeight: CGFloat = 0.0
        
        for subview in scrollView.subviews {
            scrollViewHeight += subview.frame.size.height
        }
        
        scrollView.contentSize = CGSize(width: 0, height: scrollViewHeight)
    }
}

// MARK: - Initial UI

extension NewsDetailViewController {
    private func setUpUI () {
        self.view.backgroundColor = .white
        self.setUpNavBar()
        
        _ = self.scrollContentView.rx.observe(CGRect.self, #keyPath(UIView.bounds)).subscribe(onNext: { _ in
            self.updateScrollHeight()
        }).disposed(by: disposedBag)
        
        _ = self.viewModel.isSaved.bind(onNext: { (newValue) in
            self.navigationItem.rightBarButtonItem?.title = newValue ? "Unsave" : "Save"
        }).disposed(by: disposedBag)
        
        self.scrollContentView.backgroundColor = .white
    }
    
    private func addViews () {
        self.view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
    }
    
    private func setUpNavBar () {
        self.navigationItem.title = "Article"
        self.navigationItem.largeTitleDisplayMode = .never
        
        let saveBtn = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(onSaveClicked(sender:)))
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    private func addUIConstraints () {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.top.centerX.equalToSuperview()
        }
        
        authorAndDateView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(8)
        }
        
        titleLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(authorAndDateView.snp.bottom).offset(4)
        }
        
        sourceLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLbl.snp.bottom).offset(4)
        }
        
        newsImageView.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(sourceLbl.snp.bottom).offset(16)
        }
        
        contentLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(newsImageView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}

// MARK: - Public methods

extension NewsDetailViewController {
    public func setUpData (with article: Article, for newsApiType: NewsApiType) {
        self.viewModel.article = article
        self.viewModel.newsApiType = newsApiType
    }
}
