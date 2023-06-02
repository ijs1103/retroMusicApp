//
//  NowPlayingViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/19.
//

import UIKit
import SnapKit
import MusicKit
import Combine
import Kingfisher
import AVFAudio
import MediaPlayer

enum TimerStatus {
    case suspended, canceled, resumed
}

final class NowPlayingViewController: UIViewController {
    private var viewModel: NowPlayingViewModel
    private var subscriptions = Set<AnyCancellable>()
    private var timer: DispatchSourceTimer?
    private var timerStatus: TimerStatus = .resumed
    private var header: HeaderView
    private var playingControl: PlayingControlView
    private lazy var footer = FooterView()
    private lazy var albumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAlbumImage))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    init(with playList: ParsedPlayList) {
        self.viewModel = NowPlayingViewModel(with: playList)
        self.header = HeaderView(songName: playList.title, artistName: playList.subTitle, albumName: playList.albumTitle ?? "앨범미상")
        self.playingControl = PlayingControlView(duration: playList.duration!)
        super.init(nibName: nil, bundle: nil)
        self.albumImage.kf.setImage(with: playList.albumUrl, placeholder: UIImage(named: "albums_icon"))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
        setupPlaying()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupVolume()
    }
    deinit {
        stopTimer()
    }
}
extension NowPlayingViewController {
    func updateUI(with track: ParsedPlayList){
        viewModel.updatePlayList(with: track)
        header.updateNames(songName: track.title, artistName: track.subTitle, albumName: track.albumTitle ?? "앨범미상")
        playingControl.setTimeLabel(playingTime: "00:00", remainingTime: track.duration!.secondsToText())
        playingControl.setTimeSlider(value: 0.0)
        footer.setPlayingStatusAndImage()
        albumImage.image = track.albumImage ?? UIImage(named: "albums_icon")
    }
    private func setupViews() {
        [header, albumImage, footer, playingControl].forEach {
            view.addSubview($0)
        }
        header.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80.0)
        }
        albumImage.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(60.0)
            $0.leading.trailing.equalToSuperview()
        }
        footer.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(140.0)
        }
        
        playingControl.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60.0)
        }
    }
    private func setupDelegates() {
        header.delegate = self
        footer.delegate = self
        playingControl.delegate = self
    }
    private func setupPlaying() {
        Task {
            await viewModel.play()
        }
        startTimer()
        PlayingStatus.shared.playingMode = .playing
    }
    private func setupVolume() {
        footer.updateVolumeSlider(volume: AVAudioSession.sharedInstance().outputVolume)
    }
    @objc private func didTapAlbumImage() {
        playingControl.isHidden.toggle()
    }
    private func startTimer() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        timer?.schedule(deadline: .now(), repeating: 1)
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.timerStatus = .resumed
            self.viewModel.currentSeconds += 1
            self.playingControl.setTimeSlider(value: Float(self.viewModel.currentSeconds) / Float(self.viewModel.duration))
            let playingTime = self.viewModel.currentSeconds.secondsToText()
            let remainingTime = (self.viewModel.duration - self.viewModel.currentSeconds).secondsToText()
            self.playingControl.setTimeLabel(playingTime: playingTime, remainingTime: remainingTime)
            // 음원이 끝까지 재생되면
            if self.viewModel.currentSeconds >= self.viewModel.duration {
                self.stopTimer()
                // 한곡 반복 모드일때 현재곡으로 다시 UI 업데이트
                if ControlStatus.shared.repeatMode == .repeatOne {
                    self.viewModel.currentSeconds = 0
                    self.playingControl.setTimeSlider(value: 0.0)
                    self.playingControl.setTimeLabel(playingTime: "00:00", remainingTime: self.viewModel.duration.secondsToText())
                    self.startTimer()
                    return
                }
                // 재생할곡이 queue에 남아있으면 다음곡으로 UI 업데이트
                if self.viewModel.isRemainingSongsInQueue() {
                    self.viewModel.playNextSong()
                    guard let nextTrack = self.viewModel.getTrack() else { return }
                    self.updateUI(with: nextTrack)
                    self.startTimer()
                    return
                }
                
                if ControlStatus.shared.repeatMode == .repeatOff {
                    self.initPlayerUI()
                }
            }
        }
        timer?.resume()
    }
    private func stopTimer() {
        if timerStatus == .suspended {
            timer?.resume()
        }
        timer?.cancel()
    }
    // 플레이 타임, 슬라이더바, 그리고 시작버튼을 초기화
    private func initPlayerUI() {
        playingControl.setTimeSlider(value: 0.0)
        let playingTime = "00:00"
        let remainingTime = self.viewModel.duration.secondsToText()
        playingControl.setTimeLabel(playingTime: playingTime, remainingTime: remainingTime)
        footer.setStoppedStatusAndImage()
    }
    func setTimeLabel(currentSeconds: Int, playingTime: String, remainingTime: String) {
        viewModel.currentSeconds = currentSeconds
        playingControl.setTimeLabel(playingTime: playingTime, remainingTime: remainingTime)
    }
}
extension NowPlayingViewController: HeaderViewDelegate {
    func didTapBackButton() {
        viewModel.setNowPlayingState()
        navigationController?.popViewController(animated: true)
    }
}
extension NowPlayingViewController: FooterViewDelegate {
    func didTapPlayPauseButton() {
        switch PlayingStatus.shared.playingMode {
        case .stopped:
            // 타이머 종료
            stopTimer()
        case .playing:
            // 음원 및 타이머 시작
            timer?.resume()
            Task {
                await viewModel.play()
            }
            timerStatus = .resumed
        case .paused:
            // 음원 및 타이머 정지
            timer?.suspend()
            viewModel.pause()
            timerStatus = .suspended
        }
    }
    func didTapPrevButton() {
        if viewModel.isSongEmpty() { return }
        viewModel.playPrevSong()
        guard let prevTrack = viewModel.getTrack() else { return }
        updateUI(with: prevTrack)
        stopTimer()
        Task {
            await viewModel.play()
        }
        startTimer()
    }
    func didTapNextButton() {
        if viewModel.isSongEmpty() { return }
        viewModel.playNextSong()
        guard let nextTrack = viewModel.getTrack() else { return }
        updateUI(with: nextTrack)
        stopTimer()
        Task {
            await viewModel.play()
        }
        startTimer()
    }
}
extension NowPlayingViewController: PlayingControlViewDelegate {
    func didTapRepeatButton() {
        viewModel.setRepeatMode()
    }
    func didTapShuffleButton() {
        viewModel.setShuffleMode()
    }
    func didChangeTimeSlider(sender: UISlider) {
        if timerStatus == .resumed {
            timer?.suspend()
        }
        let playingSeconds = Int((sender.value * Float(viewModel.duration)))
        let playingTime = playingSeconds.secondsToText()
        let remainingTime = (viewModel.duration - playingSeconds).secondsToText()
        playingControl.setTimeLabel(playingTime: playingTime, remainingTime: remainingTime)
        viewModel.currentSeconds = playingSeconds
        // playbackTime 변경
        viewModel.changePlaybackTime(seconds: playingSeconds)
        if timerStatus == .resumed {
            timer?.resume()
        }
    }
}
