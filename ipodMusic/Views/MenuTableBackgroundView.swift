//
//  MenuTableBackgroundView.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/18.
//

import UIKit
import SnapKit

final class MenuTableBackgroundView: UIView {
        
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "No saved playlists"
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MenuTableBackgroundView {
    private func setupView() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
