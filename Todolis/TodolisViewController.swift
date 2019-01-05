//  TodolisViewController.swift
//  Todolis
//
//  Created by Jacekas Antulis on 05/01/2019.
//  Copyright © 2019 Jacekas Antulis. All rights reserved.

import UIKit

class TodolisViewController: UITableViewController {

    let itemArray = ["Task 1", "Task 2", "Task 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // we run all cells of the Table View with Identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // we populate cells with data from itemArray
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
 
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
           tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    

}

