//
//  SearchResultArtistsDetailDetailViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/31.
//

import UIKit
import SnapKit
import MusicKit
import Combine

final class SearchResultArtistsDetailDetailViewController: UIViewController {
    
    private let viewModel: SearchResultArtistsDetailDetailViewModel
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
        
    init(albumId: String, albumName: String, originalAlbum: Album) {
        self.viewModel = SearchResultArtistsDetailDetailViewModel(albumId: albumId, originalAlbum: originalAlbum)
        self.titleView = TitleView(title: albumName, hasBackButton: true)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
        Task {
            await viewModel.fetchTracks()
        }
        bind()
    }
}
extension SearchResultArtistsDetailDetailViewController {
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
        viewModel.tracks
            .receive(on: RunLoop.main)
            .sink { [unowned self] tracks in
                Spinner.hideLoading()
                guard tracks != nil  else { return }
                tableView.reloadData()
            }.store(in: &subscriptions)
    }
}
extension SearchResultArtistsDetailDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tracks = viewModel.tracks.value else { return }
        let selectedTrack = tracks[indexPath.item]
        viewModel.setPlayerQueue(selectedTrackId: selectedTrack.id)
        let nowPlayingViewController = NowPlayingViewController(with: selectedTrack)
        navigationController?.pushViewController(nowPlayingViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
extension SearchResultArtistsDetailDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tracks.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as? MenuTableViewCell
        cell?.selectionStyle = .none
        if let tracks = viewModel.tracks.value {
            let trackName = tracks[indexPath.item].title
            cell?.updateTitle(with: trackName)
        }
        return cell ?? UITableViewCell()
    }
}
extension SearchResultArtistsDetailDetailViewController: TitleViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
