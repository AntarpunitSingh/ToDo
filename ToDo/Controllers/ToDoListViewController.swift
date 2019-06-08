//
//  ViewController.swift
//  ToDo
//
//  Created by Antarpunit Singh on 2012-05-31.
//  Copyright © 2019 AntarpunitSingh. All rights reserved.
//
import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    var items: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet{
            loadsUp()
        }
        
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
        
     
    }
    //Mark - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        if let item = items?[indexPath.row] {
         cell.textLabel?.text = item.title
         cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
          cell.textLabel?.text = "No Items added"
        }
        return cell
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    //Mark - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            }
            catch {
                print("error in encoding \(error)")
            }
            self.tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
     }
    }
    // Mark - Add Button
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New ToDo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // adding and saving both at same time
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textfield.text!
                        newItem.done = false
                        newItem.date = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                }
                catch {
                    print("error in encoding \(error)")
                }
                self.tableView.reloadData()
             
            }
         
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textfield = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // read in crud
    func loadsUp(){
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadsUp()
            // changes in foreground so it doesn't freeze with the ui
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
        }


    }
}
