//
//	NoteThat : GenricTableVC.swift by Tymek on 05/10/2020 15:39.
//	Copyright ©Tymek 2020. All rights reserved.


import UIKit
import SwipeCellKit
import ChameleonFramework

class GenricTableVC: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.removeElement(at: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
    func removeElement(at indexPath: IndexPath) {
        print("Element: \(indexPath.row) has been removed.")
    }
    
}
