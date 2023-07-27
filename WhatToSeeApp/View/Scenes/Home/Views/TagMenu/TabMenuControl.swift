//
//  CustomSegmentedControl.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit


class TabMenuControl: UIControl {
  
  // MARK: - Properties
  private var buttons = [UIButton]()
  private var underlineView = UIView()
  private var scrollView: UIScrollView!
  
  var selectedSegmentIndex: Int = 0 {
    didSet {
      updateSegmentedControl()
    }
  }
  
  var segments: [String] = [] {
    didSet {
      setupSegmentedControl()
    }
  }
  
  var segmentTintColor: UIColor = .blue {
    didSet {
      updateSegmentedControl()
    }
  }
  
  var underlineColor: UIColor = .blue {
    didSet {
      underlineView.backgroundColor = underlineColor
    }
  }
  
  var underlineHeight: CGFloat = 2.0 {
    didSet {
      underlineView.frame.size.height = underlineHeight
      updateSegmentedControl()
    }
  }
  
  var underlineAnimationDuration: TimeInterval = 0.3
  
  var buttonSpacing: CGFloat = 16 {
    didSet {
      updateSegmentedControl()
    }
  }
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupScrollView()
    setupSegmentedControl()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupScrollView()
    setupSegmentedControl()
  }
  
  // MARK: - Methods
  private func setupScrollView() {
    scrollView = UIScrollView(frame: bounds)
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(scrollView)
  }
  
  private func setupSegmentedControl() {
    buttons.forEach { $0.removeFromSuperview() }
    buttons.removeAll()
    
    segments.forEach { segment in
      let button = UIButton(type: .system)
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
      button.setTitleColor(.label, for: .selected)
      button.setTitleColor(.gray, for: .normal)
      button.setTitle(segment, for: .normal)
      button.addTarget(
        self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
      buttons.append(button)
      scrollView.addSubview(button)
    }
    
    scrollView.addSubview(underlineView)
    updateSegmentedControl()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    scrollView.frame = bounds
    scrollView.contentSize = CGSize(
      width: calculateContentWidth(), height: frame.height)
    
    var xOffset: CGFloat = buttonSpacing
    let buttonHeight = frame.height
    
    for button in buttons {
      let buttonWidth = button.titleLabel?.intrinsicContentSize.width ?? 0
      button.frame = CGRect(
        x: xOffset, y: 0, width: buttonWidth, height: buttonHeight)
      xOffset += buttonWidth + buttonSpacing
    }
    
    updateUnderlineViewFrame()
  }
  
  private func calculateContentWidth() -> CGFloat {
    var contentWidth: CGFloat = 0.0
    
    for button in buttons {
      contentWidth += button.titleLabel?.intrinsicContentSize.width ?? 0
    }
    
    return contentWidth + CGFloat(buttons.count - 1) * buttonSpacing
  }
  
  private func updateSegmentedControl() {
    buttons.enumerated().forEach { index, button in
      button.tintColor = segmentTintColor
      button.isSelected = index == selectedSegmentIndex
    }
    
    UIView.animate(withDuration: underlineAnimationDuration) {
      self.updateUnderlineViewFrame()
    }
  }
  
  private func updateUnderlineViewFrame() {
    guard selectedSegmentIndex >= 0 && selectedSegmentIndex < buttons.count
    else {
      return
    }
    
    let selectedButton = buttons[selectedSegmentIndex]
    let underlineWidth = selectedButton.titleLabel?
      .intrinsicContentSize.width ?? 0
    
    let x = selectedButton.frame.origin.x +
    (selectedButton.frame.width - underlineWidth) / 2
    let y = frame.height - underlineHeight
    let width = underlineWidth
    
    underlineView.frame = CGRect(
      x: x, y: y, width: width, height: underlineHeight)
  }
  
  @objc private func segmentTapped(_ sender: UIButton) {
    guard let index = buttons.firstIndex(of: sender) else { return }
    selectedSegmentIndex = index
    sendActions(for: .valueChanged)
  }
  
}

