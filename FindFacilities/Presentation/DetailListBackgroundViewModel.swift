//
//  DetailListBackgroundViewModel.swift
//  FindFacilities
//
//  Created by yongcheol Lee on 2022/01/10.
//

import Foundation
import RxCocoa
import RxSwift

struct DetailListBackgroundViewModel {
    // view model -> view
    let isStatusLabelHidden: Signal<Bool>
    
    // from external side
    let shouldHideStatusLabel = PublishSubject<Bool>()
    
    init() {
        isStatusLabelHidden = shouldHideStatusLabel
            .asSignal(onErrorJustReturn: true)
    }
}
