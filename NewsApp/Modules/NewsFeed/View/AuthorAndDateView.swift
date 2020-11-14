//
//  AuthorAndDateView.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/13/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

class AuthorAndDateView: UIStackView {
     var authorLbl: UILabel = {
         let lbl = UILabel()
         lbl.font = .systemFont(ofSize: 13)
         lbl.textColor = .gray
         lbl.sizeToFit()
         return lbl
     }()
     
     lazy var dateLbl: UILabel = {
         let lbl = UILabel()
         lbl.font = .systemFont(ofSize: 13)
         lbl.textColor = .gray
         return lbl
     }()
     
     lazy var circleView: UIView = {
         let view = UIView()
         view.backgroundColor = .gray
         view.layer.cornerRadius = 4
         return view
     }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setUpUI()
        self.addViews()
        self.addUIConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI () {
        axis = .horizontal
        alignment = .center
        distribution = .fill
        spacing = 8
    }
    
    private func addViews () {
        addArrangedSubview(authorLbl)
        addArrangedSubview(circleView)
        addArrangedSubview(dateLbl)
    }
    
    private func addUIConstraints () {
        circleView.snp.makeConstraints { (make) in
            make.width.height.equalTo(8)
        }
        dateLbl.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
        }
    }
}
