//
//  PlayingControlView.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/20.
//

import UIKit
import SnapKit

protocol PlayingControlViewDelegate: AnyObject {
    func didTapRepeatButton()
    func didTapShuffleButton()
    func didChangeTimeSlider(sender: UISlider)
}
final class PlayingControlView: UIView {
    
    weak var delegate: PlayingControlViewDelegate?
    
    private let gradientLayer = CAGradientLayer()
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = self.bounds
    }
        
    private lazy var repeatButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "repeat")
        imageView.tintColor = .white
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapRepeatButton))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    private lazy var shuffleButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "shuffle")
        imageView.tintColor = .white
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapShuffleButton))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
    private lazy var playingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    private lazy var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    private lazy var timeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        slider.maximumTrackTintColor = .white
        slider.addTarget(self, action: #selector(didChangeTimeSlider(sender:)), for: UIControl.Event.valueChanged)
        return slider
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [playingTimeLabel, timeSlider, remainingTimeLabel])
        stackView.spacing = 8.0
        stackView.axis = .horizontal
        return stackView
    }()
    init(duration: Int) {
        super.init(frame: .zero)
        setTimeLabel(playingTime: "00:00", remainingTime: duration.secondsToText())
        setupBackgroundGradient()
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlayingControlView {
    func setTimeSlider(value: Float) {
        timeSlider.setValue(value, animated: true)
    }
    func setTimeLabel(playingTime: String, remainingTime: String) {
        playingTimeLabel.text = playingTime
        remainingTimeLabel.text = remainingTime
    }
    private func setupBackgroundGradient() {
        let colorSet = [UIColor.darkGray.withAlphaComponent(0.3), UIColor.black.withAlphaComponent(0.3)]
        let location = [0.0, 1.0]
        let startEndPoints = (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
        self.addGradient(with: gradientLayer, colorSet: colorSet, locations: location, startEndPoints: startEndPoints)
    }
    private func setupView() {
        [repeatButton, shuffleButton, stackView].forEach {
            addSubview($0)
        }
        repeatButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.height.equalTo(26.0)
            $0.centerY.equalToSuperview()
        }
        shuffleButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(26.0)
            $0.centerY.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.leading.equalTo(repeatButton.snp.trailing).offset(16.0)
            $0.trailing.equalTo(shuffleButton.snp.leading).offset(-16.0)
            $0.height.equalTo(30.0)
            $0.centerY.equalToSuperview()
        }
    }
    private func toggleRepeatButtonImage() {
        switch ControlStatus.shared.repeatMode {
        case .repeatOff:
            repeatButton.tintColor = .systemBlue
            ControlStatus.shared.repeatMode = .repeatOn
        case .repeatOn:
            repeatButton.image = UIImage(systemName: "repeat.1")
            ControlStatus.shared.repeatMode = .repeatOne
        case .repeatOne:
            repeatButton.tintColor = .white
            repeatButton.image = UIImage(systemName: "repeat")
            ControlStatus.shared.repeatMode = .repeatOff
        }
    }
    private func toggleShuffleButtonImage() {
        switch ControlStatus.shared.shuffleMode {
        case .shuffleOff:
            shuffleButton.tintColor = .systemBlue
            ControlStatus.shared.shuffleMode = .shuffleOn
        case .shuffleOn:
            shuffleButton.tintColor = .white
            ControlStatus.shared.shuffleMode = .shuffleOff
        }
    }
    @objc private func didTapRepeatButton() {
        toggleRepeatButtonImage()
        delegate?.didTapRepeatButton()
    }
    @objc private func didTapShuffleButton() {
        toggleShuffleButtonImage()
        delegate?.didTapShuffleButton()
    }
    @objc private func didChangeTimeSlider(sender: UISlider) {
        delegate?.didChangeTimeSlider(sender: sender)
    }
}
