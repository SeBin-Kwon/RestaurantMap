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
    
    enum Category: Int, CaseIterable {
        case 전체
        case 한식
        case 중식
        case 일식
        case 양식
        case 기타
        var description: String {
            switch self {
            case .전체: return "전체"
            case .한식: return "한식"
            case .중식: return "중식"
            case .일식: return "일식"
            case .양식: return "양식"
            case .기타: return "기타"
            }
        }
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
        for item in filteredList {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            annotationList.append(annotation)
            mapView.addAnnotation(annotation)
        }
    }
    
//    let handler: ((UIAlertAction) -> Void)? = { action in
//        guard let title = action.title else { return }
//        guard let filteredList = restaurantDict[title] else { return }
//        mapView.removeAnnotations(self.annotationList)
//        self.annotationList = []
//        for item in filteredList {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
//            self.annotationList.append(annotation)
//            self.mapView.addAnnotation(annotation)
//        }
//    }
    
    @objc
    private func displayActionSheet() {
        print(#function)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        for i in 0..<Category.allCases.count {
            guard let category = Category(rawValue: i) else { return }
            let action = UIAlertAction(title: category.description, style: .default) { action in
                guard let title = action.title else { return }
                guard let filteredList = self.restaurantDict[title] else { return }
                self.mapView.removeAnnotations(self.annotationList)
                self.annotationList = []
                for item in filteredList {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                    self.annotationList.append(annotation)
                    self.mapView.addAnnotation(annotation)
                }
            }
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
    
    private func configureNavigationUI() {
        navigationItem.title = "식당 찾기"
        let right = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(displayActionSheet))
        navigationItem.rightBarButtonItem = right
    }
    
    private func configureSegmentUI() {
        for i in 0..<Category.allCases.count {
            guard let category = Category(rawValue: i) else { return }
            segment.setTitle(category.description, forSegmentAt: i)
        }
    }
    
    private func configureMapView() {
        for i in 0..<restaurantList.count {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurantList[i].latitude, longitude: restaurantList[i].longitude)
            annotation.title = restaurantList[i].name
            annotationList.append(annotation)
            mapView.addAnnotation(annotation)
            restaurantDict["전체", default: [Restaurant]()].append(restaurantList[i])
            if restaurantList[i].category == "카페" || restaurantList[i].category == "분식" || restaurantList[i].category == "샐러드" {
                restaurantDict["기타", default: [Restaurant]()].append(restaurantList[i])
            } else {
                restaurantDict[restaurantList[i].category, default: [Restaurant]()].append(restaurantList[i])
            }
        }
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

