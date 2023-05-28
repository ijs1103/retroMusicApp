//
//  InfoTableViewCell.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/25.
//

import SnapKit
import UIKit

final class InfoTableViewCell: UITableViewCell {
    
    static let identifier = "InfoTableViewCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()

    private lazy var disclosureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .white
        return imageView
    }()

    private let gradientLayer = CAGradientLayer()
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = self.bounds
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            let selectedBackgroundView = UIView()
            let colorSet = [UIColor(red: 0.24, green: 0.72, blue: 1.00, alpha: 1.00),
                            UIColor(red: 0.20, green: 0.48, blue: 0.71, alpha: 1.00)]
            let location = [0.0, 1.0]
            let startEndPoints = (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
            selectedBackgroundView.addGradient(with: gradientLayer, colorSet: colorSet, locations: location, startEndPoints: startEndPoints)
            self.selectedBackgroundView = selectedBackgroundView
            titleLabel.textColor = .white
        } else {
            titleLabel.textColor = .black
            self.selectedBackgroundView = .none
        }
    }
}

extension InfoTableViewCell {
    func update(with text: String) {
        setupView()
        titleLabel.text = text
    }
    private func setupView() {
        backgroundColor = .white
        [ titleLabel, disclosureImage ].forEach {
            addSubview($0)
        }

        disclosureImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.0)
            $0.width.equalTo(10.0)
            $0.height.equalTo(16.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16.0)
            $0.trailing.equalTo(disclosureImage.snp.leading).offset(-16.0)
        }
    }
}
