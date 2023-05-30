//
//  TableBackgroundView.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/30.
//

import UIKit
import SnapKit

final class TableBackgroundView: UIView {
        
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()

    init(with text: String) {
        super.init(frame: .zero)
        textLabel.text = text
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TableBackgroundView {
    private func setupView() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
