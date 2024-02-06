//
//  PageIndicatorView.swift
//  OldExampleSlider
//
//  Created by bulut.oztemur on 05.02.24.
//

import UIKit
 
class PageIndicatorView: UIView {
    
    var timerCount = true
    var autoScrollEnabled: Bool = true
    let timePeriod: CGFloat = 2
    let timeInterval: TimeInterval = 0.05
    var pageCount: Int = 0 {
        didSet {
            if pageCount == 0 { return }
            for _ in 0..<(pageCount - 1) {
                horizontalStackView.addArrangedSubview(DotIndicator())
            }
        }
    }
    
    var sliderViewDelegate: SliderViewDelegate? = nil

    var currentPage = 0 {
        didSet {
            moveIndicator()
        }
    }
    
    var horizontalStackView: UIStackView = {
       var sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        sv.spacing = 4
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var timer = Timer()
    var bar = ProgressBarIndicator()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(bar)
        
        NSLayoutConstraint.activate([
            horizontalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            horizontalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bar.heightAnchor.constraint(equalToConstant: 4),
            bar.widthAnchor.constraint(equalToConstant: 16)
        ])
        
        if autoScrollEnabled {
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        } else {
            bar.progress = 1.00
        }
    }
    
    @objc func updateProgress() {
        if bar.progress >= 1.00 {
            sliderViewDelegate?.scroll(to: (currentPage + 1) % pageCount)
            sliderViewDelegate?.currentPage += 1
        }
        
        if timerCount {
            bar.progress += CGFloat(timeInterval) / timePeriod
        }
    }
    
    func moveIndicator() {
        self.timer.invalidate()
        resetProgressBar()
        self.bar.removeFromSuperview()
        self.horizontalStackView.insertArrangedSubview(self.bar, at: currentPage)
        if self.autoScrollEnabled {
            self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
        }
    }
    
    func resetProgressBar() {
        self.bar.progress = self.autoScrollEnabled ? 0.0 : 1.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DotIndicator: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 2
        backgroundColor = .clear
        layer.backgroundColor = UIColor.gray.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 4),
            widthAnchor.constraint(equalToConstant: 4),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProgressBarIndicator: UIView {
    var color: UIColor = .blue {
        didSet { setNeedsDisplay() }
    }
    
    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    private let progressLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        layer.addSublayer(progressLayer)
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 2
        layer.masksToBounds = true
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))
        
        progressLayer.frame = progressRect
        progressLayer.backgroundColor = color.cgColor
    }
}
