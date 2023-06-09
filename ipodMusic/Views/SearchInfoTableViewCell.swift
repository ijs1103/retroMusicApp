//
//  SearchInfoTableViewCell.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/29.
//

import SnapKit
import UIKit
import Kingfisher

typealias SearchInfo = (image: UIImage, title: String, subTitle: String)

final class SearchInfoTableViewCell: UITableViewCell {
    
    static let identifier = "SearchInfoTableViewCell"

    private lazy var searchImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()

    private lazy var subTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var disclosureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [title, subTitle])
        stackView.spacing = 8.0
        stackView.axis = .vertical
        return stackView
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
            title.textColor = .white
            subTitle.textColor = .white
        } else {
            title.textColor = .black
            subTitle.textColor = .darkGray
            self.selectedBackgroundView = .none
        }
    }
}

extension SearchInfoTableViewCell {
    func update(with info: SearchInfo) {
        setupView()
        searchImage.image = info.image
        title.text = info.title
        subTitle.text = info.subTitle
    }
    private func setupView() {
        backgroundColor = .white
        [ searchImage, disclosureImage, stackView ].forEach {
            addSubview($0)
        }
                
        searchImage.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(60.0)
        }
        
        disclosureImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.0)
            $0.width.equalTo(10.0)
            $0.height.equalTo(16.0)
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(searchImage.snp.trailing).offset(8.0)
            $0.trailing.equalTo(disclosureImage.snp.leading).offset(-16.0)
        }
        
    }
}
