//
//  DisplayNoteViewController.swift
//  XNOTE
//
//  Created by Ilya Bolotov on 28/09/21.
//

import UIKit

class DisplayNoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var note: Note?
    var range = NSRange()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load toolbar with formating string above the keyboard
        contentTextView.inputAccessoryView = loadToolbar()
        //Remove the keyboard from the text
        placeTextAboveKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let note = note {
            titleTextField.text = note.title
            contentTextView.attributedText = note.content
        }
    }
    
    //Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "save" where note != nil:
            note?.title = titleTextField.text
            note?.content = contentTextView.attributedText
            note?.modificationTime = Date()
            CoreDataHelper.saveNote()
        case "save" where note == nil:
            let note = CoreDataHelper.newNote()
            note.title = titleTextField.text
            note.content = contentTextView.attributedText
            note.modificationTime = Date()
            CoreDataHelper.saveNote()
        case "cancel":
            print("Cancel button tapped")
        default:
            print("Unknown identifier")
        }
    }
    
    

    
    
}









extension DisplayNoteViewController {
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
        changeFontStyle("+")
    }
    @objc func less() {
        changeFontStyle("-")
    }
    @objc func underline() {
        changeFontStyle("underline")
    }
    @objc func bold() {
        changeFontStyle("bold")
    }
    @objc func italic() {
        changeFontStyle("italic")
    }
    
    
    //MARK: Paste image
    @objc private func chooseImage(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
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
        let attributedString = NSMutableAttributedString(attributedString: contentTextView.attributedText)
        let textAttachment = NSTextAttachment()
        textAttachment.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        guard let oldWidth = textAttachment.image?.size.width else { return }
        let scaleFactor = oldWidth / (contentTextView.frame.size.width - 10)
        textAttachment.image = UIImage(cgImage: (textAttachment.image?.cgImage)!, scale: scaleFactor, orientation: .up)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        
        attributedString.replaceCharacters(in: NSRange(location: range.location, length: range.length), with: attrStringWithImage)
        contentTextView.attributedText = attributedString
        contentTextView.selectedTextRange = contentTextView.textRangeFromNSRange(range: range)
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Select range and string in range
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
    
    func changeFontStyle(_ style: String) {
        let str = selectedStringAndRange().str
        let range = selectedStringAndRange().range
        let actualFontSize = selectedStringAndRange().actualFontSize
        
        let x = contentTextView.font?.fontName
        var attributedString: NSMutableAttributedString!
        attributedString = NSMutableAttributedString(attributedString: contentTextView.attributedText)
        
        var myAttribute = [NSAttributedString.Key : Any]()
        
        switch style {
        case "bold":
            if x == ".SFUI-Semibold" {
                myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize)]
            } else {
                myAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: actualFontSize)]
            }
        case "italic":
            if x == ".SFUI-RegularItalic" {
                myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize)]
            } else {
                myAttribute = [ NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: actualFontSize)]
            }
        case "underline":
            if x == ".SFUI-Light" {
                myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize)]
            } else {
                myAttribute = [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize, weight: .light)]
            }
        case "+":
            if x == ".SFUI-Semibold" {
                myAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: actualFontSize + 1)]
            } else if x == ".SFUI-RegularItalic" {
                myAttribute = [ NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: actualFontSize + 1)]
            } else if x == ".SFUI-Light" {
                myAttribute = [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize + 1, weight: .light)]
            } else {
                myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize + 1)]
            }
        case "-":
            if x == ".SFUI-Semibold" {
                myAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: actualFontSize - 1)]
            } else if x == ".SFUI-RegularItalic" {
                myAttribute = [ NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: actualFontSize - 1)]
            } else if x == ".SFUI-Light" {
                myAttribute = [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize - 1, weight: .light)]
            } else {
                myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize - 1)]
            }
        default:
            myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: actualFontSize)]
        }
        
        let myAttrString = NSAttributedString(string: str, attributes: myAttribute)
        attributedString.replaceCharacters(in: NSRange(location: range.location, length: range.length), with: myAttrString)
        contentTextView.attributedText = attributedString
        contentTextView.selectedTextRange = contentTextView.textRangeFromNSRange(range: range)
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    //Remove the keyboard from the text methods
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
