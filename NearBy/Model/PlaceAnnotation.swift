//
//  PlaceAnnotation.swift
//  NearBy
//
//  Created by Mac-Vishal on 14/04/17.
//  Copyright © 2017 Vishal. All rights reserved.
//

import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var url: URL?
    
}
