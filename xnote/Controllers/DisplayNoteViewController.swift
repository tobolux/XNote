//
//  DisplayNoteViewController.swift
//  XNOTE
//
//  Created by Ilya Bolotov on 28/09/21.
//

import UIKit

class DisplayNoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextViewDelegate {
    
    var note: Note?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var contentTextViewSize = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextViewSize = contentTextView.font!.pointSize
        //
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(more)),
            UIBarButtonItem(title: "-", style: .plain, target: self, action: #selector(less)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "bold"), style: .plain, target: self, action: #selector(bold)),
            UIBarButtonItem(image: UIImage(systemName: "italic"), style: .plain, target: self, action: #selector(italic)),
            UIBarButtonItem(image: UIImage(systemName: "underline"), style: .plain, target: self, action: #selector(underline))]
        numberToolbar.sizeToFit()
        contentTextView.inputAccessoryView = numberToolbar
        
        
        //Не даем клавиатуре перекрывать текст
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    
    func selectedStringAndRange() -> (str: String, range: NSRange, actualFontSize: CGFloat) {
        
        var selectedText = String()
        var range = NSRange()
        var actualFontSize = CGFloat()
        if contentTextView.selectedTextRange != nil {
            range = contentTextView.selectedRange
            let x = range.toTextRange(textInput: contentTextView)
            actualFontSize = contentTextView.font!.pointSize
            selectedText = contentTextView.text(in: x!) ?? "2"
        }
        return (selectedText, range, actualFontSize)
        
    }
    
    func changeFontStyle(_ style: String) {
        let str = selectedStringAndRange().str
        let range = selectedStringAndRange().range
        let actualFontSize = selectedStringAndRange().actualFontSize
        
        let x = contentTextView.font!.fontName
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
            //print(contentTextView.font!.fontName)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let note = note {
            titleTextField.text = note.title
            contentTextView.attributedText = note.content as? NSAttributedString
        } else {
            titleTextField.text = ""
            contentTextView.text = ""
        }
    }
    
    @IBAction func addImage(_ sender: UIBarButtonItem) {
        alertImage()
    }
    
    
    
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "save" where note != nil:
            note?.title = titleTextField.text// ?? ""
            note?.content = contentTextView.attributedText// ?? "" as NSObject
            note?.modificationTime = Date()
            CoreDataHelper.saveNote()
        case "save" where note == nil:
            let note = CoreDataHelper.newNote()
            note.title = titleTextField.text// ?? ""
            note.content = contentTextView.attributedText// ?? "" as NSObject
            note.modificationTime = Date()
            CoreDataHelper.saveNote()
        case "cancel":
            print("cancel button tapped")
        default:
            print("unexpected segue identifier")
        }
    }
    
    private func alertImage() {
        let alert = UIAlertController(title: nil, message: "Выберите способ загрузки изображения", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { (action) in
            self.chooseImage(source: .camera)
        }
        let photoLibAction = UIAlertAction(title: "Галерея", style: .default) { (action) in
            self.chooseImage(source: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cameraAction)
        alert.addAction(photoLibAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func chooseImage(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        var range = NSRange()
        if contentTextView.selectedTextRange != nil {
            range = contentTextView.selectedRange
        }
        
        var attributedString :NSMutableAttributedString!
        attributedString = NSMutableAttributedString(attributedString:contentTextView.attributedText)
        let textAttachment = NSTextAttachment()
        textAttachment.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        let oldWidth = textAttachment.image!.size.width;
        
        //I'm subtracting 10px to make the image display nicely, accounting
        //for the padding inside the textView
        
        let scaleFactor = oldWidth / (contentTextView.frame.size.width - 10);
        // переделать безопасно
        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.replaceCharacters(in: NSRange(location: range.location, length: range.length), with: attrStringWithImage)
        contentTextView.attributedText = attributedString
        
        
        dismiss(animated: true, completion: nil)
        
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


extension NSRange {
    func toTextRange(textInput:UITextInput) -> UITextRange? {
        if let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: location),
           let rangeEnd = textInput.position(from: rangeStart, offset: length) {
            return textInput.textRange(from: rangeStart, to: rangeEnd)
        }
        return nil
    }
}

extension UITextView {

    func textRangeFromNSRange(range:NSRange) -> UITextRange? {
        let beginning = beginningOfDocument
        guard let start = position(from: beginning, offset: range.location), let end = position(from: start, offset: range.length) else { return nil }

        return textRange(from: start, to: end)
    }
}
