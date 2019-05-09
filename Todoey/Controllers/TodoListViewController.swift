//
//  ViewController.swift
//  Todoey
//
//  Created by Ganapathi on 23/04/2019.
//  Copyright © 2019 Ganapathi. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    var defaults = UserDefaults.standard
    let dataFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var uiTextField = UITextField()
        let alert = UIAlertController(title: "Add a Todoey Item", message: "", preferredStyle: .alert)
        let action =  UIAlertAction(title: "Add", style: .default) { (action) in
            print("Success")
            
            let addItem = Item(context: self.context)
            addItem.title = uiTextField.text!
            addItem.done = false
            addItem.parentCategory = self.selectedCategory
            self.itemArray.append(addItem)
            self.saveItem()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Create an item"
            uiTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func saveItem() {

        do {
           try context.save()
        } catch {
            print("Error saving context  \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.category MATCHES %@ ", selectedCategory!.category!)
        if let addlPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addlPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("Error while fetching data \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate : NSPredicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true) ]
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
             loadItems()
        }
       
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
}

