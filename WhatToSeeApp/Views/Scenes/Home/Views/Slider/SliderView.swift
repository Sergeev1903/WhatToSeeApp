//
//  PreviewSlider.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import UIKit


protocol SliderViewDelegate: AnyObject {
  func didTapSliderView(
    _ sliderView: SliderView, viewModel: DetailViewModelProtocol)
}


class SliderView: UIView {
  
  // MARK: - Properties
  private var collectionView: UICollectionView!
  private let pageControl = UIPageControl()
  private var currentPageIndex = 0
  private var titleLabel = UILabel()
  private let sliderGradient = CAGradientLayer()
  
  // MARK: - Delegate
  weak var delegate: SliderViewDelegate?
  
  // MARK: - ViewModel
  var viewModel: SliderViewModelProtocol! {
    didSet {
      self.collectionView.reloadData()
      self.pageControl.numberOfPages = self.viewModel.numberOfItemsInSection()
    }
  }
  
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupCollectionView()
    setupTitleLabel()
    setupPageControl()
  }
  
  required init?(coder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Methods
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    setupSliderGradient()
  }
  
  private func setupSliderGradient() {
    // create & add gradient from UIView extension
    self.addGradientInsertSublayer(
      sliderGradient, at: 1,
      colors: [.systemBackground, .clear, .clear, .clear, .systemBackground],
      startPoint: .top, endPoint: .bottom,
      locations: [0.0, 0.2, 0.5, 0.8, 1.0])
  }
  
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    collectionView = UICollectionView(
      frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.isPagingEnabled = true
    collectionView.bounces = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(
      SliderCell.self, forCellWithReuseIdentifier: SliderCell.reuseId)
    
    addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  private func setupTitleLabel() {
    titleLabel.text = "Upcoming"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
    titleLabel.textAlignment = .left
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
    ])
  }
  
  private func setupPageControl() {
    pageControl.currentPage = 0
    pageControl.pageIndicatorTintColor = .lightGray
    pageControl.currentPageIndicatorTintColor = .darkGray
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    
    pageControl.addTarget(
      self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
    
    addSubview(pageControl)
    
    NSLayoutConstraint.activate([
      pageControl.heightAnchor.constraint(equalToConstant: 40),
      pageControl.widthAnchor.constraint(equalToConstant: 160),
      pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
      pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8)
    ])
  }
  
  // Page control change slider item
  @objc private func pageControlDidChange(_ sender: UIPageControl) {
    currentPageIndex = sender.currentPage
    let offsetX = CGFloat(currentPageIndex) * collectionView.frame.width
    collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
  }
  
  // Parallax for slider item
  private func setupParallax(_ collectionView: UICollectionView) {
    let tempo = 200 / collectionView.frame.width
    
    for index in 0 ..< viewModel.numberOfItemsInSection() {
      guard let cell = collectionView.cellForItem(
        at: IndexPath(item: index, section: 0)) as? SliderCell else {
        continue
      }
      
      let newX: CGFloat =
      tempo * (collectionView.contentOffset.x - (CGFloat(index) * collectionView.frame.width))
      cell.imageView.frame.origin.x = newX
    }
  }
  
}


// MARK: - UICollectionViewDataSource
extension SliderView: UICollectionViewDataSource {
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      return viewModel.numberOfItemsInSection()
    }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SliderCell.reuseId, for: indexPath) as! SliderCell
      cell.viewModel = viewModel.cellForItemAt(indexPath: indexPath)
      return cell
    }
  
}


// MARK: - UICollectionViewDelegate
extension SliderView: UICollectionViewDelegate {
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {
      
      let detailViewModel = viewModel.didSelectItemAt(indexPath: indexPath)
      delegate?.didTapSliderView(self, viewModel: detailViewModel)
    }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Slider item change page control index
    let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
    currentPageIndex = pageIndex
    pageControl.currentPage = currentPageIndex
    
    // Call parallax
    setupParallax(collectionView)
  }
  
}


// MARK: - UICollectionViewDelegateFlowLayout
extension SliderView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
      return collectionView.bounds.size
    }
  
}
