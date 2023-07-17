//
//  PreviewSliderView.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit


class PreviewSliderView: UITableViewHeaderFooterView {
  
  // MARK: - Properties
  static  let reuseId = "PreviewSliderView"
  private let scrollView = UIScrollView()
  private let pageControl = UIPageControl()
  private var currentPageIndex = 0
  var images: [UIImage] = [] {
    didSet {
      setupScrollView()
      setupPageControl()
    }
  }
  
  
  // MARK: - Methods
  func setImages(images: [UIImage]) {
    self.images = images
  }
  
  private func setupScrollView() {
    scrollView.contentSize = CGSize(
      width: frame.width * CGFloat(images.count),
      height: frame.height)
    
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.isPagingEnabled = true
    scrollView.bounces = false
    scrollView.delegate = self
    addSubview(scrollView)
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(
        equalTo: topAnchor),
      scrollView.bottomAnchor.constraint(
        equalTo: bottomAnchor),
      scrollView.leadingAnchor.constraint(
        equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(
        equalTo: trailingAnchor)
    ])
    
    createImageViewsForEachImageinArray()
    
  }
  
  private func createImageViewsForEachImageinArray() {
    for (index, image) in images.enumerated() {
      let view = ParallaxView()
      view.frame = CGRect(
        x: frame.width * CGFloat(index),
        y: 0,
        width:frame.width,
        height: frame.height)
      view.imageView.image = image
      view.tag = index + 10
      scrollView.addSubview(view)
    }
  }
  
  private func setupPageControl() {
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    pageControl.numberOfPages = images.count
    pageControl.currentPage = 0
    pageControl.pageIndicatorTintColor = UIColor.lightGray
    pageControl.currentPageIndicatorTintColor = UIColor.darkGray
    
    pageControl.addTarget(
      self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
    
    addSubview(pageControl)
    
    NSLayoutConstraint.activate([
      pageControl.centerXAnchor.constraint(
        equalTo: centerXAnchor),
      pageControl.heightAnchor.constraint(
        equalToConstant: 40),
      pageControl.widthAnchor.constraint(
        equalToConstant: 160),
      pageControl.bottomAnchor.constraint(
        equalTo: bottomAnchor, constant: 8)
    ])
  }
  
  @objc func pageControlDidChange(_ sender: UIPageControl) {
    currentPageIndex = sender.currentPage
    let offsetX = CGFloat(currentPageIndex) * scrollView.frame.width
    scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
  }
  
  
  // MARK: setupImageParallax
  private func setupImageParallax(_ scrollView: UIScrollView) {
    let tempo = 200 / scrollView.frame.width
    
    for index in 0 ..< images.count {
      let parallaxView = scrollView.viewWithTag(index + 10) as? ParallaxView
      let newX: CGFloat = tempo *
      (scrollView.contentOffset.x - CGFloat(index) *
       scrollView.frame.width)
      
      guard let parallaxView else {
        return
      }
      parallaxView.imageView.frame = CGRect(
        x: newX, y: parallaxView.imageView.frame.origin.y,
        width: parallaxView.imageView.frame.width,
        height: parallaxView.imageView.frame.height)
    }
  }
  
}


// MARK: - UIScrollViewDelegate
extension PreviewSliderView: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
    currentPageIndex = pageIndex
    pageControl.currentPage = currentPageIndex
    
    setupImageParallax(scrollView)
  }
  
}

