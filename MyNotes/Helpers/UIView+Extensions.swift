//
//  UIView+Extensions.swift
//  MyNotes
//
//  Created by Юрий Демиденко on 13.01.2023.
//

import UIKit

extension UIView {
    
    static var identifier: String {
        return String(describing: self)
    }

    func animateAlpha(to value: CGFloat, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.alpha = value
        } completion: { _ in
            completion?()
        }
    }
}
