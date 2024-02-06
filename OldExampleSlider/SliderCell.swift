//
//  SliderCell.swift
//  OldExampleSlider
//
//  Created by bulut.oztemur on 06.02.24.
//

import UIKit

class SliderCell: UICollectionViewCell {
    
    // MARK: - SubViews
        
    // MARK: - Properties
    
    static let cellId = "SliderCell"
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - Setups

private extension SliderCell {
    func setupUI() {}
}

// MARK: - Public

extension SliderCell {
    public func configure(bgColor: UIColor?) {
        backgroundColor = bgColor
    }
}
