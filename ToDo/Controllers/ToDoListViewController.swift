//
//  ViewController.swift
//  ToDo
//
//  Created by Antarpunit Singh on 2012-05-31.
//  Copyright © 2019 AntarpunitSingh. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Eddie"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Jaky"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Joghn"
        itemArray.append(newItem3)
        
       if let item = defaults.array(forKey: "TodoList") as? [Item] {
            itemArray = item
        }
       
    }
    
    //Mark - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    //Mark - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // Mark - Add Button
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New ToDo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textfield.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoList")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textfield = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    

}
