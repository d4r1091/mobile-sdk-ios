//
//  SettingsView+Gesture.swift
//  BaseAPI
//
//  Created by Serhii Londar on 4/6/19.
//

import Foundation

extension SettingsView: UIGestureRecognizerDelegate {
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self.superview)
            guard let view = gestureRecognizer.view else { return }
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.superview)
        } else if gestureRecognizer.state == .ended {
            self.fixPositionIfNeeded()
        }
    }
}
