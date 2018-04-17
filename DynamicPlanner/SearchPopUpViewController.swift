//
//  SearchPopUpViewController.swift
//  DynamicPlanner
//
//  Created by Nicholas Rosas on 4/13/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import UIKit
import MapKit

protocol SearchResultDelegate: class {
    func searchResult(destination: String?, lat: String?, lon: String?)
    
}

class SearchPopUpViewController: UIViewController {
    
    
    
  //  var completionHandler:((double, double) -> void)?

    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    weak var delegate: SearchResultDelegate?
    
    var result: String?
    var point_a: String?
    var point_b: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(blurEffectView, at: 0)
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
        NSLayoutConstraint.activate([blurEffectView.heightAnchor.constraint(equalTo: self.view.heightAnchor), blurEffectView.widthAnchor.constraint(equalTo: view.widthAnchor)])
        
        self.showAnimate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }

    @IBAction func doneBtnTapped(_ sender: Any) {
        result = searchBar.text
        
        delegate?.searchResult(destination: self.result, lat: self.point_a, lon: self.point_b )
        print("HERE")
        self.removeAnimate()
    }
}

extension SearchPopUpViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("End editing")
        //delegate?.searchResult(destination: searchBar.text)
        //print(searchBar.text!)
        //self.removeAnimate()
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("is finished editing")
        tableView.isHidden = true
    }
}

extension SearchPopUpViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension SearchPopUpViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension SearchPopUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
           // print(coordinate?.latitude ?? 0.0)
           // print(coordinate?.longitude ?? 0.0)
            self.point_a = String(describing: coordinate!.latitude)
            self.point_b = String(describing: coordinate!.longitude)
            print(self.point_a!)
            print(self.point_b!)
            // function to call to query string.
        //    let result = self.completionHandler?("FUS-ROH-DAH!!!")
            print("This is the result son")
            //print(result!)
           // print("completionHandler returns... \(String(describing: result))")
           print(String(describing: coordinate!))
            //print(coordinate!)
        }
        
        self.result = completion.title + ", " + completion.subtitle
        self.searchBar.text = self.result
        searchCompleter.queryFragment = self.result!
    }
}
