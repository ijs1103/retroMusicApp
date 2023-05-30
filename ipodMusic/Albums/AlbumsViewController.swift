//
//  AlbumsViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/28.
//

import UIKit
import SnapKit
import Combine

final class AlbumsViewController: UIViewController {
    
    private let viewModel = AlbumsViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var titleView = TitleView(title: "Albums", hasBackButton: true)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AlbumInfoTableViewCell.self, forCellReuseIdentifier: AlbumInfoTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        let backgroundView = TableBackgroundView(with: "No saved albums")
        tableView.backgroundView = backgroundView
        backgroundView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await viewModel.fetchArtists()
        }
    }
}
extension AlbumsViewController {

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
                guard let albums = albums else { return }
                if albums.count > 0 {
                    self.tableView.backgroundView?.isHidden = true
                } else {
                    self.tableView.backgroundView?.isHidden = false
                }
                tableView.reloadData()
            }.store(in: &subscriptions)
    }
}
extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let albums = viewModel.originalAlbums.value else { return }
        let album = albums[indexPath.item]
        let albumsDetailViewController = AlbumsDetailViewController(album: album)
        navigationController?.pushViewController(albumsDetailViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumInfoTableViewCell.identifier, for: indexPath) as? AlbumInfoTableViewCell
        cell?.selectionStyle = .none
        if let albums = viewModel.albums.value {
            let album = albums[indexPath.item]
            let albumInfo = (id: album.id, albumUrl: album.albumUrl, title: album.albumName, subTitle: album.aritstName)
            cell?.update(with: albumInfo)
        }
        return cell ?? UITableViewCell()
    }
}
extension AlbumsViewController: TitleViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
