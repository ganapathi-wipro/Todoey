//
//  ViewController.swift
//  Todoey
//
//  Created by Ganapathi on 23/04/2019.
//  Copyright © 2019 Ganapathi. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var defaults = UserDefaults.standard
     
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let newItem = Item()
        newItem.title = "Tamil"
        itemArray.append(newItem)
        let newItem1 = Item()
        newItem1.title = "Telugu"
        itemArray.append(newItem1)
        
        if let items = defaults.array(forKey: "RegionalCategoryArray") as? [Item] {
            itemArray = items
        }
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var uiTextField = UITextField()
        let alert = UIAlertController(title: "Add an Todoey Item", message: "", preferredStyle: .alert)
        let action =  UIAlertAction(title: "Add", style: .default) { (action) in
            print("Success")
            let addItem = Item()
            addItem.title = uiTextField.text!
            self.itemArray.append(addItem)
            self.defaults.set(self.itemArray, forKey: "RegionalCategoryArray")
            self.tableView.reloadData()
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
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

