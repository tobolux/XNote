//
//  FormatingText.swift
//  XNOTE
//
//  Created by Ilya Bolotov on 28/09/21.
//

import Foundation
import UIKit

extension DisplayNoteViewController {
    enum fontStyle: String {
        case plus = "+"
        case minus = "-"
        case bold = "bold"
        case italic = "italic"
        case underline = "underline"
    }
    
    //MARK: Toolbar with formating button
    func loadToolbar() -> UIToolbar {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(more)),
            UIBarButtonItem(image: UIImage(systemName: "minus"), style: .plain, target: self, action: #selector(less)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(chooseImage)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "bold"), style: .plain, target: self, action: #selector(bold)),
            UIBarButtonItem(image: UIImage(systemName: "italic"), style: .plain, target: self, action: #selector(italic)),
            UIBarButtonItem(image: UIImage(systemName: "underline"), style: .plain, target: self, action: #selector(underline))]
        numberToolbar.sizeToFit()
        return numberToolbar
    }
    
    @objc func more() {
        changeFontStyle(.plus)
    }
    @objc func less() {
        changeFontStyle(.minus)
    }
    @objc func bold() {
        changeFontStyle(.bold)
    }
    @objc func italic() {
        changeFontStyle(.italic)
    }
    @objc func underline() {
        changeFontStyle(.underline)
    }
    
    //MARK: Paste image
    @objc private func chooseImage(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if contentTextView.selectedTextRange != nil {
            range = contentTextView.selectedRange
        }
        
        //Image processing
        let attributedString = NSMutableAttributedString(attributedString: contentTextView.attributedText)
        let textAttachment = NSTextAttachment()
        textAttachment.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        guard let oldWidth = textAttachment.image?.size.width else { return }
        let scaleFactor = oldWidth / (contentTextView.frame.size.width - 10)
        textAttachment.image = UIImage(cgImage: (textAttachment.image?.cgImage)!, scale: scaleFactor, orientation: .up)
        
        //Paste image in TextView
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.replaceCharacters(in: NSRange(location: range.location, length: range.length), with: attrStringWithImage)
        contentTextView.attributedText = attributedString
        contentTextView.selectedTextRange = contentTextView.textRangeFromNSRange(range: range)
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Select range, string in range and actual font size
    func selectedStringAndRange() -> (str: String, range: NSRange, actualFontSize: CGFloat) {
        var selectedText = String()
        var actualFontSize = CGFloat()
        if contentTextView.selectedTextRange != nil {
            range = contentTextView.selectedRange
            let textRangeFromTextInput = range.toTextRange(textInput: contentTextView)
            actualFontSize = contentTextView.font?.pointSize ?? 14
            selectedText = contentTextView.text(in: textRangeFromTextInput ?? UITextRange()) ?? ""
        }
        return (selectedText, range, actualFontSize)
    }
    
    //MARK: Change font style
    func changeFontStyle(_ style: fontStyle) {
        let str = selectedStringAndRange().str
        let range = selectedStringAndRange().range
        let actualFontSize = selectedStringAndRange().actualFontSize
        let fontName = contentTextView.font?.fontName
        
        let standartAttributeFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize)]
        let attributedString = NSMutableAttributedString(attributedString: contentTextView.attributedText)
        var myAttribute = [NSAttributedString.Key : Any]()
        
        switch style {
        case .bold:
            myAttribute = (fontName == ".SFUI-Semibold") ? standartAttributeFont : [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: actualFontSize)]
        case .italic:
            myAttribute = (fontName == ".SFUI-RegularItalic") ? standartAttributeFont : [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: actualFontSize)]
        case .underline:
            myAttribute = (fontName == ".SFUI-Light") ? standartAttributeFont :
            [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
             NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize, weight: .light)]
        case .plus:
            switch fontName {
            case ".SFUI-Semibold":
                myAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: actualFontSize + 1)]
            case ".SFUI-RegularItalic":
                myAttribute = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: actualFontSize + 1)]
            case ".SFUI-Light":
                myAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize + 1, weight: .light)]
            default:
                myAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize + 1)]
            }
        case .minus:
            switch fontName {
            case ".SFUI-Semibold":
                myAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: actualFontSize - 1)]
            case ".SFUI-RegularItalic":
                myAttribute = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: actualFontSize - 1)]
            case ".SFUI-Light":
                myAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize - 1, weight: .light)]
            default:
                myAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize - 1)]
            }
        }
        
        //Replace with a formatted string
        let myAttrString = NSAttributedString(string: str, attributes: myAttribute)
        attributedString.replaceCharacters(in: NSRange(location: range.location, length: range.length), with: myAttrString)
        contentTextView.attributedText = attributedString
        contentTextView.selectedTextRange = contentTextView.textRangeFromNSRange(range: range)
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Remove the keyboard from the text methods
    func placeTextAboveKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentTextView.contentInset = .zero
        } else {
            contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 100, right: 0)
        }
        contentTextView.scrollIndicatorInsets = contentTextView.contentInset
        let selectedRange = contentTextView.selectedRange
        contentTextView.scrollRangeToVisible(selectedRange)
    }
    
}

//MARK: Convert range type
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
