//
//	NoteThat : CategoriesVC.swift by Tymek on 05/10/2020 15:16.
//	Copyright ©Tymek 2020. All rights reserved.


import UIKit
import RealmSwift
import ChameleonFramework

class CategoriesVC: GenricTableVC {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        readRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
//MARK: - DataTable Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].categName ?? "No categories added yet."
        if let cellColor = categories?[indexPath.row].catColor {
            cell.backgroundColor = UIColor(hexString: cellColor)
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: cellColor)!, returnFlat: true)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toNotes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NotesVC
        if let chosenIndex = tableView.indexPathForSelectedRow {
            destinationVC.interceptedCategory = categories?[chosenIndex.row]
            destinationVC.capturedColor = categories?[chosenIndex.row].catColor
        }
    }

//MARK: - Add Categories
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var caughtText = UITextField()
        
        let popup = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        popup.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        popup.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let newCateg = Category()
            newCateg.categName = caughtText.text!
            newCateg.catColor = UIColor.randomFlat().hexValue()
            self.save(this: newCateg)
        }))
        
        popup.addTextField { (textField) in
            caughtText = textField
            textField.placeholder = "Add new record."
            textField.textAlignment = .center
        }
        present(popup, animated: true, completion: nil)
    }
    
//MARK: - Data Manipulation Methods
    func save (this category: Category) {
        do {
            try realm.write {realm.add(category) }
            print("Category added.")
        } catch {
                print("Error while saiving category: \(error)")
            }
        tableView.reloadData()
        }
    
    func readRealm () {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}

