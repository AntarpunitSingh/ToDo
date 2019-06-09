//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Antarpunit Singh on 2012-06-04.
//  Copyright © 2019 AntarpunitSingh. All rights reserved.
//
import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadsUp()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories found"
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colorHex ?? "4195FF")
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    //Mark -Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //Mark - Data Manipulation Methods
    override func updateModel(at indexPath: IndexPath) {
        do {
            try self.realm.write {
                self.realm.delete(self.categories![indexPath.row])
            }
        }
        catch{
            print("Error in saving \(error)")
        }
    }
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("Error in saving \(error)")
        }
        tableView.reloadData()
    }
    func loadsUp(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    //Mark- Add Category Method
    @IBAction func addButton(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add ToDo Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add ", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textfield.text!
            newCategory.colorHex = UIColor.randomFlat().hexValue()
            print(newCategory.colorHex)
            self.save(category: newCategory)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textfield = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true , completion: nil)
        
    }
    
}
