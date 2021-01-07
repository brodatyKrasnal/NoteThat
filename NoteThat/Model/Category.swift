//
//	NoteThat : Category.swift by Tymek on 05/10/2020 15:18.
//	Copyright ©Tymek 2020. All rights reserved.


import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var categName: String = ""
    @objc dynamic var catColor: String = ""
    let notes = List<Note>()
}
