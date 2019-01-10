//  CategoryViewController.swift
//  Todolis
//
//  Created by Jacekas Antulis on 10/01/2019.
//  Copyright © 2019 Jacekas Antulis. All rights reserved.

// Category is a sub-class
import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    // we initialise the access point to Realm Database
    let realm = try! Realm()
    
    // we make variable categories as array of Results
    // when we fetch data from Realm, we take it like Results
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

        // we delete separators between cells
        tableView.separatorStyle = .none
    }

    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if categories is not nil, the it returns count, if nil, then returns 1
        // Nil Coalescing Operator
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // we take the cell from superclass
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // we do some operations with that cell
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            // after changing text of cell, we can change the background colour using Chameleon framework
            // different examples playing with colours
            //cell.backgroundColor = UIColor.randomFlat
            //print(UIColor.flatWhite.hexValue())
            //cell.backgroundColor = UIColor.flatWhite
            // cell.backgroundColor = UIColor(hexString: "E6FFC1") // nice green-yellow light colour is here
            
            guard let categoryColour = UIColor(hexString: category.colour) else { fatalError() }
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
     }
        return cell
   }
  
    //MARK: - Data Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    // before we go to another screen, we prepare that screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodolisViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            // important step, we define selectedCategory
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category : Category) {
        do {
            // we commit changes to Realm that was created in Category
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data in save procedure, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        // we fetch all data existing in Realm, related to Category, to categories
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    
    // we use this function from superclass
    override func updateModel(at indexPath: IndexPath) {
        
        // for testing purposes, we run here all the code in super class function
        // super.updateModel(at: indexPath)
        
        if let categoryForDeletion = self.categories?[indexPath.row]
            {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                        print("Error deleting category, \(error)")
                    }
                }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
        // what happen when the user clicks on "+" button

        // we create a newCategory object
        let newCategory = Category()
        // and give the name from textField of the Alert interface
        newCategory.name = textField.text!
        // now we have colour in a string format (Hex)
        // plus we lighten colour by 90%
        newCategory.colour = UIColor.randomFlat.hexValue()
            if let finalColour = UIColor(hexString: newCategory.colour)?.lighten(byPercentage: 0.9)?.hexValue()
                    {
                    newCategory.colour = finalColour
                    print("Created lighter colour")
                    }
 
        // we appen new category to the list of categories automatically
        // no need to append anymore, it will simply auto-update
        self.save(category: newCategory)
        }
    
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a New Category"
        }
        present(alert, animated: true, completion: nil)
    }
}
