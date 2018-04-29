//
//  ToDoItemDetailsViewController.swift
//  DynamicPlanner
//
//  Created by Nicholas Rosas on 4/10/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import UIKit
import Parse

class ToDoItemDetailsViewController: UIViewController {

    @IBOutlet weak var titlaLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    var toDoItem: ToDoItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        titlaLabel.text = toDoItem.title
        descriptionLabel.text = toDoItem.itemDescription
        createdAtLabel.text = dateFormatter.string(from: toDoItem.createdAt!)
    }

}
