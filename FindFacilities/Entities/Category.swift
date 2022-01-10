//
//  Category.swift
//  FindFacilities
//
//  Created by yongcheol Lee on 2022/01/10.
//

import Foundation

enum Category: String, CaseIterable {
    case 전체
    case 대형마트
    case 편의점
    case 어린이집 = "어린이집/유치원"
    case 학교
    case 학원
    case 주차장
    case 주유소 = "주유소/충전소"
    case 지하철역
    case 은행
    case 문화시설
    case 중개업소
    case 공공기관
    case 관광명소
    case 숙박
    case 음식점
    case 카페
    case 병원
    case 약국
    
    var categoryCode: String? {
        Category.catetoryList[self.rawValue]
    }
    
    static let catetoryList = [
        "전체": "",
        "대형마트": "MT1",
        "편의점": "CS2",
        "어린이집/유치원": "PS3",
        "학교": "SC4",
        "학원": "AC5",
        "주차장": "PK6",
        "주유소/충전소": "OL7",
        "지하철역": "SW8",
        "은행": "BK9",
        "문화시설": "CT1",
        "중개업소": "AG2",
        "공공기관": "PO3",
        "관광명소": "AT4",
        "숙박": "AD5",
        "음식점": "FD6",
        "카페": "CE7",
        "병원": "HP8",
        "약국": "PM9"
    ]
}
