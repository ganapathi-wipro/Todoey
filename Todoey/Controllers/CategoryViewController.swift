//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ganapathi on 03/05/2019.
//  Copyright © 2019 Ganapathi. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var CategoryArray = [Category]()
    var defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var uiTextField = UITextField()
        let alert = UIAlertController(title: "Add a Todoey Category", message: "", preferredStyle: .alert)
        let action =  UIAlertAction(title: "Add", style: .default) { (action) in

            let addItem = Category(context: self.context)
            addItem.category = uiTextField.text!
            self.CategoryArray.append(addItem)
            self.saveCategory()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Create a category"
            uiTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destionationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
           destionationVC.selectedCategory = self.CategoryArray[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = CategoryArray[indexPath.row]
        cell.textLabel?.text = category.category
        return cell
    }
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error saving context  \(error)")
        }
        tableView.reloadData()
       
    }

    func loadCategory() {
        let request : NSFetchRequest <Category> = Category.fetchRequest()
        do {
            CategoryArray = try context.fetch(request)
        } catch {
            print("Error while fetching data \(error)")
        }
        tableView.reloadData()
        
    }

}
