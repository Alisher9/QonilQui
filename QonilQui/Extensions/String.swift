//
//  String.swift
//  QonilQui
//
//  Created by Alisher Sattarbek on 7/15/20.
//  Copyright © 2020 AlisherSattarbek. All rights reserved.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

