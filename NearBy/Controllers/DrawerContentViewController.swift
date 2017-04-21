//
//  Place.swift
//  NearBy
//
//  Created by Mac-Vishal on 14/04/17.
//  Copyright © 2017 Vishal. All rights reserved.
//

import UIKit
import MapKit
class DrawerContentViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var gripperView: UIView!
    @IBOutlet var lblCategory: UILabel!
    var arrPlaces : NSMutableArray!
    @IBOutlet var seperatorHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrPlaces = NSMutableArray()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMapData), name: NSNotification.Name(rawValue: "NotificationMapData"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getCategoryName), name: NSNotification.Name(rawValue: "categoryName"), object: nil)
        
        // Do any additional setup after loading the view.
        gripperView.layer.cornerRadius = 2.5
        seperatorHeightConstraint.constant = 1.0 / UIScreen.main.scale
    }
    func getMapData(_ notification: Notification)
    {
        arrPlaces = notification.object as? NSMutableArray
        tableView.reloadData()
    }
    func getCategoryName(_ notification: Notification)
    {
        lblCategory.text = notification.object as? String
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DrawerContentViewController: PulleyDrawerViewControllerDelegate {
    
    func collapsedDrawerHeight() -> CGFloat
    {
        return 68.0
    }
    
    func partialRevealDrawerHeight() -> CGFloat
    {
        return 264.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all // You can specify the drawer positions you support. This is the same as: [.open, .partiallyRevealed, .collapsed, .closed]
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController)
    {
        tableView.isScrollEnabled = drawer.drawerPosition == .open
        
        if drawer.drawerPosition != .open
        {
            
        }
    }
}

extension DrawerContentViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if let drawerVC = self.parent as? PulleyViewController
        {
            drawerVC.setDrawerPosition(position: .open, animated: true)
        }
    }
}

extension DrawerContentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath ) as! CategoryCell
        let item = arrPlaces[indexPath.row] as? MKMapItem
        
        cell.titleLabel.text = item?.name
        cell.addressLable.text = item?.placemark.title
        
        return cell
    }
}

extension DrawerContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}


