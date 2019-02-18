//
//  ViewController.swift
//  todoey
//
//  Created by Marcos Lee on 10/14/18.
//  Copyright © 2018 Marcos Lee. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    //item object
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //Mark - TableView Datasource Methods
    //This will determin how many rows are injected
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //this will put content to the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //the TodoItemCell its from the ID we gave to the prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)

        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
       
    }
    
    //Mark - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //add checkmark when clicked
    
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
        }
        
        tableView.reloadData()

        //animate table click.
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    //ADD new items to array
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add button
            
            
            if let currentCategory = self.selectedCategory {
                
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
//            self.saveItems()
            //save in phones memory storage
           
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        //show Alert
        
        present(alert, animated: true, completion: nil)
        
    }
    

    
    // external parameter (with) its the way we can use it whenever we call the function and provide the necessary parameter, and then we have the internal parameter that we use within our function. and we can also use the = to provide a default value if no parameter its given
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
       tableView.reloadData()
    }
}

//MARk : Search Bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            //SHould no longer be the thing that is selected
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


