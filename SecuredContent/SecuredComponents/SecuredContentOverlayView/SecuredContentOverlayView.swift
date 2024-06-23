//
//  SecuredContentOverlayView.swift
//  SecuredContent
//
//  Created by Lidor Fadida on 23/06/2024.
//

import UIKit

class SecuredContentOverlayView: NibDesignable {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    private let configuration: SecuredContentOverlayViewConfiguration
    
    init(frame: CGRect = .zero, configuration: SecuredContentOverlayViewConfiguration) {
        self.configuration = configuration
        super.init(frame: frame)
        commonInit()
    }
    
    @available(*, unavailable)
    init() { fatalError("This class does not support init()") }
    
    @available(*, unavailable)
    override init(frame: CGRect) { fatalError("This class does not support init(frame:)") }
    
    required init?(coder: NSCoder) { fatalError("This class does not support NSCoder") }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    private func commonInit() {
        setupUI()
    }
    
    private func setupUI() {
        iconImageView.image = configuration.icon
        titleLabel.text = configuration.title
        subtitleLabel.text = configuration.subtitle
    }
}
