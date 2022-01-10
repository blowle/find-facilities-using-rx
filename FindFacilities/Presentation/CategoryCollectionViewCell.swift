//
//  CategoryCollectionViewCell.swift
//  FindFacilities
//
//  Created by yongcheol Lee on 2021/12/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setData(_ title: String) {
        titleLabel.text = title
    }
    
    private func attribute() {
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.backgroundColor = .white
        titleLabel.numberOfLines = 0
    }
    
    private func layout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
}
