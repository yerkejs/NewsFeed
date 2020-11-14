//
//  ArticleCell.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/11/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import SnapKit

protocol ArticleCellConfiguration: class {
    var titleLbl: UILabel { get }
    var authorLbl: UILabel { get }
    var dateLbl: UILabel { get }
    var newsPreviewImgView: UIImageView { get }
    var saveBtn: UIButton { get }
}

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

class ArticleCell: UITableViewCell, ArticleCellConfiguration, ReuseIdentifying {
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        stackView.spacing = 12
        return stackView
    }()

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 17, weight: .bold)
        lbl.textAlignment = .left
        lbl.textColor = .black
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var authorLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    lazy var dateLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    lazy var newsPreviewImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 8
        btn.backgroundColor = .blue
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Save", for: .normal)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews () {
        self.contentView.addSubview(newsPreviewImgView)
        self.contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(newsPreviewImgView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLbl)
        verticalStackView.addArrangedSubview(dateLbl)
        verticalStackView.addArrangedSubview(authorLbl)
        verticalStackView.addArrangedSubview(saveBtn)
        self.addUIConstraints()
    }
    
    private func addUIConstraints () {
        horizontalStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(12)
        }
        
        newsPreviewImgView.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(120)
        }
    }
}
