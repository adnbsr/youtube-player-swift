//
//  AppSnackbarController+SearhController.swift
//  PlayTube
//
//  Created by Adnan Basar on 18/01/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation
import Material
import UIKit

@objc(SnackbarControllerDelegate)
public protocol SnackbarControllerDelegate {
    /**
     A delegation method that is executed when a Snackbar will show.
     - Parameter snackbarController: A SnackbarController.
     - Parameter snackbar: A Snackbar.
     */
    @objc
    optional func snackbarController(snackbarController: AppSnackbarController, willShow snackbar: Snackbar)
    
    /**
     A delegation method that is executed when a Snackbar did show.
     - Parameter snackbarController: A SnackbarController.
     - Parameter snackbar: A Snackbar.
     */
    @objc
    optional func snackbarController(snackbarController: AppSnackbarController, didShow snackbar: Snackbar)
    
    /**
     A delegation method that is executed when a Snackbar will hide.
     - Parameter snackbarController: A SnackbarController.
     - Parameter snackbar: A Snackbar.
     */
    @objc
    optional func snackbarController(snackbarController: AppSnackbarController, willHide snackbar: Snackbar)
    
    /**
     A delegation method that is executed when a Snackbar did hide.
     - Parameter snackbarController: A SnackbarController.
     - Parameter snackbar: A Snackbar.
     */
    @objc
    optional func snackbarController(snackbarController: AppSnackbarController, didHide snackbar: Snackbar)
}

@objc(SnackbarAlignment)
public enum SnackbarAlignment: Int {
    case top
    case bottom
    case upper
}

extension UIViewController {
    /**
     A convenience property that provides access to the SnackbarController.
     This is the recommended method of accessing the SnackbarController
     through child UIViewControllers.
     */
    public var snackbarController: AppSnackbarController? {
        var viewController: UIViewController? = self
        while nil != viewController {
            if viewController is AppSnackbarController {
                return viewController as? AppSnackbarController
            }
            viewController = viewController?.parent
        }
        return nil
    }
}

open class AppSnackbarController: RootController {
    /// Reference to the Snackbar.
    open let snackbar = Snackbar()
    
    /// A boolean indicating if the Snacbar is animating.
    open internal(set) var isAnimating = false
    
    /// Delegation handler.
    open weak var delegate: SnackbarControllerDelegate?
    
    /// Snackbar alignment setting.
    open var snackbarAlignment = SnackbarAlignment.bottom
    
    /// A preset wrapper around snackbarEdgeInsets.
    open var snackbarEdgeInsetsPreset = EdgeInsetsPreset.none {
        didSet {
            snackbarEdgeInsets = EdgeInsetsPresetToValue(preset: snackbarEdgeInsetsPreset)
        }
    }
    
    /// A reference to snackbarEdgeInsets.
    @IBInspectable
    open var snackbarEdgeInsets = EdgeInsets.zero {
        didSet {
            layoutSubviews()
        }
    }
    
    /**
     Animates to a SnackbarStatus.
     - Parameter status: A SnackbarStatus enum value.
     */
    @discardableResult
    open func animate(snackbar status: SnackbarStatus, delay: TimeInterval = 0, animations: ((Snackbar) -> Void)? = nil, completion: ((Snackbar) -> Void)? = nil) -> MotionDelayCancelBlock? {
        return Motion.delay(time: delay) { [weak self, status = status, animations = animations, completion = completion] in
            guard let s = self else {
                return
            }
            
            if .visible == status {
                s.delegate?.snackbarController?(snackbarController: s, willShow: s.snackbar)
            } else {
                s.delegate?.snackbarController?(snackbarController: s, willHide: s.snackbar)
            }
            
            s.isAnimating = true
            s.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.25, animations: { [weak self, status = status, animations = animations] in
                guard let s = self else {
                    return
                }
                
                s.layoutSnackbar(status: status)
                
                animations?(s.snackbar)
            }) { [weak self, status = status, completion = completion] _ in
                guard let s = self else {
                    return
                }
                
                s.isAnimating = false
                s.isUserInteractionEnabled = true
                //s.snackbar.status = status
                s.snackbar.tag = status == SnackbarStatus.hidden ? 1 : 0
                s.layoutSubviews()
                
                if .visible == status {
                    s.delegate?.snackbarController?(snackbarController: s, didShow: s.snackbar)
                } else {
                    s.delegate?.snackbarController?(snackbarController: s, didHide: s.snackbar)
                }
                
                completion?(s.snackbar)
            }
        }
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        reload()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard !isAnimating else {
            return
        }
        
        reload()
    }
    
    /// Reloads the view.
    open func reload() {
        snackbar.x = snackbarEdgeInsets.left
        snackbar.width = view.width - snackbarEdgeInsets.left - snackbarEdgeInsets.right
        rootViewController.view.frame = view.bounds
        layoutSnackbar(status: snackbar.status)
    }
    
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
    open override func prepare() {
        super.prepare()
        prepareSnackbar()
        prepareTabBarItem()
        delegate = self
    }
    
    /// Prepares the snackbar.
    private func prepareSnackbar() {
        snackbar.zPosition = 10000
        view.addSubview(snackbar)
    }
    
    /**
     Lays out the Snackbar.
     - Parameter status: A SnackbarStatus enum value.
     */
    private func layoutSnackbar(status: SnackbarStatus) {
        if .bottom == snackbarAlignment {
            snackbar.y = 0 == snackbar.tag ? view.height - snackbar.height - snackbarEdgeInsets.bottom : view.height
        }else if .upper == snackbarAlignment {
            snackbar.y = 0 == snackbar.tag ? view.height - snackbar.height - snackbarEdgeInsets.bottom - (tabBarController?.tabBar.height)! : view.height
        } else {
            snackbar.y = 0 == snackbar.tag ? snackbarEdgeInsets.top : -snackbar.height
        }
    }
}

extension AppSnackbarController: SnackbarControllerDelegate {
    
    
    fileprivate func prepareTabBarItem(){
        tabBarItem.image = Icon.search?.tint(with: Color.blueGrey.base)
        tabBarItem.selectedImage = Icon.search?.tint(with: Color.blue.base)
        tabBarItem.title = Keys.search
    }
    
    func snackbarController(snackbarController: SnackbarController, willShow snackbar: Snackbar) {
        print("snackbarController will show")
    }
    
    func snackbarController(snackbarController: SnackbarController, willHide snackbar: Snackbar) {
        print("snackbarController will hide")
    }
    
    func snackbarController(snackbarController: SnackbarController, didShow snackbar: Snackbar) {
        print("snackbarController did show")
    }
    
    func snackbarController(snackbarController: SnackbarController, didHide snackbar: Snackbar) {
        print("snackbarController did hide")
    }
}
