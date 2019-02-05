//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Haoran Hu on 2/4/19.
//  Copyright © 2019 hhr. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        print("!!!",self.dataFilePath)
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            self.categoryArray = try self.context.fetch(request)
        }catch {
            print("error fetching data from context: \(error)")
        }
        tableView.reloadData()
    }
    
    
    var categoryArray = [Category]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
//        print("xxx: ",indexPath.row)
        cell.textLabel?.text = categoryArray[indexPath.row].name
//        cell.accessoryType = self.categoryArray[indexPath.row].done == true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
        
//        self.categoryArray[indexPath.row].done = !self.categoryArray[indexPath.row].done
//        saveCategories()
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = self.categoryArray[indexPath.row]
        }
    }
    //MARK: - Table view delegate methods
    
    
    //MARK: - Add new category
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("add button pressed")
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: " ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (UIAlertAction) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        self.present(alert,animated: true,completion: nil)
    }
    
    func saveCategories(){
        do {
            try self.context.save()
        }catch{
            print("error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    //MARK: - Table view delegate methods
    


}

//extension CategoryViewController :
