//
//	NoteThat : Note.swift by Tymek on 05/10/2020 15:17.
//	Copyright ©Tymek 2020. All rights reserved.


import Foundation
import RealmSwift

class Note: Object {
    @objc dynamic var noteName: String = ""
    @objc dynamic var noteCompletion: Bool = false
    @objc dynamic var noteDate: Date?
    @objc dynamic var noteColor: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "notes")

}
