//
//  SliderView.swift
//  OldExampleSlider
//
//  Created by bulut.oztemur on 06.02.24.
//

import UIKit

protocol SliderViewDelegate {
    var currentPage: Int { get set }
    func scroll(to index: Int)
}

extension SliderView: SliderViewDelegate {
    func scroll(to index: Int) {
        sliderCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
}


class SliderView: UIView {
    struct SliderData {
        let bgColor: UIColor?
    }
    
    // MARK: - Subviews
    
    private lazy var sliderCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.delegate = self
        collection.dataSource = self
        collection.register(SliderCell.self, forCellWithReuseIdentifier: SliderCell.cellId)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collection.backgroundColor = .white
        collection.bounces = true
        return collection
    }()
    
    let pageIndicatorView = PageIndicatorView()
    
    // MARK: - Properties
    
    private var sliderData = [SliderData]() {
        didSet {
            pageIndicatorView.pageCount = sliderData.count
        }
    }
    
    // To make collectionView infinite loop
    private let numberOfBufferItem = 1
    
    var currentPage: Int = 0 {
        didSet {
            currentPage = currentPage % sliderData.count
            pageIndicatorView.currentPage = currentPage
        }
    }
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        setupUI()
        addLongPressGestureRecognizer()
        pageIndicatorView.sliderViewDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let cellPadding = (frame.width - 300) / 2
        let sliderLayout = UICollectionViewFlowLayout()
        sliderLayout.scrollDirection = .horizontal
        sliderLayout.itemSize = .init(width: 300, height: 400)
        sliderLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        sliderLayout.minimumLineSpacing = cellPadding * 2
        sliderCollectionView.collectionViewLayout = sliderLayout

        addSubview(sliderCollectionView)
        sliderCollectionView.translatesAutoresizingMaskIntoConstraints = false
        sliderCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sliderCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        sliderCollectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sliderCollectionView.heightAnchor.constraint(equalToConstant: 450).isActive = true
        
        pageIndicatorView.pageCount = sliderData.count
        pageIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageIndicatorView)
        
        NSLayoutConstraint.activate([
            pageIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageIndicatorView.heightAnchor.constraint(equalToConstant: 4),
            pageIndicatorView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    private func addLongPressGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.pauseAutoSliding(_:)))
        longPressGestureRecognizer.minimumPressDuration = 0.3
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func pauseAutoSliding(_ gestureRecognizer: UILongPressGestureRecognizer) {
       if gestureRecognizer.state == .began {
           pageIndicatorView.timerCount = false
       } else if gestureRecognizer.state == .ended {
           pageIndicatorView.timerCount = true
       }
    }
}

extension SliderView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderData.count + numberOfBufferItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderCell.cellId, for: indexPath) as? SliderCell else { return UICollectionViewCell() }
        
        if sliderData.count == 0 {
            return cell
        }
        let bgColor = sliderData[indexPath.row % sliderData.count].bgColor
        cell.configure(bgColor: bgColor)
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension SliderView: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        currentPage = Int(x / frame.width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let itemSize = sliderCollectionView.contentSize.width/CGFloat(sliderData.count + 1)
        
        if scrollView.contentOffset.x > itemSize*CGFloat(sliderData.count){
            sliderCollectionView.contentOffset.x -= itemSize*CGFloat(sliderData.count)
        }
        if scrollView.contentOffset.x < 0  {
            sliderCollectionView.contentOffset.x += itemSize*CGFloat(sliderData.count)
        }
    }
}

extension SliderView {
    public func configureView(with data: [SliderData]) {
        let cellPadding = (frame.width - 300) / 2
        let sliderLayout = UICollectionViewFlowLayout()
        sliderLayout.scrollDirection = .horizontal
        sliderLayout.itemSize = .init(width: 300, height: 400)
        sliderLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        sliderLayout.minimumLineSpacing = cellPadding * 2
        sliderCollectionView.collectionViewLayout = sliderLayout
        
        sliderData = data
        sliderCollectionView.reloadData()

    }
}

