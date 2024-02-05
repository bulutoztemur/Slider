//
//  ViewController.swift
//  OldExampleSlider
//
//  Created by bulut.oztemur on 05.02.24.
//

import UIKit

class ViewController: UIViewController {
    
    var x: UIStackView = {
       var sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        sv.spacing = 30
        return sv
    }()
    
    var timer = Timer()
    var bar = PlainHorizontalProgressBar()
    
    var dot1 = Dot()
    var dot2 = Dot()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        x.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(x)
        
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        
        NSLayoutConstraint.activate([
            x.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            x.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            bar.heightAnchor.constraint(equalToConstant: 10),
            bar.widthAnchor.constraint(equalToConstant: 70),

        ])
        
        view.backgroundColor = .blue
        x.addArrangedSubview(bar)
        x.addArrangedSubview(dot1)
        x.addArrangedSubview(dot2)
    }
    
    @objc func updateProgress() {
        if bar.progress > 1.00 {
            timer.invalidate()
            
            let y = Dot()
            
            if let index = x.arrangedSubviews.firstIndex(of: bar) {
                let circularIndex = (index + 1) % (x.arrangedSubviews.count)
                // x.arrangedSubviews[index].removeFromSuperview()
                self.bar.removeFromSuperview()
                bar.progress = 0
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
                x.insertArrangedSubview(bar, at: circularIndex)
                // x.insertArrangedSubview(y, at: circularIndex)
            }

        }
        bar.progress += 1 / 40
        
    }
    
}

class Dot: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        backgroundColor = .clear
        layer.backgroundColor = UIColor.red.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 10),
            widthAnchor.constraint(equalToConstant: 10),
        ])


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


@IBDesignable
class PlainHorizontalProgressBar: UIView {
    @IBInspectable var color: UIColor = .red {
        didSet { setNeedsDisplay() }
    }
    
    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    private let progressLayer = CALayer()
    private let backgroundMask = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        backgroundColor?.setFill()
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.5).cgPath
        backgroundMask.backgroundColor = UIColor.orange.cgColor
        backgroundMask.fillColor = UIColor.black.cgColor
        layer.mask = backgroundMask
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))
        
        progressLayer.frame = progressRect
        progressLayer.backgroundColor = color.cgColor
    }
}
