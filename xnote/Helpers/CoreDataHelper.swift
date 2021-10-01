//
//  CoreDataHelper.swift
//  XNOTE
//
//  Created by Ilya Bolotov on 28/09/21.
//

import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        return context
    }()
    
    static func newNote() -> Note {
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        return note
    }
    
    // First run check and availability of records
    static func firstLaunch() {
        guard let note = NSEntityDescription.entity(forEntityName: "Note", in: context) else { return }
        
        var isEmpty: Bool {
            do {
                let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
                let count  = try context.count(for: fetchRequest)
                return count == 0
            } catch {
                return true
            }
        }
        
        if isEmpty == true {
            let firstNote = NSManagedObject(entity: note, insertInto: context)
            firstNote.setValue("Первая заметка", forKey: "title")
            firstNote.setValue(Date(), forKey: "modificationTime")
            
            let firstStrAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
            let attributedQuote = NSAttributedString(string: "Супер\n", attributes: firstStrAttributes)
            let contentExample = NSMutableAttributedString(attributedString: attributedQuote)
            let secondStr = NSMutableAttributedString(string: "тестовое\n", attributes:
                                                        [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)])
            let thirdStr = NSMutableAttributedString(string: "задание!\n", attributes:
                                                      [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 14)])
            contentExample.append(secondStr)
            contentExample.append(thirdStr)
            firstNote.setValue(contentExample, forKey: "content")
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    static func getNotes() -> [Note] {
        do {
            let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
    
    static func saveNote() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete(note: Note) {
        context.delete(note)
        saveNote()
    }
}
