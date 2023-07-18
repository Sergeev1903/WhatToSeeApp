//
//  PreviewSlider.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import UIKit


class Slider: UIView {
  
  // MARK: - Properties
  private var collectionView: UICollectionView!
  private let pageControl = UIPageControl()
  private var currentPageIndex = 0
  
  var tempData: [UIImage] = [
    UIImage(named: "1")!, UIImage(named: "2")!,
    UIImage(named: "3")!, UIImage(named: "4")!,
    UIImage(named: "5")!, UIImage(named: "6")!,
  ]
  
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupCollectionView()
    setupPageControl()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  
  // MARK: - Methods
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.isPagingEnabled = true
    collectionView.bounces = false
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(
      SliderItem.self,
      forCellWithReuseIdentifier: SliderItem.reuseId)
    
    addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func setupPageControl() {
    pageControl.numberOfPages = tempData.count
    pageControl.currentPage = 0
    pageControl.pageIndicatorTintColor = UIColor.lightGray
    pageControl.currentPageIndicatorTintColor = UIColor.darkGray
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    
    pageControl.addTarget(
      self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
    
    addSubview(pageControl)
    
    NSLayoutConstraint.activate([
      pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
      pageControl.heightAnchor.constraint(equalToConstant: 40),
      pageControl.widthAnchor.constraint(equalToConstant: 160),
      pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8)
    ])
  }
  
  // Page control change slider item
  @objc func pageControlDidChange(_ sender: UIPageControl) {
    currentPageIndex = sender.currentPage
    let offsetX = CGFloat(currentPageIndex) * collectionView.frame.width
    collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
  }
  
  // Parallax for slider item
  private func setupParallax(_ collectionView: UICollectionView) {
    let tempo = 200 / collectionView.frame.width
    
    for index in 0 ..< tempData.count {
      guard let cell = collectionView.cellForItem(
        at: IndexPath(item: index, section: 0)) as? SliderItem else {
        continue
      }
      
      let newX: CGFloat = tempo * (collectionView.contentOffset.x - (CGFloat(index) * collectionView.frame.width))
      cell.imageView.frame.origin.x = newX
    }
  }
  
}

// MARK: - UICollectionViewDataSource
extension Slider: UICollectionViewDataSource {
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      return tempData.count
    }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SliderItem.reuseId, for: indexPath) as! SliderItem
      let image = tempData[indexPath.item]
      cell.configureSliderItem(with: image)
      return cell
    }
  
}


// MARK: - UICollectionViewDelegate
extension Slider: UICollectionViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Slider item change page control index
    let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
    currentPageIndex = pageIndex
    pageControl.currentPage = currentPageIndex
    
    setupParallax(collectionView)
  }
  
}

extension Slider: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      return collectionView.bounds.size
    }
  
}
