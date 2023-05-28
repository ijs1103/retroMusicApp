//
//  TitleView.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/13.
//

import UIKit
import SnapKit

protocol TitleViewDelegate: AnyObject {
    func didTapBackButton()
}

final class TitleView: UIView {
    
    weak var delegate: TitleViewDelegate?
    
    private let gradientLayer = CAGradientLayer()
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = self.bounds
    }

    private var hasBackButton: Bool
    
    private lazy var backButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.backward")
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackButton))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.textColor = .black
        return label
    }()
    private lazy var playingStatus: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.fill")
        //pause.fill
        return imageView
    }()
    private lazy var batteryStatus: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "battery_image")
        return imageView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [playingStatus, batteryStatus])
        stackView.spacing = 16.0
        stackView.axis = .horizontal
        return stackView
    }()
    init(title: String, hasBackButton: Bool) {
        self.hasBackButton = hasBackButton
        super.init(frame: .zero)
        titleLabel.text = title
        setupBackgroundGradient()
        addBottomBorder()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleView {
    private func setupBackgroundGradient() {
        let colorSet = [.white,
                        UIColor(red: 0.69, green: 0.71, blue: 0.73, alpha: 1.00)]
        let location = [0.0, 1.0]
        let startEndPoints = (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
        self.addGradient(with: gradientLayer, colorSet: colorSet, locations: location, startEndPoints: startEndPoints)
    }
    private func addBottomBorder() {
        let border = CALayer()
        border.backgroundColor = UIColor(red: 0.47, green: 0.58, blue: 0.64, alpha: 1.00).cgColor
        border.frame = CGRectMake(0, self.frame.size.height - 2.0, self.frame.size.width, 2.0)
        self.layer.addSublayer(border)
    }
    private func setupView() {
        backgroundColor = .lightGray
        [ titleLabel, stackView ].forEach {
            addSubview($0)
        }
        if hasBackButton {
            addSubview(backButton)
            backButton.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(16.0)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(30.0)
            }
        }
        titleLabel.snp.makeConstraints {
            if hasBackButton {
                $0.leading.equalTo(backButton.snp.trailing).offset(16.0)
            } else {
                $0.leading.equalToSuperview().inset(16.0)
            }
            $0.centerY.equalToSuperview()
        }
        playingStatus.snp.makeConstraints {
            $0.width.equalTo(20.0)
        }
        batteryStatus.snp.makeConstraints {
            $0.width.equalTo(40.0)
        }
        stackView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8.0)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(20.0)
            $0.centerY.equalToSuperview()
        }
    }
    @objc private func didTapBackButton() {
        delegate?.didTapBackButton()
    }
}
