//  SwipeTableViewController.swift
//  Todolis
//
//  Created by Jacekas Antulis on 10/01/2019.
//  Copyright © 2019 Jacekas Antulis. All rights reserved.

// this is a super class for CategoryViewController and for TodolisViewController
import UIKit
import SwipeCellKit


class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // we need update of rowHeight to be able to put Delete-icon in a full size
        tableView.rowHeight = 55.0
    }

    //MARK: - Swipe Cell Delegate Methods
    // We take data from: https://github.com/SwipeCellKit/SwipeCellKit

    //MARK: - TableView Datasource Methods
    
    // here we initialise the Swipe cell as default cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // here "as! SwipeTableViewCell" is related with Swipe cell operation
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("Item deleted")
            // handle action by updating model with deletion

            self.updateModel(at: indexPath)
            
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "Delete-icon")
        return [deleteAction]
    }
    // this function is for destructive expansion Style only
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        // options.transitionStyle = .border
        return options
    }

    func updateModel(at indexPath: IndexPath) {
        // update our Data Model
        // head of function in superclass
    }

}
