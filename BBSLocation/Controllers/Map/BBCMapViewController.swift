//
//  BBCMapViewController.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BBCMapViewController: BBCBaseViewController {

    var viewModel: BBCMapViewModel?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var standard: UIButton!
    @IBOutlet weak var satellite: UIButton!
    @IBOutlet weak var hybrid: UIButton!
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var navigationView: UIView!
    private var locationManager: CLLocationManager!
    private var currentLocation: [CLLocation]!
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialViewPropertyImplement()
        self.determineCurrentLocation()
        self.showScalerONMapview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Initiate the map view
        self.createMapView()
    }
    
    //MARK: - Button action
    @IBAction func navidationCompassButtonPressed(_ sender: Any) {
        //Get the user current location
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion.init(center: (locationManager.location?.coordinate)!, span: span)
        mapView.setRegion(region, animated: true)
        
        navigationButton.isSelected  = !navigationButton.isSelected
        
        //Change the button action based on press the same "navigationButton"
        if (navigationButton.isSelected) {
            navigationButton.isSelected = true
            navigationButton.setImage(UIImage(named: "gps"), for: .normal)
            locationManager.startUpdatingLocation()
            
        }else{
            navigationButton.isSelected = false
            navigationButton.setImage(UIImage(named: "compass"), for: .normal)
            locationManager.stopUpdatingLocation()
        }
        
        //Get the current location
        self.getCurrentLocation(location: currentLocation, manager: locationManager)
    }
    
    //Navigation back
    @IBAction func navigationBackButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Change the map type and button title color
    @IBAction func changeMapType(_ sender: Any) {
        let tag = (sender as AnyObject).tag
        
        guard sender is UIButton else {
            return}
        
        switch (tag){
        case BBCConstants.Tags.STANDERS_BUTTON_TAG?:
            mapView.mapType = .standard
            standard.setTitleColor(.lightGray, for: .normal)
            satellite.setTitleColor(.darkGray, for: .normal)
            hybrid.setTitleColor(.darkGray, for: .normal)
        case BBCConstants.Tags.SATALITE_BUTTON_TAG?:
            mapView.mapType = .satellite
            standard.setTitleColor(.darkGray, for: .normal)
            satellite.setTitleColor(.lightGray, for: .normal)
            hybrid.setTitleColor(.darkGray, for: .normal)
        case BBCConstants.Tags.HYBRID_BUTTON_TAG?:
            mapView.mapType = .hybrid
            standard.setTitleColor(.darkGray, for: .normal)
            satellite.setTitleColor(.darkGray, for: .normal)
            hybrid.setTitleColor(.lightGray, for: .normal)
        default:
            return
        }
    }
    
    //MARK: - Custom methods
    func initialViewPropertyImplement() {
        //Add the shodow effect to the navigation header
        navigationView!.layer.shadowOffset = CGSize(width: 0, height: 0)
        navigationView!.layer.shadowColor = UIColor.lightGray.cgColor
        navigationView!.layer.shadowRadius = 5
        navigationView!.layer.shadowOpacity = 0.40
        navigationView!.layer.masksToBounds = false
        navigationView!.clipsToBounds = false
        
        //Access the String file
        standard.setTitle(NSLocalizedString("Map_type_standerd", comment: ""), for: UIControlState.normal)
        satellite.setTitle(NSLocalizedString("Map_type_satalite", comment: ""), for: UIControlState.normal)
        hybrid.setTitle(NSLocalizedString("Map_type_hybrid", comment: ""), for: UIControlState.normal)
        
        //Set the button tag for changing the map type
        standard.tag = BBCConstants.Tags.STANDERS_BUTTON_TAG
        satellite.tag = BBCConstants.Tags.SATALITE_BUTTON_TAG
        hybrid.tag = BBCConstants.Tags.HYBRID_BUTTON_TAG
    }
    
    /*
     Initially set up the map delegate and permissions
     */
    func createMapView() {
        mapView.delegate = self
        
        //Enable the default map features
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        mapView.isPitchEnabled = true
        
        //Change the button text color
        standard.setTitleColor(.lightGray, for: .normal)
        satellite.setTitleColor(.darkGray, for: .normal)
        hybrid.setTitleColor(.darkGray, for: .normal)
        
        // Or, if needed, we can position map in the center of the view
        mapView.center = view.center
    }
    
    /*
     GEt significunet location changes
     */
    func startReceivingSignificantLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return
        }
        
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The service is not available.
            return
        }
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    /*
     Initially get th ecurrent loaction
     */
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingHeading()
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
    }
    
    /*
     Navigate to the default app settings page
     - so as to change the location services
     */
    func redirectToSettingsPage() {
        guard let profileUrl = URL(string: "App-Prefs:root=Privacy") else {
            return
        }
        if UIApplication.shared.canOpenURL(profileUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(profileUrl, completionHandler: { (success) in
                    //print(" Profile Settings opened: \(success)")
                })
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    /*
     Request the location information
     */
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    /*
     Get the current location information to
     - show on the user current location
     */
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            let aadd = viewModel?.processTheAddress(localitys: locality!, postalCodes: postalCode!, administrativeAreas: administrativeArea!, countrys: country!)
            
            let theLocation: MKUserLocation = mapView.userLocation
            theLocation.title = aadd
            headerLabel.text = (viewModel?.city?.name)!+" "+(viewModel?.city?.country)!
        }
    }
    
    //Show validation by common method
    func showErrorAlertPopup(title:String, message:String, okButtonTitle:String, cancelButtonTitle:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Create Ok actions
        let okAction = UIAlertAction(title: okButtonTitle, style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.redirectToSettingsPage()
        }
        
        // Create Cancel actions
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Show scaler on mapview
    func showScalerONMapview() {
        if #available(iOS 11.0, *) {
            let scale = MKScaleView(mapView: mapView)
            scale.scaleVisibility = .visible // always visible
            scale.frame = CGRect(x: 10, y: 90, width: scale.frame.size.width, height: scale.frame.size.height)
            view.addSubview(scale)
        } else {
            // Fallback on earlier versions
        }
    }
}

extension BBCMapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations
        let city = viewModel?.city?.name ?? ""
        let country = viewModel?.city?.country ?? ""
        let passedLat:Double = (viewModel?.city?.location?.lat)!
        let passedLon:Double = (viewModel?.city?.location?.lat)!
        
        //Set the location title
        headerLabel.text = city+", "+country
        
        /*
         Call stopUpdatingLocation() to stop listening for location updates,
         other wise this function will be called every time when user location changes.
         */
        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: passedLat, longitude: passedLon)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        // Remove old anotation
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(passedLat, passedLon)
        myAnnotation.title = city
        myAnnotation.subtitle = country
        mapView.addAnnotation(myAnnotation)
        
        //Set the annotation
        mapView.setRegion(region, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        mapView.camera.heading = newHeading.magneticHeading
        mapView.setCamera(mapView.camera, animated: true)
    }
    
    func getCurrentLocation(location: [CLLocation], manager: CLLocationManager) {
        //Get the address of the current location
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
            break
        case .restricted, .denied :
            self.showErrorAlertPopup(title: BBCConstants.CustomErrorCodes.LOCATION_SERVICE ,message: BBCConstants.CustomErrorCodes.LOCATION_SERVICE_DEFINETION, okButtonTitle: BBCConstants.CustomErrorCodes.ALERT_SETTINGS_BUTTON, cancelButtonTitle: BBCConstants.CustomErrorCodes.ALERT_SETTINGS_CANCEL)
            break
        }
    }
}

extension BBCMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage = UIImage(named: "current_location")
        annotationView!.image = pinImage
        return annotationView
    }
}
