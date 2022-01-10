//
//  LocationMapViewModel.swift
//  FindFacilities
//
//  Created by yongcheol Lee on 2021/12/30.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

struct LocationMapViewModel {
    let localNetwork = LocalNetwork()
    
    let disposeBag = DisposeBag()
    let selectedCategory: Category = .학원
    
    let detailBackgrouondViewModel = DetailListBackgroundViewModel()
    
    // view model -> view
    let setMapCenter: Signal<MTMapPoint>
    let errorMessage: Signal<String>
    let detailListCellData: Driver<[DetailListCellData]>
    let scrollToSelectedLocation: Signal<Int>
    
    // view -> view model
    
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError = PublishRelay<String>()
    let currentLocationButtonTapped = PublishRelay<Void>()
    let detailListItemSelected = PublishRelay<Int>()
    
    private let documentData = PublishSubject<[KLDocument]>()
    
    init(_ model: LocationMapModel = LocationMapModel()) {
        let locationDataResult = mapCenterPoint
            .flatMapLatest(model.getLocation)
            .share()
        
        let locationDataValue = locationDataResult
            .compactMap { data -> LocationData? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value
            }
        
        let locationDataErrorMessage = locationDataResult
            .compactMap { data -> String? in
                switch data {
                case .success(let data) where data.documents.isEmpty:
                    return """
                    500m 근처에 이용할 수 있는 편의점이 없어요.
                    지도 위치를 옮겨서 재검색해주세요.
                    """
                case .failure(let error):
                    return error.localizedDescription
                default: // locationDataValue's success
                    return nil
                }
            }
        
        locationDataValue
            .map { $0.documents }
            .bind(to: documentData)
            .disposed(by: disposeBag)
        
        // MARK: 지도 중심점 설정
        let selectedDetailListItem = detailListItemSelected
            .withLatestFrom(documentData) { $1[$0] }
            .map(model.documentToMTMapPoint)
        
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation)
        
        let currentMapCenter = Observable
            .merge(
                selectedDetailListItem,
                currentLocation.take(1),
                moveToCurrentLocation
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        errorMessage = Observable
            .merge(
                mapViewError.asObservable(),
                locationDataErrorMessage
            )
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요.")
        
        
        detailListCellData = documentData
            .map(model.documentsToCellData)
            .asDriver(onErrorDriveWith: .empty())
        
        documentData
            .map { !$0.isEmpty }
            .bind(to: detailBackgrouondViewModel.shouldHideStatusLabel)
            .disposed(by: disposeBag)
        
        scrollToSelectedLocation = selectPOIItem
            .map { $0.tag }
            .asSignal(onErrorJustReturn: 0)
    }
    
}

extension LocationMapViewModel {

}
