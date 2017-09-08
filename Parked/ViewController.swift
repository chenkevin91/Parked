//
//  ViewController.swift
//  Parked
//
//  Created by Kevin Chen on 9/6/17.
//  Copyright © 2017 Kevin Chen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView!

    var locationManager = CLLocationManager()

    var fakeVehicle = Vehicle(name: "subaru!",
                              users: ["kevin","emily"],
                              location: CLLocation(latitude: 42.1234, longitude: -75.1234))

    var fakeVehicles = [Vehicle]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        checkLocationAuthorizationStatus()
        checkIfLocationServicesAreEnabled()

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(dropPin))
        longPressGestureRecognizer.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressGestureRecognizer)

        fakeVehicles.append(fakeVehicle)
        populateMapWith(vehicles: fakeVehicles)
    }

    func checkLocationAuthorizationStatus()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            mapView.showsUserLocation = true
        }
        else
        {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func checkIfLocationServicesAreEnabled()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

    @IBAction func centerMapOnUserLocation(_ sender: AnyObject)
    {
        if let userLocation = mapView.userLocation.location
        {
            mapView.centerMap(on: userLocation.coordinate, radius: 100.0)
        }
    }

    func dropPin(gestureRecognizer:UIGestureRecognizer)
    {
        if gestureRecognizer.state == .ended
        {
            print("*** PREVIOUS LOC: \(fakeVehicle.location)")
            mapView.removeAnnotations(mapView.annotations)

            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            fakeVehicle.location = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)

            let annotation = MKPointAnnotation()
            annotation.coordinate =  newCoordinates
            mapView.addAnnotation(annotation)
            print("*** NEW LOC: \(fakeVehicle.location)")
        }
    }

    func populateMapWith(vehicles: [Vehicle])
    {
        guard vehicles.isEmpty else
        {
            for vehicle in vehicles
            {
                let annotation = MKPointAnnotation()
                annotation.coordinate = vehicle.location.coordinate
                mapView.addAnnotation(annotation)
            }
            return
        }
    }

}

extension MKMapView
{
    func centerMap(on coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, animated: Bool = true)
    {
        let diameter = radius * 2.0
        let region = MKCoordinateRegionMakeWithDistance(coordinate, diameter, diameter)

        setRegion(region, animated: animated)
    }
}
