//
//  UIViewController+Extensions.swift
//  MyNotes
//
//  Created by Юрий Демиденко on 01.04.2023.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardByTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
