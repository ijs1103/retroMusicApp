//
//  PlayListsDetailViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/18.
//

import UIKit
import SnapKit
import MusicKit
import Combine

final class PlayListsDetailViewController: UIViewController {
    
    private let viewModel: PlayListsDetailViewModel
    private var subscriptions = Set<AnyCancellable>()
    private var titleView: TitleView
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AlbumInfoTableViewCell.self, forCellReuseIdentifier: AlbumInfoTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        return tableView
    }()
    
    //private lazy var activityIndicator = ActivityIndicatorView()
    
    init(with playList: Playlist) {
        self.viewModel = PlayListsDetailViewModel(with: playList)
        self.titleView = TitleView(title: playList.name, hasBackButton: true)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await viewModel.fetchPlayListTracks()
        }
    }
}
extension PlayListsDetailViewController {
    private func setupViews() {
        [titleView, tableView].forEach {
            view.addSubview($0)
        }
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40.0)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    private func setupDelegates() {
        titleView.delegate = self
    }
    private func bind() {
        viewModel.playListTracks
            .receive(on: RunLoop.main)
            .sink { [unowned self] tracks in
                Spinner.hideLoading()
                guard let tracks = tracks else { return }
                if tracks.count > 0 {
                    self.tableView.backgroundView?.isHidden = true
                } else {
                    self.tableView.backgroundView?.isHidden = false
                }
                tableView.reloadData()
            }.store(in: &subscriptions)
    }
}
extension PlayListsDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 재생화면으로 이동, userDefaults에 nowPlaying으로 저장
        guard let tracks = viewModel.playListTracks.value else { return }
        let track = tracks[indexPath.item]
//        let nowPlayingViewController = NowPlayingViewController(with: track)
//        navigationController?.pushViewController(nowPlayingViewController, animated: true)
    }
}
extension PlayListsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playListTracks.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumInfoTableViewCell.identifier, for: indexPath) as? AlbumInfoTableViewCell
        cell?.selectionStyle = .none
        if let tracks = viewModel.playListTracks.value {
            let track = tracks[indexPath.item]
            cell?.update(with: track)
        }
        return cell ?? UITableViewCell()
    }
}
extension PlayListsDetailViewController: TitleViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
