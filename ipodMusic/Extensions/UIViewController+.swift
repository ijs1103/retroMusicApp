//
//  UIViewController+.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/16.
//

import UIKit

extension UIViewController {
    func messageAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
