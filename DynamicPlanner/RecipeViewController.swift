//
//  RecipeViewController.swift
//  DynamicPlanner
//
//  Created by Jesus perez on 3/25/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import UIKit
import Foundation


class RecipeViewController: UIViewController {

    @IBOutlet weak var recipeLabel: UILabel!
    var hits: [[String: Any]] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHits()
    }

    func getHits() {
        EdamamAPIManager().edamam { (data: [[String: Any]]?, error: Error?) in
            if let data = data {
                self.hits = data
                self.printIngredients()
            }
        }
    }
    func printIngredients() {
//        print("in printIngredients", self.hits)
        if (self.hits.count > 0) {
            let first_hit = self.hits[0]
            print("first_hit = ", first_hit)
            print(type(of: first_hit))
            let recipe = first_hit["recipe"] as! [String: Any]
            print(recipe)
            let ingredients = recipe["ingredientLines"] as! [String?]
            print("ingredients = ", ingredients)
            print("INGREDIENTS[0] = ", ingredients[0]!)
            self.recipeLabel.text = ingredients[0]
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}
