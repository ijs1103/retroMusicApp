//
//  SearchResultArtistsDetailViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/30.
//

import UIKit
import SnapKit
import MusicKit
import Combine

final class SearchResultArtistsDetailViewController: UIViewController {
    
    private let viewModel: SearchResultArtistsDetailViewModel
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
        
    init(with data: SearchResultAritstDataType) {
        self.viewModel = SearchResultArtistsDetailViewModel(with: data)
        self.titleView = TitleView(title: data.artistName, hasBackButton: true)
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
            await viewModel.fetchAlbumsByArtist()
        }
        bind()
    }
}
extension SearchResultArtistsDetailViewController {
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
        viewModel.albums
            .receive(on: RunLoop.main)
            .sink { [unowned self] albums in
                Spinner.hideLoading()
                guard (albums != nil) else { return }
                tableView.reloadData()
            }.store(in: &subscriptions)
    }
}
extension SearchResultArtistsDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let albums = viewModel.albums.value, let originalAlbums = viewModel.originalAlbums.value else { return }
        let albumId = albums[indexPath.item].id
        let albumName = albums[indexPath.item].albumName
        let originalAlbum = originalAlbums[indexPath.item]
        let searchResultDetailDetailVC = SearchResultArtistsDetailDetailViewController(albumId: albumId, albumName: albumName, originalAlbum: originalAlbum)
        navigationController?.pushViewController(searchResultDetailDetailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
extension SearchResultArtistsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumInfoTableViewCell.identifier, for: indexPath) as? AlbumInfoTableViewCell
        cell?.selectionStyle = .none
        if let albums = viewModel.albums.value {
            let album = albums[indexPath.item]
            let albumInfo = (id: album.id, albumUrl: album.albumUrl, title: album.albumName, subTitle: album.artistName)
            cell?.update(with: albumInfo)
        }
        return cell ?? UITableViewCell()
    }
}
extension SearchResultArtistsDetailViewController: TitleViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
