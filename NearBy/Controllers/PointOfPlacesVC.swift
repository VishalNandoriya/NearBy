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
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearMeTableViewCell", for: indexPath) as! NearMeTableViewCell
        
        let place = self.places[indexPath.row]
        
        cell.titleLabel.text = place.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
         let place = self.places[indexPath.row]
        vc.strCategory = place.title
        self.navigationController?.pushViewController(vc, animated: true)
        
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
