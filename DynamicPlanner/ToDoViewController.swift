//
//  ToDoViewController.swift
//  DynamicPlanner
//
//  Created by Jesus perez on 3/25/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import UIKit
import Parse

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var toDoItems: [ToDoItem] = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        fetchToDoItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        
        if indexPath.row < toDoItems.count {
            let toDoItem = toDoItems[indexPath.row]
            if let title = toDoItem.title {
                cell.titleLabel.text = title
            }
            
            let accessory: UITableViewCellAccessoryType = toDoItem.isDone ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < toDoItems.count {
            let toDoItem = toDoItems[indexPath.row]
                toDoItem.isDone = !toDoItem.isDone
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func didTapAddNewItem(_ sender: Any) {
        let alert = UIAlertController(title: "New To-Do Item", message: "Enter the item title", preferredStyle: .alert
        )
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
            alert.addAction(UIAlertAction(title: "Create ", style: .default, handler: { (_) in
                if let title = alert.textFields?[0].text {
                    self.addToDoItem(title: title)
                }
            }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addToDoItem(title: String) {
        let index = toDoItems.count
        let toDoItem = ToDoItem.createAndSaveToDoItem(title: title, isDone: false, userID: PFUser.current()!.objectId!) { (success: Bool, error: Error?) in
            if let error = error {
            print(error.localizedDescription)
            } else {
                print("saved to do item")
            }
        }
        toDoItems.append(toDoItem)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath.init(row: index, section: 0)], with: .top)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (indexPath.row < toDoItems.count) {
            let toDoItem = toDoItems[indexPath.row]
            toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            toDoItem.deleteInBackground()
        }
    }
    
    private func fetchToDoItems() {
        if !activityIndicator.isAnimating {
            activityIndicator.startAnimating()
        }
        let query = PFQuery(className: "ToDoItem")
        query.includeKey("user_id")
        query.whereKey("user_id", equalTo: PFUser.current()!.objectId!)
        
        query.findObjectsInBackground { (toDoItems: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let items = toDoItems {
                    self.toDoItems = items as!  [ToDoItem]
                    self.tableView.reloadData()
                    if self.activityIndicator.isAnimating {
                        self.tableView.isHidden = false
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
