//
//  MapVC.swift
//  NearBy
//
//  Created by Mac-Vishal on 14/04/17.
//  Copyright © 2017 Vishal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@objc public protocol NearByDelegate: class {
    
    @objc optional func drawerPositionDidChange(mapListData: NSArray)
}


class MapVC: UIViewController, MKMapViewDelegate ,CLLocationManagerDelegate {
    
    var delegate : NearByDelegate?
    var boundingRegion : MKCoordinateRegion = MKCoordinateRegion()
    var localSearch : MKLocalSearch!
    var locationManager : CLLocationManager!
    var userCoordinate : CLLocationCoordinate2D!
    var locValue:CLLocationCoordinate2D!
    let authorizationStatus = CLLocationManager.authorizationStatus()
    var places: [MKMapItem] = []
    var strCategory : String!
    var viewDetail : UIView!
    
    var mapItemList: [MKMapItem] = []
    
    @IBOutlet weak var mapviews: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = strCategory
        self.locationManager = CLLocationManager()
        self.mapviews.delegate = self
        self.mapviews.showsUserLocation = true
        self.mapviews.mapType = MKMapType(rawValue: 0)!
        self.mapviews.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        if(authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways) {
            locationManager.startUpdatingLocation()
        }
        else
        {
            locationManager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingHeading()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.mapviews!.removeAnnotations(self.mapviews!.annotations)
    }
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        locValue = manager.location!.coordinate
//        let region = MKCoordinateRegion(center: locValue, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//                self.mapviews.setRegion(region, animated: true)
        self.userCoordinate = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        self.locationManager.stopUpdatingLocation()
        self.startSearch(strCategory)
        manager.delegate = nil
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // report any errors returned back from Location Services
    }
    
    
    func startSearch(_ searchString: String?) {
        if self.localSearch?.isSearching ?? false {
            self.localSearch!.cancel()
        }
        
        var newRegion = MKCoordinateRegion()
        newRegion.center.latitude = self.userCoordinate.latitude
        newRegion.center.longitude = self.userCoordinate.longitude

        newRegion.span.latitudeDelta = 0.112872
        newRegion.span.longitudeDelta = 0.109863
        
        let request = MKLocalSearchRequest()
        
        request.naturalLanguageQuery = searchString
        request.region = newRegion
        
        let completionHandler: MKLocalSearchCompletionHandler = {response, error in
            if let actualError = error {

                let alert = UIAlertController(title: "Could not find places",
                                              message: actualError.localizedDescription,
                                              preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.places = response!.mapItems
                self.mapItemList = self.places
                let placeMarks: NSMutableArray = NSMutableArray()

                //Add annotation
                for item in self.mapItemList {
                    let annotation = PlaceAnnotation()
                    annotation.coordinate = item.placemark.location!.coordinate
                    annotation.title = item.name
                    annotation.url = item.url
                    annotation.detailAddress = item.placemark.title
                    self.mapviews!.addAnnotation(annotation)
                    placeMarks.add(item)

                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationMapData"), object: placeMarks)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoryName"), object: self.strCategory)

                self.boundingRegion = response!.boundingRegion
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        self.localSearch = MKLocalSearch(request: request)
        
        self.localSearch!.start(completionHandler: completionHandler)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    //MARK: - MKMapViewDelegate
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKPinAnnotationView? = nil
        
        if annotation is PlaceAnnotation {
            annotationView = self.mapviews!.dequeueReusableAnnotationView(withIdentifier: "Pin") as! MKPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
                //annotationView!.canShowCallout = true
                annotationView!.animatesDrop = true
                
                //Call out detailDisclosure
                /*let detailButton = UIButton(type: .detailDisclosure) as UIView
                annotationView?.rightCalloutAccessoryView = detailButton*/
            }
        }
        return annotationView
    }
    /*func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if (viewDetail != nil) {
            self.HideView(view: viewDetail)
        }
        let capital = view.annotation as! PlaceAnnotation
        let placeName = capital.title
        let detailAddress = capital.detailAddress
        
        self.showDetailView(title: placeName!, address: detailAddress!)
        self.showView(view: viewDetail)
    }*/
    //Call out detailDisclosure
    /*func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if (viewDetail != nil) {
            self.HideView(view: viewDetail)
        }
        let capital = view.annotation as! PlaceAnnotation
        let placeName = capital.title
        let detailAddress = capital.detailAddress

        self.showDetailView(title: placeName!, address: detailAddress!)
        self.showView(view: viewDetail)
    }*/
    /*func showDetailView(title:String,address:String)
    {
        let screenSize: CGRect = UIScreen.main.bounds

        viewDetail = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height, width: screenSize.width, height: 100))
        viewDetail.backgroundColor = UIColor(white: 1, alpha: 0.8)
        self.view.addSubview(viewDetail)
        
        let labelTitle = UILabel(frame: CGRect(x: 5, y: 5, width: screenSize.width-10, height: 21))
        
        labelTitle.textColor = UIColor.black
        let strAddress = String(format: "Title:%@", title)
        labelTitle.text = strAddress
        viewDetail.addSubview(labelTitle)
        
        let labelAddress = UILabel(frame: CGRect(x: 5, y: 30, width: screenSize.width-10, height: 60))
        
        labelAddress.textColor = UIColor.black
        let strDetailAddress = String(format: "Address:%@", address)
        labelAddress.text = strDetailAddress
        viewDetail.addSubview(labelAddress)
    }
    func showView(view: UIView) {
        UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            let screenSize: CGRect = UIScreen.main.bounds
            
            view.frame = CGRect(x: 0, y: self.view.frame.size.height - 100 , width: screenSize.width, height: 100)
            
        }, completion: nil)
    }
    func HideView(view: UIView) {
        UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            let screenSize: CGRect = UIScreen.main.bounds
            
            view.frame = CGRect(x: 0, y: self.view.frame.size.height, width: screenSize.width, height: 100)
            
        }, completion: nil)
    }*/
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

}
extension MapVC: PulleyPrimaryContentControllerDelegate {
    
    func makeUIAdjustmentsForFullscreen(progress: CGFloat)
    {
        
    }
    
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat)
    {
        
    }
}
