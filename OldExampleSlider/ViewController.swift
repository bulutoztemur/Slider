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
}



