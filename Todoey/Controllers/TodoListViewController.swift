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
    let dataFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        loadItems()
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var uiTextField = UITextField()
        let alert = UIAlertController(title: "Add an Todoey Item", message: "", preferredStyle: .alert)
        let action =  UIAlertAction(title: "Add", style: .default) { (action) in
            print("Success")
            let addItem = Item()
            addItem.title = uiTextField.text!
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
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func saveItem() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFile!)
        } catch {
            print("Error while encoding the list \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {

        if let data =  try? Data(contentsOf: dataFile!) {
          let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error while encoding the list \(error)")
            }
        }
        tableView.reloadData()
    }
    
}


