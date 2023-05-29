//
//  AlbumsDetailViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/29.
//

import UIKit
import SnapKit
import MusicKit
import Combine

final class AlbumsDetailViewController: UIViewController {
    
    private let viewModel: AlbumsDetailViewModel
    private var subscriptions = Set<AnyCancellable>()
    private var titleView: TitleView
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        return tableView
    }()
        
    init(album: Album) {
        self.viewModel = AlbumsDetailViewModel(album: album)
        self.titleView = TitleView(title: album.title, hasBackButton: true)
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
            await viewModel.fetchTracksByAlbum()
        }
    }
}
extension AlbumsDetailViewController {
    private func setupViews() {
        [titleView, tableView].forEach {
            view.addSubview($0)
        }
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
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
        viewModel.tracksByAlbum
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
extension AlbumsDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tracks = viewModel.tracksByAlbum.value else { return }
        let selectedTrack = tracks[indexPath.item]
        viewModel.setPlayerQueue(selectedTrackId: selectedTrack.id)
        let nowPlayingViewController = NowPlayingViewController(with: selectedTrack)
        navigationController?.pushViewController(nowPlayingViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
extension AlbumsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tracksByAlbum.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as? MenuTableViewCell
        cell?.selectionStyle = .none
        if let tracks = viewModel.tracksByAlbum.value {
            let trackName = tracks[indexPath.item].title
            cell?.updateTitle(with: trackName)
        }
        return cell ?? UITableViewCell()
    }
}
extension AlbumsDetailViewController: TitleViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
