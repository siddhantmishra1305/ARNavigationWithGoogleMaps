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
                    
                    //changing the tint color of the image
            //        markerView.tintColor = #colorLiteral(red: 0.262745098, green: 0.2588235294, blue: 0.3294117647, alpha: 1)
                    
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
    
}


