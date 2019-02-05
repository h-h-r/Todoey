//
//  ViewController.swift
//  Todoey
//
//  Created by Haoran Hu on 1/28/19.
//  Copyright © 2019 hhr. All rights reserved.
//

import UIKit
//import Item
import CoreData

class TodoListViewController: UITableViewController  {

    
    var itemArray = [Item]()
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
//    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //print( NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String )
        //go check library/prefernce for persistant data plist

        print("???",self.dataFilePath!)
        
        
//        loadItems()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
       
        cell.textLabel?.text = itemArray[indexPath.row].title

        cell.accessoryType = self.itemArray[indexPath.row].done == true ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        //delete sth
//        self.context.delete(self.itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        self.itemArray[indexPath.row].done = !self.itemArray[indexPath.row].done
        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var  textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: " ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) {
            (UIAlertAction) in
            //what will happen once user hit the "Add item"
//            print(textField.text!)
            
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
//            let encoder = PropertyListEncoder()
//            do{
//                let data = try encoder.encode(self.itemArray)
//                try data.write(to: self.dataFilePath!)
//            }catch {
//                print("error encoding error: \(error)")
//            }
//            self.tableView.reloadData()
            
            self.saveItems()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        self.present(alert,animated: true, completion: nil)
//        present(
    }
    
    func saveItems(){
//        let encoder = PropertyListEncoder()
        do{
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath!)
            try self.context.save()
        }catch {
            print("error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil){
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.selectedCategory!.name!)
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
//        request.predicate = compoundPredicate
        do {
          self.itemArray = try context.fetch(request)
        }catch {
            print("error fetching data from context: \(error)")
        }
        tableView.reloadData()
    }
    
    
}

//MARK: - SearchBar Methods

extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
    
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,predicate: predicate)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

