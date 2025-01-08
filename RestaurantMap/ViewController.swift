//
//  ViewController.swift
//  RestaurantMap
//
//  Created by Sebin Kwon on 1/8/25.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var segment: UISegmentedControl!
    
    let restaurantList = RestaurantList().restaurantArray
    var annotationList = [MKPointAnnotation]()
    var restaurantDict = [String: [Restaurant]]()
    
    enum Category: String, CaseIterable {
        case 전체
        case 한식
        case 중식
        case 일식
        case 양식
        case 기타
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureMapView()
        displayAllAnnotation()
        configureSegmentUI()
        configureNavigationUI()
    }
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        guard let title = sender.titleForSegment(at: sender.selectedSegmentIndex) else { return }
        guard let filteredList = restaurantDict[title] else { return }
        mapView.removeAnnotations(annotationList)
        annotationList = []
        filteredList.forEach {
            updateAnnotation($0)
        }
        displayAllAnnotation()
    }
    
    @objc
    private func displayActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        for i in 0..<Category.allCases.count {
            let category = Category.allCases[i].rawValue
            let action = UIAlertAction(title: category, style: .default) { action in
                guard let title = action.title else { return }
                guard let filteredList = self.restaurantDict[title] else { return }
                self.mapView.removeAnnotations(self.annotationList)
                self.annotationList = []
                filteredList.forEach {
                    self.updateAnnotation($0)
                }
                self.displayAllAnnotation()
            }
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
    
    private func configureSegmentUI() {
        for i in 0..<Category.allCases.count {
            segment.setTitle(Category.allCases[i].rawValue, forSegmentAt: i)
        }
    }
    
    private func updateAnnotation(_ item: Restaurant) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        annotation.title = item.name
        annotationList.append(annotation)
        mapView.addAnnotation(annotation)
    }
    
    private func configureMapView() {
        restaurantList.forEach {
            updateAnnotation($0)
            initializeDictionay($0)
        }
    }
    
    private func initializeDictionay(_ item: Restaurant) {
        restaurantDict["전체", default: [Restaurant]()].append(item)
        if item.category == "카페" ||
            item.category == "분식" ||
            item.category == "샐러드" {
            restaurantDict["기타", default: [Restaurant]()].append(item)
        } else {
            restaurantDict[item.category, default: [Restaurant]()].append(item)
        }
    }
    
    private func configureNavigationUI() {
        navigationItem.title = "식당 찾기"
        let right = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(displayActionSheet))
        navigationItem.rightBarButtonItem = right
    }
    
    func displayAllAnnotation() {
        var zoomRect = MKMapRect.null
        for annotation in annotationList {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01);
            zoomRect = zoomRect.union(pointRect);
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
    
    
}

