//
//  ListNotesTableViewController.swift
//  XNOTE
//
//  Created by Ilya Bolotov on 28/09/21.
//

import UIKit

class ListNotesTableViewController: UITableViewController {
    
    var notes = [Note]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataHelper.firstLaunch()
        notes = CoreDataHelper.getNotes()
    }
    
    
    //Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "displayNote":
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let note = notes[indexPath.row]
            let destination = segue.destination as! DisplayNoteViewController
            destination.note = note
        case "addNote":
            print("Tapped item bar button Add")
        default:
            print("Unknown identifier")
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue){
        notes = CoreDataHelper.getNotes()
    }
}

extension ListNotesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listNotesTableViewCell", for: indexPath) as! ListNotesTableViewCell
        let note = notes[indexPath.row]
        cell.noteTitleLabel.text = note.title
        cell.noteModificationTimeLabel.text = note.modificationTime?.convertToString() ?? "unknown"
        return cell
    }
    
    //Delete note - swipe left
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteToDelete = notes[indexPath.row]
            CoreDataHelper.delete(note: noteToDelete)
            notes = CoreDataHelper.getNotes()
        }
    }
}

