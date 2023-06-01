//
//  SearchResultsSongsViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/06/01.
//

import UIKit
import SnapKit
import MusicKit
import Combine

final class SearchResultsSongsViewController: UIViewController {
    
    private let viewModel: SearchResultsSongsViewModel
    private var subscriptions = Set<AnyCancellable>()
    private var titleView = TitleView(title: "Songs", hasBackButton: true)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AlbumInfoTableViewCell.self, forCellReuseIdentifier: AlbumInfoTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        return tableView
    }()
    
    init(with data: [AlbumsDatum]) {
        self.viewModel = SearchResultsSongsViewModel(with: data)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
    }
}
extension SearchResultsSongsViewController {
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
}
extension SearchResultsSongsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = viewModel.songs[indexPath.item]
        viewModel.setPlayerQueue(selectedTrackId: song.id)
        let nowPlayingViewController = NowPlayingViewController(with: song)
        navigationController?.pushViewController(nowPlayingViewController, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
extension SearchResultsSongsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumInfoTableViewCell.identifier, for: indexPath) as? AlbumInfoTableViewCell
        cell?.selectionStyle = .none
        let song = viewModel.songs[indexPath.item]
        let songInfo = (id: song.id, albumUrl: song.albumUrl, title: song.title, subTitle: song.subTitle)
        cell?.update(with: songInfo)
        return cell ?? UITableViewCell()
    }
}
extension SearchResultsSongsViewController: TitleViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
