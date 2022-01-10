//
//  LocationMapModel.swift
//  FindFacilities
//
//  Created by yongcheol Lee on 2022/01/10.
//

import Foundation
import RxSwift
import RxCocoa

struct LocationMapModel {
    var localNetwork: LocalNetwork
    
    init(localNetwork: LocalNetwork = LocalNetwork()) {
        self.localNetwork = localNetwork
    }
    
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        return localNetwork.getLocation(category: .카페, mapPoint: mapPoint)
    }
    
    func documentsToCellData(_ data: [KLDocument]) -> [DetailListCellData] {
        return data.map {
            let address = $0.roadAddressName?.isEmpty ?? true ? $0.addressName! : $0.roadAddressName!
            let point = documentToMTMapPoint($0)
            
            return DetailListCellData(placeName: $0.placeName!, address: address, distance: $0.distance!, point: point)
        }
    }
    
    func documentToMTMapPoint(_ document: KLDocument) -> MTMapPoint {
        let mtMapPointGeo = MTMapPointGeo(latitude: Double(document.y) ?? .zero, longitude: Double(document.x) ?? .zero)
        return MTMapPoint(geoCoord: mtMapPointGeo)
        
    }
}
