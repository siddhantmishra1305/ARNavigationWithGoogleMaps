//
//  HomeViewModel.swift
//  AR Maps
//
//  Created by Siddhant Mishra on 19/04/20.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces
import GoogleMaps
import ARCL
import ARKit

class HomeViewModel{
    
    typealias routeCallback = (Bool?, String?,TravelDetail?) -> Void
    
    func drawPath(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D ,completion:@escaping routeCallback) {
        ServerManager.sharedInstance.getPath(origin: "\(src.latitude),\(src.longitude)", destination: "\(dst.latitude),\(dst.longitude)", sensor: false) { (response, error,travelDetail) in
            if error != nil{
                completion(false,error?.details.message,nil)
            }else{
                completion(true,response,travelDetail)
            }
        }
    }
    
    
    func setupMarker(location:CLLocationCoordinate2D,title:String,type:String) -> GMSMarker{
        let marker = GMSMarker()
        let img = UIImage(named: "DefaultMarker")?.withRenderingMode(.alwaysTemplate)
        
        if let image = img{
            let markerImage = self.imageWithImage(image: image, scaledToSize: CGSize(width: 25.0, height: 25.0))
                    
                    //creating a marker view
                    let markerView = UIImageView(image: markerImage)

                    marker.position = location
                    marker.iconView = markerView
        }
        
        return marker
    }
    
    func drawPolylineAndAdjustCamera(mapView:GMSMapView?,polyString:String?,polyColr:UIColor){
        DispatchQueue.main.async(execute: {
            if let mapString = polyString{
                let path = GMSPath(fromEncodedPath: mapString)
                let polyline = GMSPolyline(path: path)
                
                polyline.strokeWidth = 2.0
                
                polyline.strokeColor = polyColr
                polyline.map = mapView
                if mapView != nil
                {
                    let bounds = GMSCoordinateBounds(path: path!)
                    mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                }
            }
        })
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func contructNodes(travelDetails:TravelDetail?,locationManager:CLLocationManager)->LocationNode?{
          if let steps = travelDetails?.directions{
              let altitude = locationManager.location?.altitude
              for i in 0..<steps.count-1 {
                  
                  let currentdoubleLat = steps[i].startlat
                  let currentdoubleLon = steps[i].startlon
                  
                  let currentlat = CLLocationDegrees(exactly: currentdoubleLat!)
                  let currentlon = CLLocationDegrees(exactly: currentdoubleLon!)
                  let currentcoordinate = CLLocationCoordinate2D(latitude: currentlat!, longitude: currentlon!)
                  
                  
                  let nextdoubleLat = steps[i+1].startlat
                  let nextdoubleLon = steps[i+1].startlon
                  
                  let nextcurrentlat = CLLocationDegrees(exactly: nextdoubleLat!)
                  let nextcurrentlon = CLLocationDegrees(exactly: nextdoubleLon!)
                  let nextcurrentcoordinate = CLLocationCoordinate2D(latitude: nextcurrentlat!, longitude: nextcurrentlon!)
                  
                  let currentLocation = CLLocation(coordinate: currentcoordinate, altitude: altitude!)
                  let nextLocation = CLLocation(coordinate: nextcurrentcoordinate, altitude: altitude!)
                  let midLocation = currentLocation.approxMidpoint(to: nextLocation)
                  
                  let distance = currentLocation.distance(from: nextLocation)
                  
                  let box = SCNBox(width: 0.75, height: 0.5, length: CGFloat(distance), chamferRadius: 0.25)
                  box.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.7)
                  let boxNode = SCNNode(geometry: box)
                  boxNode.removeFlicker()
                  
                  let bearing = -currentLocation.bearing(between: nextLocation)
                  
                  // Orient the line to point from currentLoction to nextLocation
                  boxNode.eulerAngles.y = Float(bearing).degreesToRadians
                  
                  let locationNode = LocationNode(location: midLocation, tag: "")
                  locationNode.addChildNode(boxNode)
                  return locationNode
              }
          }
        return nil
      }
    
}


