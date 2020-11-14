//
//  Date+Extension.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/12/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

extension Date {
    
    /// Convert String to Date
    /// - Parameters:
    ///   - strDate: inputted string
    ///   - format: String format
    /// - Returns: Date (Optional)
    func dateFromString(strDate: String, format:String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if let dtDate = dateFormatter.date(from: strDate){
            return dtDate as Date?
        }
        
        return nil
    }
    
    /// Converting Date to desired String format
    /// - Parameter format: format of output (String)
    /// - Returns: Date as normal String (31.01.2003)
    func getDateString (at format: String = "dd/MM/yyyy") -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = format
        return dateFormatterGet.string(from: self)
    }
}
