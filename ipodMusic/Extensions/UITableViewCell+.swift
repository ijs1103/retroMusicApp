//
//  UITableViewCell+.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/14.
//

import UIKit
import SnapKit

extension UITableViewCell {
    func addCustomDisclosureIndicator(with color: UIColor) {
        let disclosureImage = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        let width = (disclosureImage?.size.width) ?? 10.0
        let height = (disclosureImage?.size.height) ?? 16.0
        let accessoryImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        accessoryImageView.contentMode = .scaleAspectFit
        accessoryImageView.image = disclosureImage
        accessoryImageView.tintColor = color
        accessoryView = accessoryImageView
    }
}
