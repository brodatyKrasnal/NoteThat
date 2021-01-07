//
//	NoteThat : NotesVC.swift by Tymek on 05/10/2020 16:44.
//	Copyright ©Tymek 2020. All rights reserved.


import UIKit
import RealmSwift
import ChameleonFramework

class NotesVC: GenricTableVC {
    
    @IBOutlet weak var searchBat: UISearchBar!
    
    let realm = try! Realm()
    
    var notesList: Results<Note>?
    var capturedColor: String?
    
    var interceptedCategory: Category? {
        didSet {
            readNotes()
            title = interceptedCategory?.categName
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex = interceptedCategory?.catColor {
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
            if let navBarColour = UIColor(hexString: colourHex) {
                navBar.backgroundColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                searchBat.barTintColor = navBarColour
            }
        }
    }
    
    //MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let note = notesList?[indexPath.row] {
            cell.textLabel?.text = note.noteName
            cell.accessoryType = note.noteCompletion == true ? .checkmark : .none
            if let color = UIColor.init(hexString: capturedColor!) {
                cell.backgroundColor = UIColor.init(hexString: capturedColor!)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(notesList!.count)/2)
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No records here yet."
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = notesList?[indexPath.row] {
            do {
                try realm.write {
                    index.noteCompletion = !index.noteCompletion
                }
                tableView.reloadData()
            } catch {
                print("Error while chaniging done parameter: \(error)")
            }
        }
    }
    
    override func removeElement(at indexPath: IndexPath) {
        super.removeElement(at: indexPath)
        if let index = notesList?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(index)
                }
            } catch {
                print("Error while removing note item: \(index.noteName)")
            }
        }
        readNotes()
    }
    
    //MARK: - Data Manipulation Methods
    
    func readNotes () {
        notesList = interceptedCategory?.notes.sorted(byKeyPath: "noteDate", ascending: true)
        tableView.reloadData()
    }
    
    
    //MARK: - Add new category
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        var userText = UITextField()
        
        let popup = UIAlertController(title: "Add new note", message: "", preferredStyle: .alert)
        
        popup.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        popup.addAction(UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            if let selectedCategory = self.interceptedCategory {
                do {
                    try self.realm.write {
                        let newNote = Note()
                        newNote.noteName = userText.text!
                        newNote.noteDate = Date()
                        newNote.noteColor = UIColor.randomFlat().hexValue()
                        selectedCategory.notes.append(newNote)
                        self.readNotes()
                    }
                } catch {
                    print("Error while saving new note: \(error)")
                }
            }
        })
        popup.addTextField { (textField) in
            userText = textField
            textField.placeholder = "Add your record here."
            textField.textAlignment = .center
        }
        present(popup, animated: true, completion: nil)
    }
   
    
}
//MARK: - Search Bar methods
extension NotesVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        notesList = notesList?.filter(NSPredicate(format: "noteName CONTAINS[cd] %@", searchBar.text!))
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async { [self] in
                readNotes()
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}
