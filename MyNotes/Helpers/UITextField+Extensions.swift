//
//  UITextField+Extensions.swift
//  MyNotes
//
//  Created by Юрий Демиденко on 01.04.2023.
//

import UIKit

extension UITextField {

    func makeIndent(points: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: points, height: self.frame.height))
        self.leftViewMode = .always
    }
}
