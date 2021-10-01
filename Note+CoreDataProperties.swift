//
//  Note+CoreDataProperties.swift
//  XNOTE
//
//  Created by ilya bolotov on 30.09.2021.
//  Copyright © 2021 Ilya Bolotov. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var content: NSObject?
    @NSManaged public var image: Data?
    @NSManaged public var modificationTime: Date?
    @NSManaged public var title: String?

}
