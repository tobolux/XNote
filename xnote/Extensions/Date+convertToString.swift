//
//  Date+convertToString.swift
//  XNOTE
//
//  Created by Ilya Bolotov on 28/09/21.
//

import Foundation

extension Date {
    func convertToString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
    }
}

extension NSDate {
    func convertToString() -> String {
        return DateFormatter.localizedString(from: (self as Date), dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
    }
}
