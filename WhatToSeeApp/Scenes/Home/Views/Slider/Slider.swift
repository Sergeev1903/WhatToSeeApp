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
  
  
    // MARK: - ViewModel
  private var viewModel: SliderViewModelProtocol!
  
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViewModel()
    setupCollectionView()
    setupPageControl()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    print("Sorry only code, no storyboards")
  }
  
  
  // MARK: - Methods
  
  private func setupViewModel() {
    viewModel = SliderViewModel(service: MoviesService())
    viewModel.getMedia {
      self.collectionView.reloadData()
      self.pageControl.numberOfPages = self.viewModel.mediaItems.count
    }
  }
  
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
    
    for index in 0 ..< viewModel.mediaItems.count {
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
      return viewModel.numberOfItemsInSection()
    }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SliderItem.reuseId, for: indexPath) as! SliderItem
      cell.viewModel = viewModel.cellForItemAt(indexPath: indexPath)
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
    
    // Call parallax
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
