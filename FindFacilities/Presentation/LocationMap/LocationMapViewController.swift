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
    let detailList = UITableView()
    let detailListBackgroundView = DetailListBackgroundView()
    
    private let categoryList: UICollectionView = {
        let inset: CGFloat = 16.0
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .yellow.withAlphaComponent(0.5)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
    
        categoryList.delegate = self
        categoryList.dataSource = self
        
        
        bind(viewModel)
        attribute()
        layout()
    }
    
    private func bind(_ viewModel: LocationMapViewModel) {
        // view -> view model
        currentLocationButton.rx.tap
            .bind(to: viewModel.currentLocationButtonTapped)
            .disposed(by: disposeBag)
        
        // view model -> view
        viewModel.setMapCenter
            .emit(to: mapView.rx.setMapCenterPoint)
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit(to: self.rx.presentAlert)
            .disposed(by: disposeBag)
        
        viewModel.detailListCellData
            .drive(detailList.rx.items) { tableview, row, data in
                let cell = tableview.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as! DetailTableViewCell
                
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.detailListCellData
            .map { $0.compactMap { $0.point } }
            .drive(self.rx.addPOIItems)
            .disposed(by: disposeBag)
        
        detailListBackgroundView.bind(viewModel.detailBackgrouondViewModel)
        
        detailList.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.detailListItemSelected)
            .disposed(by: disposeBag)
        
        viewModel.scrollToSelectedLocation
            .emit(to: self.rx.showSelectedLocation)
            .disposed(by: disposeBag)
        
        
        
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
        detailList.separatorStyle = .none
        detailList.backgroundView = detailListBackgroundView
        
//        categoryList.backgroundColor = .red
    }
    
    
    private func layout() {
        [mapView, currentLocationButton, detailList, categoryList].forEach { view.addSubview($0) }
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.centerY).offset(100)
        }
        
        currentLocationButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalTo(detailList.snp.top).offset(-12)
            $0.width.height.equalTo(40)
        }
        
        detailList.snp.makeConstraints {
            $0.centerX.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(categoryList.snp.top).offset(-4)
            $0.top.equalTo(mapView.snp.bottom)
        }
        
        categoryList.snp.makeConstraints {
            $0.centerX.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(-8)
            $0.top.equalTo(mapView.snp.bottom)
            $0.height.equalTo(50)
        }
    }
    
    private func registerCells() {
        
        // table view
        detailList.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        
        // collection view
        categoryList.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    }
    
    
}

extension LocationMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            return
        default:
            viewModel.mapViewError.accept(MTMapViewError.locationAuthorizationDeinied.errorDescription)
            return
        }
    }
}

extension LocationMapViewController: MTMapViewDelegate {
    
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        #if DEBUG
        viewModel.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.394225, longitude: 127.110341)))
        #else
         viewModel.currentLocation.accept(location)
        #endif
    }
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
         viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
         viewModel.selectPOIItem.accept(poiItem)
        
        return false
    }
    
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
         viewModel.mapViewError.accept(error.localizedDescription)
        
    }
}


// MARK: Reactive - MTMapView
extension Reactive where Base: MTMapView {
    var setMapCenterPoint: Binder<MTMapPoint> {
        return Binder(base) { base, point in
            base.setMapCenter(point, animated: true)
        }
    }
}

extension Reactive where Base: LocationMapViewController {
    var presentAlert: Binder<String> {
        return Binder(base) { base, message in
            
            let alertController = UIAlertController(
                title: "문제가 발생했습니다.",
                message: message,
                preferredStyle: .alert
            )
            
            alertController.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil
                )
            )
            
            base.present(alertController, animated: true, completion: nil)
        }
    }
    
    var showSelectedLocation: Binder<Int> {
        return Binder(base) { base, row in
            let indexPath = IndexPath(row: row, section: 0)
            base.detailList.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        }
    }
    
    var addPOIItems: Binder<[MTMapPoint]> {
        return Binder(base) { base, points in
            let items = points
                .enumerated()
                .map { offset, point -> MTMapPOIItem in
                    let mapPOIItem = MTMapPOIItem()
                    
                    mapPOIItem.mapPoint = point
                    mapPOIItem.markerType = .redPin
                    mapPOIItem.showAnimationType = .springFromGround
                    mapPOIItem.tag = offset
                    
                    debugPrint(mapPOIItem.mapPoint.mapPointGeo())
                    
                    return mapPOIItem
                }
            base.mapView.removeAllPOIItems()
            base.mapView.addPOIItems(items)
        }
    }
}


extension LocationMapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Category.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setData(Category.allCases[indexPath.row].title)
        
        return cell
    }
}

extension LocationMapViewController: UICollectionViewDelegateFlowLayout {
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 8
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 16
        }

        // cell 사이즈( 옆 라인을 고려하여 설정 )
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 60, height: 40)
        }
}
