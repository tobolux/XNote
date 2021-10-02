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
    let imagePicker = UIImagePickerController()
    
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
            contentTextView.attributedText = note.content as? NSAttributedString
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
