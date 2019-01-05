//  TodolisViewController.swift
//  Todolis
//
//  Created by Jacekas Antulis on 05/01/2019.
//  Copyright © 2019 Jacekas Antulis. All rights reserved.

import UIKit

class TodolisViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
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
        saveItems()
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
        self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        // here we put itemArray data to Codable Items
        let encoder = PropertyListEncoder()
        do {
            // we encode the data
            let data = try encoder.encode(itemArray)
            // we write the data to Items.plist
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        self.tableView.reloadData()
    }

    func loadItems() {
        // here we load Codable Items to itemArray
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error decoding item array, \(error)")
        }
    }
  }

}
