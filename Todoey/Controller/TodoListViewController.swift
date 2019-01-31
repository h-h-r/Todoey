//
//  ViewController.swift
//  Todoey
//
//  Created by Haoran Hu on 1/28/19.
//  Copyright © 2019 hhr. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController  {

    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print( NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String )
        //go check library/prefernce for persistant data plist
//        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
//            self.itemArray = items
//        }
        let newItem = Item()
        newItem.title = "Find a"
        self.itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find b"
        self.itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find c"
        self.itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            self.itemArray = items
        }



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
        
        self.itemArray[indexPath.row].done = !self.itemArray[indexPath.row].done
        
        tableView.reloadData()
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var  textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: " ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) {
            (UIAlertAction) in
            //what will happen once user hit the "Add item"
//            print(textField.text!)
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        self.present(alert,animated: true, completion: nil)
//        present(
    }
    
    
    
    
    
    
    
}

