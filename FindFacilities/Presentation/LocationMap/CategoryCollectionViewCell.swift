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
    
    static let identifier = "CategoryCollectionViewCell"
    
    let titleLabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? UIColor.yellow : .white
        }
      }
    
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
        titleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .white.withAlphaComponent(0)
        titleLabel.numberOfLines = 0
        
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = .white
        contentView.layer.borderColor = UIColor.yellow.cgColor
    }
    
    private func layout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
}
