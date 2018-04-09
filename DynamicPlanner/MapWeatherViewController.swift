//
//  MapWeatherViewController.swift
//  DynamicPlanner
//
//  Created by Jesus perez on 3/25/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import UIKit

class MapWeatherViewController: UIViewController {

    @IBOutlet weak var bbFindAddress: UIBarButtonItem!
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var lblInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
// Tool bar action items
    @IBAction func findAddress(_ sender: Any) {
    }
    @IBAction func changeMapType(_ sender: Any) {
    }
    @IBAction func createRoute(_ sender: Any) {
    }
    @IBAction func changeTravelMode(_ sender: Any) {
    }
}
