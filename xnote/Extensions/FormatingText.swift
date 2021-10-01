//
//  FormatingText.swift
//  Xnote
//
//  Created by ilya bolotov on 30.09.2021.
//  Copyright © 2021 Ilya Bolotov. All rights reserved.
//

import Foundation
import UIKit

extension NSRange {
    func toTextRange(textInput: UITextInput) -> UITextRange? {
        if let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: location),
           let rangeEnd = textInput.position(from: rangeStart, offset: length) {
            return textInput.textRange(from: rangeStart, to: rangeEnd)
        }
        return nil
    }
}

extension UITextView {
    func textRangeFromNSRange(range: NSRange) -> UITextRange? {
        let beginning = beginningOfDocument
        guard let start = position(from: beginning, offset: range.location), let end = position(from: start, offset: range.length) else { return nil }
        return textRange(from: start, to: end)
    }
}
