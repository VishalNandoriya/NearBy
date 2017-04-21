//
//  PointOfPlacesVC.swift
//  NearBy
//
//  Created by Mac-Vishal on 14/04/17.
//  Copyright © 2017 Vishal. All rights reserved.
//

import UIKit

class PointOfPlacesVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var categoryPlaces:NSMutableArray!
    
    @IBOutlet var tblView : UITableView!
    
    var places = [Place]()
    
    var searchResultsPlaces = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.getPointOfList()
        // Do any additional setup after loading the view.
    }
    
    //Web service call
    func getPointOfList() {
        
        if let path = Bundle.main.path(forResource: "categories", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    if let json = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as? [String: AnyObject]
                    {
                        let experts = json["pois"] as? [String]
                        
                        for category in experts! {
                            
                            let place = Place()
                            place.title = category
                            
                            self.places.append(place)
                        }
                        self.searchResultsPlaces = self.places
                        
                        self.tblView.alpha = 1.0
                        self.tblView.reloadData()
                    }
                } catch {
                    print("error in JSONSerialization")
                }

            } catch {}
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResultsPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearMeTableViewCell", for: indexPath) as! NearMeTableViewCell
        
        let place = self.searchResultsPlaces[indexPath.row]
        
        cell.titleLabel.text = place.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        let place = self.searchResultsPlaces[indexPath.row]
        vc.strCategory = place.title
        
        let drawerContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerContentViewController")

        let pulleyDrawerVC = PulleyViewController(contentViewController: vc, drawerViewController: drawerContentVC)
        
        self.navigationController?.pushViewController(pulleyDrawerVC, animated: true)

        
    }
       /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension PointOfPlacesVC: UISearchBarDelegate
{
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if searchBar.text == "" {
            self.searchResultsPlaces = self.places
            tblView.reloadData()
        }else{
            
            return
        }
    }
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchBar.text == "" {
           
            self.searchResultsPlaces = self.places
            tblView.reloadData()
        }else {
            return
        }
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchResultsPlaces = self.places
        }else {
            
            self.searchResultsPlaces = []
            
            for string in self.places {
                
                if string.title.lowercased().hasPrefix(searchText.lowercased()) {
                    self.searchResultsPlaces.append(string)
                }
            }
        }
        tblView.reloadData()
        
    }
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        return true
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.searchResultsPlaces = self.places
        
        tblView.reloadData()
    }
    
}
