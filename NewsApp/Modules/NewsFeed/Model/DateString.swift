//
//  DateString.swift
//  NewsApp
//
//  Created by erkebulan elzhan on 11/12/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import Foundation

public struct ISO8601Wrapper: DateFormatterCodableProtocol {
    public static func decode(_ value: String) throws -> String {
        if let date = Date().dateFromString(strDate: value) {
            return date.getDateString()
        } else {
            return ""
        }
    }
    
    public static func encode(_ date: String) -> String {
        return date
    }
}

public protocol DateFormatterCodableProtocol {
    associatedtype RawValue: Codable

    static func decode(_ value: RawValue) throws -> String
    static func encode(_ date: String) -> RawValue
}

@propertyWrapper
public struct DateFormatted<Formatter: DateFormatterCodableProtocol>: Codable {
    public var value: Formatter.RawValue
    public var wrappedValue: String

    public init(wrappedValue: String) {
        do {
            self.wrappedValue = try Formatter.decode(wrappedValue as! Formatter.RawValue)
        } catch {
            self.wrappedValue = ""
        }

        self.value = Formatter.encode(wrappedValue)
    }
    
    public init(from decoder: Decoder) throws {
        self.value = try Formatter.RawValue(from: decoder)
        self.wrappedValue = try Formatter.decode(value)
    }
    
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
