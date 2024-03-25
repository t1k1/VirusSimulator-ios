//
//  UIViewController+Extensions.swift
//  VirusSimulator-ios
//
//  Created by Aleksey Kolesnikov on 25.03.2024.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround(cancelsTouchesInView: Bool = false) {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard)
        )
        tap.cancelsTouchesInView = cancelsTouchesInView
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
