//
//  ViewControllerExtension.swift
//  QonilQui
//
//  Created by Alisher Sattarbek on 7/15/20.
//  Copyright © 2020 AlisherSattarbek. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

