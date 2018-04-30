//
//  RecipeViewController.swift
//  DynamicPlanner
//
//  Created by Jesus perez on 3/25/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

class RecipeViewController: UIViewController {

   // @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    @IBOutlet weak var recipe: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    var hits: [[String: Any]] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHits()
        recipe.layer.cornerRadius = 5
        recipe.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        recipe.layer.borderWidth = 0.5
        recipe.clipsToBounds = true
        
        
        

        //view.addSubview(scrollView)
        //scrollView.alwaysBounceVertical = true
       // scrollView.alwaysBounceHorizontal = true
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: 375, height: 1500)
        view.addSubview(scrollView)

    }

    func getHits() {
        activityInd.startAnimating()
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
            let first_hit = self.hits[8]
            //print("first_hit = ", first_hit)
            //print(type(of: first_hit))
            let recipe = first_hit["recipe"] as! [String: Any]
            //print(recipe)
            let ingredients = recipe["ingredientLines"] as! [String?]
            let imageUrl = URL(string: recipe["image"] as! String)
            let title = recipe["label"] as! String
            print(imageUrl)
            //print("ingredients = ", ingredients)
            //print("INGREDIENTS[0] = ", ingredients[0]!)
            self.foodTitle.text = title
            
            self.recipe.layer.borderWidth = 2
            self.foodTitle.layer.borderWidth = 2
            //self.foodImageView.layer.borderWidth = 2 // as you wish

            self.foodImageView.layer.cornerRadius = 10
            self.foodImageView.clipsToBounds = true
            self.foodImageView.af_setImage(withURL: imageUrl!)
            
            var arr = ""
            var i = 0
            while(ingredients.count > i)
            {
                arr += "-\t" + ingredients[i]! + "\n"
                //print(ingredients[i])
                i = i + 1
            }
            print("ARR + ", arr)
            self.recipe.text = arr
            self.activityInd.stopAnimating()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func CGSizeMake(_ width: CGFloat, _ height: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }
}
