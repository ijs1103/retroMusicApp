//
//  MenuTableViewCell.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/14.
//

import UIKit
import SnapKit

protocol MenuTableViewCellDelegate: AnyObject {
    func didTapMenuTableViewCell()
}

final class MenuTableViewCell: UITableViewCell {
    
    static let identifier = "MenuTableViewCell"
    
    weak var delegate: MenuTableViewCellDelegate?
    
    private let gradientLayer = CAGradientLayer()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()
    
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
    
    func updateTitle(with title: String) {
        setupView()
        titleLabel.text = title
    }
    
}

extension MenuTableViewCell {
    private func setupView() {
        backgroundColor = .white
        [ titleLabel ].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
        }
    }
    
    @objc private func didTapMenuTableViewCell() {
        delegate?.didTapMenuTableViewCell()
    }
}
