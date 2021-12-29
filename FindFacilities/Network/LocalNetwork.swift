//
//  LocalNetwork.swift
//  FindFacilities
//
//  Created by yongcheol Lee on 2021/12/30.
//

import Foundation
import RxSwift
import RxCocoa

enum HttpMethod: String {
    case GET
    case PUT
    case POST
    case DELETE
}

class LocalNetwork {
    private let session: URLSession
    let api = LocalAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getLocation(categoryCode: String = "", mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        
        guard let url = api.getLocation(
            categoryCode: categoryCode,
            mapPoint: mapPoint).url
        else {
            return .just(.failure(URLError(.badURL)))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Constants.kakaoAPIKEY, forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request)
            .map { data in
                do {
                    let locationData = try JSONDecoder().decode(LocationData.self, from: data)
                    return .success(locationData)
                } catch  {
                    return .failure(URLError(.cannotParseResponse))
                }
            }
            .catch{ _ in .just(Result.failure(URLError(.cannotLoadFromNetwork))) }
            .asSingle()
    }
}
