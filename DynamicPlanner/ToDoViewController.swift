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
    
    let alert = UIAlertController(title: "New To-Do Item", message: "Enter the item title and description", preferredStyle: .alert
    )
    var actionToEnable: UIAlertAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        setUpAlert()
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (indexPath.row < toDoItems.count) {
            let toDoItem = toDoItems[indexPath.row]
            toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            toDoItem.deleteInBackground()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func setUpAlert() {
        self.alert.addTextField(configurationHandler: { (textField: UITextField!) in
            textField.placeholder = "Enter title"
            textField.addTarget(self, action: #selector(self.textHasChanged(_:)), for: .editingChanged)
        })
        self.alert.addTextField(configurationHandler: { (textField: UITextField!) in
            textField.placeholder = "Enter description"
            textField.addTarget(self, action: #selector(self.textHasChanged(_:)), for: .editingChanged)
        })
        self.alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let createAction = UIAlertAction(title: "Create ", style: .default, handler: { (_) in
                let title = self.alert.textFields?[0].text
                let description = self.alert.textFields?[1].text
            self.addToDoItem(title: title!, description: description!)
                self.clearTextFields()
                self.actionToEnable?.isEnabled = false
        })
        
        self.alert.addAction(createAction)
        
        self.actionToEnable = createAction
        createAction.isEnabled = false
    }
    
    @IBAction func didTapAddNewItem(_ sender: Any) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func clearTextFields() {
        for textField in self.alert.textFields! {
            textField.text = ""
        }
    }
    
    @objc func textHasChanged(_ sender: UITextField) {
        var count = 0
        for textField in self.alert.textFields! {
            if !(textField.text?.isEmpty)! {
                count = count + 1
            }
        }
        
        self.actionToEnable?.isEnabled = count == self.alert.textFields?.count
    }
    
    func addToDoItem(title: String, description: String) {
        let index = toDoItems.count
        let toDoItem = ToDoItem.createAndSaveToDoItem(title: title, itemDescription: description, isDone: false, userID: PFUser.current()!.objectId!) { (success: Bool, error: Error?) in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let toDoItem = self.toDoItems[indexPath.row]
            let detailsViewController = segue.destination as! ToDoItemDetailsViewController
            detailsViewController.toDoItem = toDoItem
        }
    }
}
