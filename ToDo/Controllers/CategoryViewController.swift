//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Antarpunit Singh on 2012-06-04.
//  Copyright © 2019 AntarpunitSingh. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadsUp()

    }
    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    //Mark -Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    //Mark - Data Manipulation Methods
    func saveCategory(){
        do {
            try context.save()
        }
        catch{
            print("Error in saving \(error)")
        }
        tableView.reloadData()
    }
    func loadsUp(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }
        catch{
            print("Error in fetching the Data \(error)")
        }
        tableView.reloadData()
    }
    
    //Mark- Add Category Method
    @IBAction func addButton(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add ToDo Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add ", style: .default) { (action) in
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newCategory = Category(context: context)
            newCategory.name = textfield.text!
            self.categoryArray.append(newCategory)
            self.saveCategory()
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
