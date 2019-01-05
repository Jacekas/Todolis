//  TodolisViewController.swift
//  Todolis
//
//  Created by Jacekas Antulis on 05/01/2019.
//  Copyright © 2019 Jacekas Antulis. All rights reserved.

import UIKit
import CoreData

class TodolisViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category?
    {
        didSet {
            // This line makes crash on pressing any Category
            // needed to be investigated
            // loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        cell.textLabel?.text = itemArray[indexPath.row].title
        // Tenary operator => value = condition ? valueIfTrue : valueIfFalse
        // Default is true, thus, even no need to write "== true"
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
 
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        // procedure of removing of items, order of commands are very importnat
        // step 1
        // context.delete(itemArray[indexPath.row])
        // step 2
        // itemArray.remove(at: indexPath.row)
        // saveItems()
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todolis Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
        
        let newItem = Item(context: self.context)
        newItem.title = textField.text!
        newItem.done = false
        newItem.parentCategory = self.selectedCategory
            
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
        do {
        try context.save()
        } catch {
        print(("Error saving context, \(error)"))
        }
        self.tableView.reloadData()
    }

    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        // we need selected appropriate items for appropriate Categories
        let categoryPredicate = NSPredicate(format: "patentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
    
        do {
        itemArray = try context.fetch(request)
        } catch {
        print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
}

// MARK: - Search Bar Methods

extension TodolisViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // we define filter
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // sorting descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            // we resign in foreground process, we exit from keyboard mode
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
            
        }
    }
// extension ends...
}




