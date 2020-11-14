//
//  SpinnerView.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/13/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

final class SpinnerView: UIView {
    
    lazy var spinner: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.color = .white
        aiv.style = .large
        return aiv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        self.layer.cornerRadius = 16
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews () {
        self.addSubview(spinner)
        addUIConstraints()
    }
    
    private func addUIConstraints () {
        self.snp.makeConstraints { (make) in
            make.width.height.equalTo(80)
        }
        
        self.spinner.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.center.equalToSuperview()
        }
    }
}
