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
    let homeViewModel = HomeViewModel()
    let adjustNorthByTappingSidesOfScreen = false
    let addNodeByTappingScreen = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        sceneLocationView.arViewDelegate = self
        if let node = homeViewModel.contructNodes(travelDetails: travelDetails, locationManager: locationManager){
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: node)
            sceneView.addSubview(sceneLocationView)
        }
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

