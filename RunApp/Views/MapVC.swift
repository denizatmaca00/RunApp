//
//  MapVc.swift
//  RunApp
//
//  Created by d-datmaca on 5.03.2024.
// TODO: current loc
// TODO: themeColor pin
// TODO: koşu başlangıç noktası pin
// TODO: koşu bitiş noktası yol


import UIKit
import MapKit

class MapVC: UIViewController , MKMapViewDelegate {
    
    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Harita görünümü oluştur
        mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        // Harita görünümüne otolayout kısıtlamaları ekle
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Harita üzerine bir konum ekleyelim
        let initialLocation = CLLocation(latitude: 40.93567, longitude: 29.15507)
        let regionRadius: CLLocationDistance = 1000
        centerMapOnLocation(location: initialLocation, radius: regionRadius)
        
        // Opsiyonel olarak harita üzerine bir pin ekleyebiliriz
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation.coordinate
        annotation.title = "Maltepe"
        annotation.subtitle = "İstanbul, Turkey"
        mapView.addAnnotation(annotation)
    }
    
    func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
