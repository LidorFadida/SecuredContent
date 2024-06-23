//
//  UISecuredWindow.swift
//  SecuredContent
//
//  Created by Lidor Fadida on 23/06/2024.
//

import Combine
import UIKit

class UISecuredWindow: UIWindow {

    private var screenshotSecuredOverlay: UIView
    private var screenRecordingSecuredOverlay: UIView
    private lazy var screenCaptureSecuredTextField: UITextField = {
        let securedTextField = UITextField()
        securedTextField.isSecureTextEntry = true
        securedTextField.leftView = screenshotSecuredOverlay
        securedTextField.leftViewMode = .always
        return securedTextField
    }()
    
    private var storeBag = Set<AnyCancellable>()
    
    private lazy var _makeSecure: Void = {
        setupScreenshotSecuredContent()
        observeCaptureDidChange()
    }()
    
    override init(frame: CGRect) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(windowScene: UIWindowScene, screenshotSecuredOverlay: UIView, screenRecordingSecuredOverlay: UIView) {
        self.screenshotSecuredOverlay = screenshotSecuredOverlay
        self.screenRecordingSecuredOverlay = screenRecordingSecuredOverlay
        super.init(windowScene: windowScene)
        commonInit()
    }
    
    init(frame: CGRect, screenshotSecuredOverlay: UIView, screenRecordingSecuredOverlay: UIView) {
        self.screenshotSecuredOverlay = screenshotSecuredOverlay
        self.screenRecordingSecuredOverlay = screenRecordingSecuredOverlay
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        _ = _makeSecure
    }
    
    private func setupScreenshotSecuredContent() {
        addSubview(screenCaptureSecuredTextField)
        guard let superLayer = layer.superlayer else { assertionFailure(); return }
        superLayer.addSublayer(screenCaptureSecuredTextField.layer)
        guard let securedLayer = screenCaptureSecuredTextField.layer.sublayers?.last else { assertionFailure(); return }
        securedLayer.addSublayer(layer)
    }
    
    private func observeCaptureDidChange() {
        if #available(iOS 17, *) {
            Task { @MainActor [weak self] in await self?.registerForTraitCollection() }
        }
        else {
            NotificationCenter
                .default
                .publisher(for: UIScreen.capturedDidChangeNotification)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] notification in
                    self?.didReceive(notification: notification)
                }
                .store(in: &storeBag)
            NotificationCenter.default.post(name: UIScreen.capturedDidChangeNotification, object: nil)
        }
    }
    
    @MainActor
    @available(iOS 17, *)
    private func registerForTraitCollection() async {
        ///Overriding the sceneCaptureState
        traitOverrides.sceneCaptureState = .inactive
        ///Registering for a traitCollection changes
        registerForTraitChanges([UITraitSceneCaptureState.self]) { [weak self] (traitEnvironment: Self, previousTraitCollection) in
            let isCaptured: Bool = switch previousTraitCollection.sceneCaptureState {
            case .unspecified: false
            case .inactive: true
            case .active: false
            @unknown default: false
            }
            self?.setupScreenRecordingOverlay(isCaptured: isCaptured)
        }
        ///Triggering a trait update
        traitOverrides.remove(UITraitSceneCaptureState.self)
        updateTraitsIfNeeded()
    }
    
    private func didReceive(notification: Notification) {
        let isCaptured: Bool = if #available(iOS 16, *),
            let screen = notification.object as? UIScreen { screen.isCaptured } else { UIScreen.main.isCaptured }
        setupScreenRecordingOverlay(isCaptured: isCaptured)
    }
    
    private func setupScreenRecordingOverlay(isCaptured: Bool) {
        screenCaptureSecuredTextField.isSecureTextEntry = !isCaptured
        guard isCaptured else { screenRecordingSecuredOverlay.removeFromSuperview(); return }
        guard screenRecordingSecuredOverlay.superview == nil else { return }
        
        addSubview(screenRecordingSecuredOverlay)
        screenRecordingSecuredOverlay.pinToSuperView()
        layoutIfNeeded()
    }
    
}
