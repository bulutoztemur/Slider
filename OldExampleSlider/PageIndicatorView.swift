//
//  PageIndicatorView.swift
//  OldExampleSlider
//
//  Created by bulut.oztemur on 05.02.24.
//

import UIKit
 
class PageIndicatorView: UIView {
    
    // if isProgressBarStopped is true, progress bar does not go. Set true when long press gesture.
    var isProgressBarStopped = false
    // Set true to deactivate timer logic, slides can be changed only by manually
    var autoScrollEnabled: Bool = true
    // Slide change time period
    let timePeriod: CGFloat = 2
    // Timer interval, progress bar works smoothly with value 0.05
    let timeInterval: TimeInterval = 0.05
    // Total page number. Create (page count - 1) dots. (-1) reason is that there will be 1 line.
    var pageCount: Int = 0 {
        didSet {
            if pageCount == 0 { return }
            for _ in 0..<(pageCount - 1) {
                horizontalStackView.addArrangedSubview(DotIndicator())
            }
        }
    }
    
    var timer = Timer()
    var bar = ProgressBarIndicator()
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
        
        setTimerAndProgressBar()
    }
    
    @objc func updateProgressBar() {
        checkProgressBarLevel()
        updateProgressBarLevel()
    }
    
    private func checkProgressBarLevel() {
        if bar.progress >= 1.00 {
            sliderViewDelegate?.scroll(to: (currentPage + 1) % pageCount)
            sliderViewDelegate?.currentPage += 1
        }
    }
    
    private func updateProgressBarLevel() {
        if !isProgressBarStopped {
            bar.progress += CGFloat(timeInterval) / timePeriod
        }
    }
    
    private func setTimerAndProgressBar() {
        if autoScrollEnabled {
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
            bar.progress = 0.00
        } else {
            bar.progress = 1.00
        }
    }
    
    func moveIndicator() {
        self.timer.invalidate()
        self.bar.removeFromSuperview()
        self.horizontalStackView.insertArrangedSubview(self.bar, at: currentPage)
        setTimerAndProgressBar()
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
