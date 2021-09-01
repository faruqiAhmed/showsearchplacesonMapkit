//
//  ViewController.swift
//  mapkitsp
//
//  Created by imac os on 1/2/20.
//  Copyright © 2020 imac os. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true,completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        // Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        // hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, Error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if response == nil {
                print("ERROR")
            }
            else{
               // remove annotations
                let annatations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annatations)
                // Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!,longitude!)
                let span_ = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span_)
                self.myMapView.setRegion(region, animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

