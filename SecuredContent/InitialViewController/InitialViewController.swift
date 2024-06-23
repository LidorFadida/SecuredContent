//
//  InitialViewController.swift
//  SecuredContent
//
//  Created by Lidor Fadida on 23/06/2024.
//

import UIKit


class InitialViewController: UIViewController {
    @IBOutlet private weak var showSecureWindowButton: UIButton!
    
    ///Coordinator parameter.
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let action = UIAction { [weak self] _ in
            self?.showSecureWindow()
        }
        showSecureWindowButton.addAction(action, for: .touchUpInside)
    }

    
}

//MARK: - Placed here for simplicity.
///in real-life application the coordinator should handle the logic below.
///
///Remember always to use safe unwrapping, force unwrap is implemented here to simplify the implementation
extension InitialViewController {
    private func showSecureWindow() {
        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first
        
        guard let windowScene = windowScene as? UIWindowScene else { return }
        
        let screenshotCapture = makeScreenshotSecureOverlay()
        let videoCapture = makeScreenRecordingSecureOverlay()
        let viewController = UIStoryboard(name: "SecuredViewController", bundle: .main).instantiateInitialViewController()!
        
        let window: UISecuredWindow = UISecuredWindow(
            windowScene: windowScene,
            screenshotSecuredOverlay: screenshotCapture,
            screenRecordingSecuredOverlay: videoCapture
        )
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
        
    }
    
    private func makeScreenshotSecureOverlay() -> UIView {
        let icon = UIImage(systemName: "lock.shield")!.withRenderingMode(.alwaysOriginal).withTintColor(.systemBlue)
        let configuration = SecuredContentOverlayViewConfiguration(
            icon: icon,
            title: "Screen Capture Disabled",
            subtitle: "To protect our content and creators, screen capturing is not permitted."
        )
        return SecuredContentOverlayView(configuration: configuration)
    }
    
    private func makeScreenRecordingSecureOverlay() -> UIView {
        let icon = UIImage(named: "video.slash")!
        let configuration = SecuredContentOverlayViewConfiguration(
            icon: icon,
            title: "Screen Recording Disabled",
            subtitle: "To ensure the privacy and security of our content, screen recording is not allowed"
        )
        return SecuredContentOverlayView(configuration: configuration)
    }
}

