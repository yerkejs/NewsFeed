//
//  ViewController.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/11/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

enum NewsApiType: String, CaseIterable, Codable {
    case topHeadings = "topHeadings"
    case everything = "everything"
    
    var title: String {
        switch self {
        case .topHeadings:
            return "Top headings"
        case .everything:
            return "Everything"
        }
    }
}

final class NewsViewController: UIViewController {
    
    // MARK: - Outlets
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseIdentifier)
        tableView.register(ArticleHeaderCell.self, forCellReuseIdentifier: ArticleHeaderCell.reuseIdentifier)
        _ = tableView.rx.setDelegate(self)
        return tableView
    }()
    
    private lazy var spinnerView: SpinnerView = {
        let spinnerView = SpinnerView()
        spinnerView.spinner.hidesWhenStopped = true
        spinnerView.isHidden = true
        return spinnerView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Props
    
    private var viewModel = NewsControllerViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Actions
    
    @objc private func onSaveClick (sender: UIButton) {
        self.viewModel.saveToArchive(index: sender.tag)
    }
    
    @objc private func onRefresh (sender: UIRefreshControl) {
        sender.endRefreshing()
        self.viewModel.currentPage = 1
        self.viewModel.loadData()
    }
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addViews()
        self.setUpNav()
        
        if viewModel.newsVCType == .topHeadings {
            self.viewModel.loadNewsRepeatitively()
        }
        
        viewModel.loadData()
        
        _ = self.viewModel.isLoading.bind(onNext: { (newIsLoading) in
            self.spinnerView.isHidden = !newIsLoading
            newIsLoading ? self.spinnerView.spinner.startAnimating() : self.spinnerView.spinner.stopAnimating()
            }).disposed(by: disposeBag)
        
        _ = self.viewModel.articles.bind(to: self.tableView.rx.items) { (_, index, article) in
            let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: index == 0 ? ArticleHeaderCell.reuseIdentifier : ArticleCell.reuseIdentifier)!
            self.configureCell(article: article, cell: cell as! ArticleCellConfiguration, index: index)
            return cell
        }.disposed(by: self.disposeBag)
        
        _ = self.viewModel.errorMessage.bind(onNext: { [weak self] error in
            self?.showErrorAlert(title: "Ошибка", message: error.errorMsg)
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadArticlesFromLocalDB()
    }
}


// MARK: - Public methods

extension NewsViewController {
    public func setType (_ type: NewsApiType) {
        self.viewModel.newsVCType = type
    }
}


// MARK: - Private methods

extension NewsViewController {
    
    private func addViews () {
        self.view.addSubview(tableView)
        self.view.addSubview(spinnerView)
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(onRefresh(sender:)), for: .valueChanged)
        
        addUIConstraints()
    }
    
    private func addUIConstraints () {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.spinnerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    private func configureCell (article: Article, cell: ArticleCellConfiguration, index: Int) {
        cell.titleLbl.text = article.title
        cell.newsPreviewImgView.sd_setImage(with: URL(string: article.urlToImage!), placeholderImage: UIImage(named: "newsPlaceholder"))
        cell.dateLbl.text = article.publishedAt
        cell.authorLbl.text = article.author
        cell.saveBtn.tag = index
        cell.saveBtn.addTarget(self, action: #selector(onSaveClick(sender:)), for: .touchUpInside)
        cell.saveBtn.setTitle(article.isSaved ?? false ? "Unsave": "Save", for: .normal)
    }
    
    private func showErrorAlert (title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertViewController.addAction(okButton)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func setUpNav () {
        self.navigationItem.title = self.viewModel.newsVCType.title
    }
}


// MARK: - Table View Delegate

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleDetailsVC = NewsDetailViewController()
        articleDetailsVC.setUpData(with: self.viewModel.articles.value[indexPath.row], for: self.viewModel.newsVCType)
        self.navigationController?.pushViewController(articleDetailsVC, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if viewModel.isPaginationEnable {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            
            if offsetY > contentHeight - scrollView.frame.size.height {
                viewModel.loadData()
            }
        }
    }
}
