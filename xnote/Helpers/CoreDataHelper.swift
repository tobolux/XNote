//
//  CoreDataHelper.swift
//  XNOTE
//
//  Created by Ilya Bolotov on 28/09/21.
//

import UIKit
import CoreData

// Creating Helper Methods
// This class methods that we can use to add, update, retrieve, and delete notes NSManagedObject objects.

struct CoreDataHelper {
    // 1.  Reference
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        return context
    }()
    
    // 2. Create note
    static func newNote() -> Note {
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        return note
    }
    
    // 3. Read note
    static func retrieveNotes() -> [Note] {
        do {
            let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
    
    // 4. Save Note
    static func saveNote() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    // 5. Delete note
    static func delete(note: Note) {
        context.delete(note)
        saveNote()
    }
}
