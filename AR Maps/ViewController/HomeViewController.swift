//
//  HomeViewController.swift
//  AR Maps
//
//  Created by Siddhant Mishra on 19/04/20.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import ARKit
import ARCL

class HomeViewController: UIViewController {
    
    @IBOutlet weak var destinationBtn: UIButton!
    @IBOutlet weak var homeMapView: GMSMapView!
    @IBOutlet weak var navigateBtn: UIButton!
    
    var currentLocation = CLLocationCoordinate2D()
    var destination : GMSPlace?
    var locationManager = CLLocationManager()
    var polyStringPath : String?
    var travelDetails: TravelDetail?
    let homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupMapView()
    }
    
    func setupMapView()  {
        self.homeMapView?.isMyLocationEnabled = true
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        homeMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    
    @IBAction func navigateBtnAction(_ sender: Any) {
        if let polyStringPath = polyStringPath {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DirectionsViewController") as? DirectionsViewController
            vc?.polyString = polyStringPath
            vc?.travelDetails = travelDetails
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @IBAction func destinationBtnAction(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        currentLocation = location!.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 10.0)
        
        self.homeMapView?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        
    }
}

//MARK: Google maps Delegate functions
extension HomeViewController : GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.destinationBtn.setTitle(place.name, for: .normal)
        homeMapView.clear()
        destination = place
        homeViewModel.drawPath(src: currentLocation, dst: place.coordinate) {[weak self](isSuccess, polyString,travelDetail) in
            self?.homeViewModel.drawPolylineAndAdjustCamera(mapView: self?.homeMapView, polyString: polyString, polyColr: .black)
            self?.polyStringPath = polyString
            self?.travelDetails = travelDetail
        }
        
        let destinationMarker = homeViewModel.setupMarker(location: place.coordinate, title: place.name!, type: "Defaults")
        destinationMarker.map = homeMapView
        homeMapView.selectedMarker = destinationMarker
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
}
