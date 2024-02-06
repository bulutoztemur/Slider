//
//  ViewController.swift
//  OldExampleSlider
//
//  Created by bulut.oztemur on 05.02.24.
//

import UIKit

class ViewController: UIViewController {
    
    let sliderView = SliderView()
    private var sliderData = [SliderView.SliderData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        sliderData.append(.init(bgColor: .red))
        sliderData.append(.init(bgColor: .green))
        sliderData.append(.init(bgColor: .blue))        
        
        view.addSubview(sliderView)
        sliderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sliderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sliderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sliderView.heightAnchor.constraint(equalToConstant: 450)
        ])

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sliderView.configureView(with: sliderData)
    }

    func generateRandomColor() -> UIColor {
      let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
      let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
      let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
            
      return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}



