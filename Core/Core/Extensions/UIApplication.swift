//
//  UIApplication.swift
//  Core
//
//  Created by Ismatillokhon on 01/07/24.
//

import Foundation
import UIKit

public func mainIfNeeded(completion: @escaping () -> Void) {
    if Thread.isMainThread {
        completion()
    } else {
        DispatchQueue.main.async {
            completion()
        }
    }
}

public extension UIApplication {
    private var activeWindow: UIWindow? {
        guard let activeView = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            return nil
        }
        
        return activeView
    }
    
    var firstWindow: UIWindow? {
        connectedScenes.first.flatMap { $0 as? UIWindowScene }?.windows.first { $0.isKeyWindow }
    }

    var firstKeyWindow: UIWindow? {
        activeWindow
    }

    func topViewController() -> UIViewController? {
        guard let keyWindow = firstWindow else { return nil }

        return findTopViewController(
            rootViewController: keyWindow.rootViewController?.navigationController ?? keyWindow.rootViewController
        )
    }

    var screenSize: CGSize {
        firstWindow?.frame.size ?? .zero
    }

    var statusBar: CGRect {
        firstWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
    }
    
    @discardableResult
    func dismissKeyboard() -> Bool {
        if activeWindow?.endEditing(true) ?? false {
            return true
        }
        
        return self.topViewController()?.view.endEditing(true) ?? false
    }

    var userInterfaceStyle: UIUserInterfaceStyle? {
        UIApplication.shared.topViewController()?.traitCollection.userInterfaceStyle
    }

    private func findTopViewController(rootViewController: UIViewController?) -> UIViewController? {
        if let controller = rootViewController as? UITabBarController {
            return findTopViewController(rootViewController: controller.selectedViewController)
        } else if let controller = rootViewController as? UINavigationController {
            return findTopViewController(rootViewController: controller.visibleViewController)
        } else if let controller = rootViewController?.presentedViewController {
            return findTopViewController(rootViewController: controller)
        }
        return rootViewController
    }

    private var visibleController: UIViewController? {
        guard let window = UIApplication.shared.firstWindow else {
            debugPrint("No window")
            return nil
        }

        return (window.rootViewController as? UINavigationController)?.visibleViewController
    }

    func popToRootViewController(animated: Bool = false) {
        if visibleController?.navigationController == nil {
            visibleController?.dismiss(animated: false)
            (UIApplication.shared.firstWindow?.rootViewController as? UINavigationController)?.popToRootViewController(animated: animated)
        } else {
            visibleController?.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    var safeArea: UIEdgeInsets {
        guard let activeView = activeWindow else {
            return .zero
        }
        
        return activeView.safeAreaInsets
    }
    
    var screenFrame: CGRect {
        guard let activeView = activeWindow else {
            return .zero
        }
        
        return activeView.frame
    }
    
    var safeAreaFrame: CGRect {
        guard let activeView = activeWindow else {
            return .zero
        }
        
        return activeView.safeAreaLayoutGuide.layoutFrame
    }
    
    var hasDynamicIsland: Bool {
        safeArea.top > 51
    }
}
