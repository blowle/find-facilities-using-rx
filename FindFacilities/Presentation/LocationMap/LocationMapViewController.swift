//
//  LocationMapViewController.swift
//  FindFacilities
//
//  Created by yongcheol Lee on 2021/12/30.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import SnapKit

class LocationMapViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let viewModel = LocationMapViewModel()
    let locationManager = CLLocationManager()
    
    let mapView = MTMapView()
    let currentLocationButton = UIButton()
    let tableView = UITableView()
//    let categoryList = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
        bind(viewModel)
        attribute()
        layout()
    }
    
    private func bind(_ viewModel: LocationMapViewModel) {
        
    }
    
    private func attribute() {
        title = "내 주변 편의시설 찾기"
        view.backgroundColor = .white
        
        // mapview
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        
        // currentLocationButton
        currentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        currentLocationButton.backgroundColor = .white
        currentLocationButton.layer.cornerRadius = 20
        
        registerCells()
        tableView.separatorStyle = .none
//        tableView.backgroundView
        
//        categoryList.backgroundColor = .red
    }
    
    
    private func layout() {
        [mapView, currentLocationButton, tableView /*, categoryList */].forEach { view.addSubview($0) }
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.centerY).offset(16)
        }
        
        currentLocationButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalTo(tableView.snp.top).offset(-12)
            $0.width.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.centerX.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-4)
//            $0.bottom.equalTo(categoryList.snp.top).offset(-4)
            $0.top.equalTo(mapView.snp.bottom)
        }
        
//        categoryList.snp.makeConstraints {
//            $0.centerX.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(-8)
//            $0.top.equalTo(mapView.snp.bottom)
//        }
    }
    
    private func registerCells() {
        
        // table view
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "DetailTableViewCell")
        
        //collection view
//        categoryList.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: : "CategoryCollectionViewCell")
    }
    
    
}
