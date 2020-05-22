//
//  DirectionMapView.swift
//  AR Maps
//
//  Created by Siddhant Mishra on 20/04/20.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class DirectionMapView: UIView {
    @IBOutlet weak var directionMapView: GMSMapView!
    
    func setupMapView(polyString:String)  {
        var polyColor = UIColor()
        self.directionMapView.isMyLocationEnabled = true
        directionMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        directionMapView.addTopRoundedCornerToView(desiredCurve: 3.0)
        directionMapView.animate(toZoom: 20)
        
        if getTime() >= 8 {
            do{
                if let styleURL = Bundle.main.url(forResource: "nightMode", withExtension: "json"){
                    self.directionMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    polyColor = UIColor.white
                }
            } catch{
                print("Error loading Style !!!")
            }
        }else{
            polyColor = UIColor.black
        }
        
        let homeViewModel = HomeViewModel()
        homeViewModel.drawPolylineAndAdjustCamera(mapView: directionMapView, polyString: polyString, polyColr: polyColor)
        self.directionMapView.animate(toZoom: 30)
    }
    
    func getTime() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        return hour
    }
    
    func refreshDirectionMap(location:CLLocation){
        let currentLocation = location.coordinate
//        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10.0)
//        self.directionMapView?.animate(to: camera)
        
    }
    
}
