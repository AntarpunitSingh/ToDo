//
//  ToDoViewController.swift
//  ToDo
//
//  Created by Antarpunit Singh on 2012-05-31.
//  Copyright © 2019 AntarpunitSingh. All rights reserved.
//
import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    var items: Results<Item>?
    let realm = try! Realm()
        var selectedCategory: Category? {
        didSet{
            loadsUp()
        }
        
    }
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let colorHex = selectedCategory?.colorHex else {fatalError()}
        navBarUpdate(with: colorHex)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navBarUpdate(with: "4195FF")
    }
    //Mark - Navbar update Method
    func navBarUpdate (with colourHexCode: String){
        guard  let navBar = navigationController?.navigationBar else { fatalError("Nav Controller not found")}
        
        guard let navColor = UIColor(hexString: colourHexCode) else{fatalError()}
        navBar.barTintColor = navColor
        navBar.tintColor = ContrastColorOf(backgroundColor: navColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(backgroundColor: navColor, returnFlat: true)]
        searchBar.barTintColor = navColor
    }
    
    
    
    
    
    //Mark - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            
            
            if let color = UIColor(hexString: selectedCategory!.colorHex)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
            }
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
    override func updateModel(at indexPath: IndexPath) {
        do {
            try self.realm.write {
                self.realm.delete(self.items![indexPath.row])
            }
        }
        catch{
            print("Error in saving \(error)")
        }
    }
    override func updateDone(at indexPath: IndexPath) {
         let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row]{
         cell.accessoryType = item.done ? .checkmark : .none
//         let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: item.title)
//         attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2,
//                                     range: NSMakeRange(0,attributeString.length))
//            cell.textLabel?.attributedText = attributeString
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
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textfield = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancel)
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
