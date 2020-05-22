//
//  ViewController.swift
//  AR Maps
//
//  Created by Siddhant Mishra on 19/04/20.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import UIKit
import ARKit
import ARCL
import CoreLocation

class DirectionsViewController: UIViewController {
    
    
    @IBOutlet weak var sceneView: UIView!
    @IBOutlet weak var directionMapView: UIView!
    
    @IBOutlet weak var alt: UILabel!
    var travelDetails = TravelDetail()
    var polyString : String?
    var mapView : DirectionMapView!
    
    
    var sceneLocationView = SceneLocationView()
    private let locationManager = CLLocationManager()
    let displayDebugging = false
    
    let adjustNorthByTappingSidesOfScreen = false
    let addNodeByTappingScreen = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        sceneLocationView.showAxesNode = true
//        sceneLocationView.showFeaturePoints = displayDebugging
        
        sceneLocationView.arViewDelegate = self
//        sceneLocationView.locationNodeTouchDelegate = self
        contructNodes()
        sceneView.addSubview(sceneLocationView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMapView()
        locationManager.requestWhenInUseAuthorization()
        sceneLocationView.run()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }
    
    func setupMapView(){
        mapView = DirectionMapView().loadNib() as? DirectionMapView
        mapView.frame = CGRect(x: 0, y: 0, width: directionMapView.frame.width, height: directionMapView.frame.height)
        mapView.setupMapView(polyString: polyString!)
        directionMapView.addSubview(mapView)
        directionMapView.addTopRoundedCornerToView(desiredCurve: 4.0)
        
    }
    
    private func addNewLocation(){
        if var steps = travelDetails?.directions{
            if steps.count > 0{
                //                steps.remove(at: 0)
                let doubleLat = steps.first!.startlat!
                let doubleLon = steps.first!.startlon!
                
                let lat = CLLocationDegrees(exactly: doubleLat)
                let lon = CLLocationDegrees(exactly: doubleLon)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                let location = CLLocation(coordinate: coordinate, altitude: 300)
                let view = UIView() // or a custom UIView subclass
                
                let annotationNode = LocationAnnotationNode(location: location, view: view)
                sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
            }
        }
    }
    
    func contructNodes() {
        if let steps = travelDetails?.directions{
            let altitude = locationManager.location?.altitude
            alt.text = "\(altitude ?? 0)"
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
                sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: locationNode)
            }
        }
    }
    
}

extension DirectionsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            mapView.refreshDirectionMap(location: location)
        }        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            // AR won't work
            navigationController?.popViewController(animated: true)
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        @unknown default: break
        }
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
}

@available(iOS 11.0, *)
extension DirectionsViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("Added SCNNode: \(node)")    // you probably won't see this fire
    }

    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        print("willUpdate: \(node)")    // you probably won't see this fire
    }

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print("Camera: \(camera)")
    }

}

