//
//  UINavigationController+Extensions.swift
//  MyNotes
//
//  Created by Юрий Демиденко on 02.04.2023.
//

import UIKit

extension UINavigationController {
    
    func popViewControllerWithHandler(animated: Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
}
