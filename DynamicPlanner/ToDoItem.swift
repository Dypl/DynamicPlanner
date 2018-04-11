//
//  ToDoItem.swift
//  DynamicPlanner
//
//  Created by Nicholas Rosas on 4/2/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ToDoItem: PFObject, PFSubclassing {
    @NSManaged var title: String?
    @NSManaged var isDone: Bool
    @NSManaged var itemDescription: String?

    /* Needed to implement PFSubclassing interface */
    class func parseClassName() -> String {
        return "ToDoItem"
    }
    
    /**
     * Other methods
     */
    
    /**
     Method to add a user post to Parse (uploading todo item)
     
     - parameter title: ToDoItem title/label
     - parameter isDone: Boolean flag to denote if Task is finished
     - parameter user_id: user id to uniquely identify user's ToDoItems
     - parameter completion: Block to be executed after save operation is complete
     */
    
    class func createAndSaveToDoItem(title: String?, itemDescription: String?, isDone: Bool, userID: String?, withCompletion completion: PFBooleanResultBlock?) -> ToDoItem {
        // use subclass approach
        let toDoItem = ToDoItem()
        
        // Add relevant fields to the object
        toDoItem.title = title
        toDoItem.isDone = isDone
        toDoItem.itemDescription = itemDescription
        toDoItem["user_id"] = userID!
        // Save object (following function will save the object in Parse asynchronously)
        toDoItem.saveInBackground(block: completion)
        return toDoItem
    }
}
