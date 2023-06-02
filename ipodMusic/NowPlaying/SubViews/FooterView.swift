//
//  FooterView.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/22.
//

import UIKit
import SnapKit
import MediaPlayer

protocol FooterViewDelegate: AnyObject {
    func didTapPlayPauseButton()
    func didTapPrevButton()
    func didTapNextButton()
}
final class FooterView: UIView {
    
    weak var delegate: FooterViewDelegate?
    
    private let gradientLayer = CAGradientLayer()
        
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = self.bounds
    }
    private lazy var prevButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "backward.end.alt.fill")
        imageView.tintColor = .white
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPrevButton))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    private lazy var playPauseButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pause.fill")
        imageView.tintColor = .white
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPlayPauseButton))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    private lazy var nextButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "forward.end.alt.fill")
        imageView.tintColor = .white
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapNextButton))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [prevButton, playPauseButton, nextButton])
        stackView.spacing = 32.0
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        let colorSet = [UIColor.darkGray.withAlphaComponent(0.7), UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)]
        let location = [0.0, 1.0]
        let startEndPoints = (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 0.5))
        view.addGradient(with: gradientLayer, colorSet: colorSet, locations: location, startEndPoints: startEndPoints)
        return view
    }()
    
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.5
        slider.maximumTrackTintColor = .white
        slider.addTarget(self, action: #selector(didChangeVolumeSlider(sender:)), for: UIControl.Event.valueChanged)
        return slider
    }()
        
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FooterView {
    func setPlayingStatusAndImage() {
        playPauseButton.image = UIImage(systemName: "pause.fill")
        PlayingStatus.shared.playingMode = .playing
    }
    func setStoppedStatusAndImage() {
        playPauseButton.image = UIImage(systemName: "play.fill")
        PlayingStatus.shared.playingMode = .stopped
    }
    private func setupBackgroundGradient() {
        let colorSet = [UIColor.gray, UIColor.darkGray]
        let location = [0.0, 1.0]
        let startEndPoints = (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
        self.addGradient(with: gradientLayer, colorSet: colorSet, locations: location, startEndPoints: startEndPoints)
    }
    private func setupView() {
        [topView, buttonStackView, bottomView, volumeSlider].forEach {
            addSubview($0)
        }
        prevButton.snp.makeConstraints {
            $0.width.equalTo(50.0)
            $0.height.equalTo(40.0)
        }
        playPauseButton.snp.makeConstraints {
            $0.width.equalTo(40.0)
        }
        nextButton.snp.makeConstraints {
            $0.width.equalTo(50.0)
            $0.height.equalTo(40.0)
        }
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(80.0)
        }
        buttonStackView.snp.makeConstraints {
            $0.center.equalTo(topView.snp.center)
        }
        bottomView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60.0)
        }
        volumeSlider.snp.makeConstraints {
            $0.center.equalTo(bottomView)
            $0.height.equalTo(20.0)
            $0.leading.trailing.equalToSuperview().inset(30.0)
        }
    }
    private func togglePlayPauseButtonImageAndStatus() {
        switch PlayingStatus.shared.playingMode {
        case .playing:
            playPauseButton.image = UIImage(systemName: "play.fill")
            PlayingStatus.shared.playingMode = .paused
        case .paused, .stopped:
            playPauseButton.image = UIImage(systemName: "pause.fill")
            PlayingStatus.shared.playingMode = .playing
        }
    }
    func updateVolumeSlider(volume: Float) {
        volumeSlider.value = volume
    }
    @objc private func didTapPrevButton() {
        delegate?.didTapPrevButton()
    }
    @objc private func didTapPlayPauseButton() {
        togglePlayPauseButtonImageAndStatus()
        delegate?.didTapPlayPauseButton()
    }
    @objc private func didTapNextButton() {
        delegate?.didTapNextButton()
    }
    @objc private func didChangeVolumeSlider(sender: UISlider) {
        MPVolumeView.setVolume(sender.value)
    }
}
