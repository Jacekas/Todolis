//  TodolisViewController.swift
//  Todolis
//
//  Created by Jacekas Antulis on 10/01/2019.
//  Copyright © 2019 Jacekas Antulis. All rights reserved.

// Todolis is a sub-class
import UIKit
import RealmSwift
import ChameleonFramework

class TodolisViewController: SwipeTableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()

    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category?
    {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
    }

    // this is a point when just after completing of viewDidLoad() the view starts to show up itself
    // it starts just before the user sees something on the screen
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let colourHex = selectedCategory?.colour else { fatalError() }
        updateNavBar(withHexCode: colourHex)
    }
    
    // here we need to initiate old Category color of Navigator Bar if view is disappear
    override func viewWillDisappear(_ animated: Bool) {
        // 57BB2F is a nice green colour
        updateNavBar(withHexCode: "57BB2F")
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode : String) {
        // here NavigationController already should exist
        // we check here if navigation controller exists
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}

        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColour
        // we make contrast for "+" and other texts
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        // we make contrast for "big letters"
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //we have here reference to the cell, we take it from super class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = todoItems?[indexPath.row] {
            // if not nil
            cell.textLabel?.text = item.title
            
            // CGFloat range is from 0 to 1 (0 means 0%, 1 means 100%)
            //if let colour = UIColor(hexString: "E9FFED")?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
            //if let colour = FlatWhite().darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
            
            // selectedCategory cannot be nil
            // we use here optional chaining
            // we darken maximum by 0.3 (30%)
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: 0.3*CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {

                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        }   else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
 
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // "U"pdating the data in Realm
        // we try to retrieve the data and copy to item
        if let item = todoItems?[indexPath.row] {
        do {
            // if retrieved, then we try to write changed "done" property
            try realm.write {
                // "D"elete procedure in Realms data, as example
                // realm.delete(item)
                item.done = !item.done
        }
        } catch {
            print("Error saving done status, \(error)")
        }
      }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todolis Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        
        // what will happen once the user clicks the Add Item button on our UIAlert
        // "C"reation of data in Realm
        // we check here if selectedCategory is not nil
        if let currentCategory = self.selectedCategory {
            // if not nil
            do {
            try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
            }
            } catch {
                print("Error saving new items, \(error)")
            }
          }
        self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            // if this is not nil
            do {
            try realm.write {
                realm.delete(item)
            }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }

    }
}

// MARK: - Search Bar Methods

extension TodolisViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // we have to filter todoItems
        // here we simply filtering items based on the defined criteria
        
        //todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

