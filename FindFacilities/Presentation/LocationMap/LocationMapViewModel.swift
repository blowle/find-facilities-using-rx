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
    let selectedCategory: Category = .전체
    
    // view model -> view
    let setMapCenter: Signal<MTMapPoint>
    let errorMessage: Signal<String>
    
    // view -> view model
    
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
//    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewErorr = PublishRelay<String>()
    let currentLocationButtonTapped = PublishRelay<Void>()
    
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
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation)
        
        let currentMapCenter = Observable
            .merge(
                currentLocation.take(1),
                moveToCurrentLocation
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        errorMessage = Observable
            .merge(
                mapViewErorr.asObservable(),
                locationDataErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
        
        
        
    }
    
}

extension LocationMapViewModel {

}
