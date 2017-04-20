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

class MapVC: UIViewController, MKMapViewDelegate ,CLLocationManagerDelegate {
    
    var boundingRegion : MKCoordinateRegion = MKCoordinateRegion()
    var localSearch : MKLocalSearch!
    var locationManager : CLLocationManager!
    var userCoordinate : CLLocationCoordinate2D!
    var locValue:CLLocationCoordinate2D!
    let authorizationStatus = CLLocationManager.authorizationStatus()
    var places: [MKMapItem] = []
    var strCategory : String!
    
    var mapItemList: [MKMapItem] = []
    
    @IBOutlet weak var mapviews: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = strCategory
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

                //Add annotation
                for item in self.mapItemList {
                    let annotation = PlaceAnnotation()
                    annotation.coordinate = item.placemark.location!.coordinate
                    annotation.title = item.name
                    annotation.url = item.url
                    
                    self.mapviews!.addAnnotation(annotation)
                }

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
                annotationView!.canShowCallout = true
                annotationView!.animatesDrop = true
            }
        }
        return annotationView
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

}
