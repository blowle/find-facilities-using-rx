//
//  LocalAPI.swift
//  FindFacilities
//
//  Created by yongcheol Lee on 2021/12/30.
//

import Foundation

// https://developers.kakao.com/docs/latest/ko/local/dev-guide
struct LocalAPI {
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let path = "/v2/local/search/category.json"
    
    func getLocation(categoryCode: String, mapPoint: MTMapPoint) -> URLComponents {
        var components = URLComponents()
        
        components.scheme = LocalAPI.scheme
        components.host = LocalAPI.host
        components.path = LocalAPI.path
        
        components.queryItems = [
            URLQueryItem(name: "category_group_code", value: categoryCode),
            URLQueryItem(name: "x", value: "\(mapPoint.mapPointGeo().longitude)"),
            URLQueryItem(name: "y", value: "\(mapPoint.mapPointGeo().latitude)"),
            URLQueryItem(name: "radius", value: "500"),
            URLQueryItem(name: "sort", value: "distance")
        ]

        
        return components
    }
}
