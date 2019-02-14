//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Haoran Hu on 2/4/19.
//  Copyright © 2019 hhr. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        print("!!!",self.dataFilePath)
    }
    
    func loadCategories(){
        self.categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    var categoryArray : Results<Category>?
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Items.plist")
    
    
    //MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
//        print("xxx: ",indexPath.row)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No catogory added yet"
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
            destinationVC.selectedCategory = self.categoryArray?[indexPath.row]
        }
    }
    //MARK: - Table view delegate methods
    
    
    //MARK: - Add new category
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("add button pressed")
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: " ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (UIAlertAction) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        self.present(alert,animated: true,completion: nil)
    }
    
    func save(category : Category){
        do {
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    //MARK: - Table view delegate methods
    


}

//extension CategoryViewController :
