//
//  ArticleHeaderCell.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/13/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

class ArticleHeaderCell: UITableViewCell, ArticleCellConfiguration, ReuseIdentifying {
    
    lazy var newsPreviewImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var topRowStackView = AuthorAndDateView()
    
    var authorLbl: UILabel {
        return topRowStackView.authorLbl
    }
    
    var dateLbl: UILabel {
        return topRowStackView.dateLbl
    }
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        return lbl
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
        self.contentView.addSubview(labelsStackView)
        labelsStackView.addArrangedSubview(topRowStackView)
        labelsStackView.addArrangedSubview(titleLbl)
        labelsStackView.addArrangedSubview(saveBtn)
        self.addUIConstraints()
    }
    
    private func addUIConstraints () {
        newsPreviewImgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().inset(12)
            make.height.equalTo(150)
        }
        
        labelsStackView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview().inset(12)
            make.top.equalTo(newsPreviewImgView.snp.bottom).offset(12)
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(120)
        }
    }
}
