//
//  LocationData.swift
//  FindFacilities
//
//  Created by yongcheol Lee on 2021/12/30.
//

import Foundation

struct LocationData: Decodable {
    let documents: [KLDocument]
}

struct KLDocument: Decodable {
    let addressName: String?
    let categoryGroupCode: String?
    let categoryGroupName: String?
    let categoryName: String?
    let distance: String?
    let id: String?
    let phone: String?
    let placeName: String?
    let placeUrl: String?
    let roadAddressName: String?
    let x: String
    let y: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case id, phone, distance
        case placeName = "place_name"
        case placeUrl = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
}
