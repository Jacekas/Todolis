//  TodolisViewController.swift
//  Todolis
//
//  Created by Jacekas Antulis on 05/01/2019.
//  Copyright © 2019 Jacekas Antulis. All rights reserved.

import UIKit

class TodolisViewController: UITableViewController {

    var itemArray = [Item]()
    
    // here we get access to User Defaults of the mobile
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let newItem = Item()
        newItem.title = "Task 1"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Task 2"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Task 3"
        itemArray.append(newItem3)
   
        if let items = defaults.array(forKey: "TodolisArray") as? [Item] {
            itemArray = items
        }
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // we run all cells of the Table View with Identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // we populate cells with data from itemArray
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Tenary operator => value = condition ? valueIfTrue : valueIfFalse
        // Default is true, thus, even no need to write "== true"
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
 
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todolis Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
        
        let newItem = Item()
        newItem.title = textField.text!
        self.itemArray.append(newItem)

        // here we put itemArray data to User Defaults
        self.defaults.set(self.itemArray, forKey: "TodolisArray")
            
        self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

