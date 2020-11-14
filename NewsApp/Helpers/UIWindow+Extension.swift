//
//  UIWindow+Extension.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/13/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

extension UIWindow {
    static var mainWindow: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
