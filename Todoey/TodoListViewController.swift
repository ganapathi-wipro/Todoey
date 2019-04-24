//
//  ViewController.swift
//  Todoey
//
//  Created by Ganapathi on 23/04/2019.
//  Copyright © 2019 Ganapathi. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Tamil", "Telugu", "Malayalam"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var uiTextField = UITextField()
        let alert = UIAlertController(title: "Add an Todoey Item", message: "", preferredStyle: .alert)
        let action =  UIAlertAction(title: "Add", style: .default) { (action) in
            print("Success")
            self.itemArray.append(uiTextField.text!)
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
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

