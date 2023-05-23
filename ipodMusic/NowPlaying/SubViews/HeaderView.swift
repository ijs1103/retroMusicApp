//
//  HeaderView.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/19.
//

import UIKit
import SnapKit

protocol HeaderViewDelegate: AnyObject {
    func didTapBackButton()
}
final class HeaderView: UIView {
    
    weak var delegate: HeaderViewDelegate?
    
    private let gradientLayer = CAGradientLayer()
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = self.bounds
    }
    
    private lazy var backButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backbutton_image")
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackButton))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    private lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.textColor = .white
        return label
    }()
    private lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [songNameLabel, artistNameLabel, albumNameLabel])
        stackView.spacing = 2.0
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    init(songName: String, artistName: String, albumName: String) {
        super.init(frame: .zero)
        songNameLabel.text = songName
        artistNameLabel.text = artistName
        albumNameLabel.text = albumName
        setupBackgroundGradient()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeaderView {
    func updateNames(songName: String, artistName: String, albumName: String) {
        songNameLabel.text = songName
        artistNameLabel.text = artistName
        albumNameLabel.text = albumName
    }
    private func setupBackgroundGradient() {
        let colorSet = [UIColor.gray, UIColor.black]
        let location = [0.0, 1.0]
        let startEndPoints = (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 0.6))
        self.addGradient(with: gradientLayer, colorSet: colorSet, locations: location, startEndPoints: startEndPoints)
    }
    private func setupView() {
        [ backButton, stackView ].forEach {
            addSubview($0)
        }
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(36.0)
            $0.width.equalTo(40.0)
        }
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    @objc private func didTapBackButton() {
        delegate?.didTapBackButton()
    }
}
