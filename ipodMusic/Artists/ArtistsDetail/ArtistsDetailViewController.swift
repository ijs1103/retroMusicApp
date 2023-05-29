//
//  ArtistsDetailViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/26.
//

import UIKit
import SnapKit
import MusicKit
import Combine

final class ArtistsDetailViewController: UIViewController {
    
    private let viewModel: ArtistsDetailViewModel
    private var subscriptions = Set<AnyCancellable>()
    private var titleView: TitleView
    private let artistName: String
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AlbumInfoTableViewCell.self, forCellReuseIdentifier: AlbumInfoTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        return tableView
    }()
        
    init(id: String, artistName: String) {
        self.viewModel = ArtistsDetailViewModel(id: id)
        self.titleView = TitleView(title: artistName, hasBackButton: true)
        self.artistName = artistName
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
            await viewModel.fetchAlbumsByArtist()
        }
    }
}
extension ArtistsDetailViewController {
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
        viewModel.albumsByArtist
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
extension ArtistsDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let albums = viewModel.originalAlbums.value else { return }
        let album = albums[indexPath.item]
        let artistsDetailDetailVC = ArtistsDetailDetailViewController(album: album)
        navigationController?.pushViewController(artistsDetailDetailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
extension ArtistsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albumsByArtist.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumInfoTableViewCell.identifier, for: indexPath) as? AlbumInfoTableViewCell
        cell?.selectionStyle = .none
        if let albums = viewModel.albumsByArtist.value {
            let album = albums[indexPath.item]
            let albumInfo = (id: album.id, albumUrl: album.albumUrl, title: album.albumName, subTitle: artistName)
            cell?.update(with: albumInfo)
        }
        return cell ?? UITableViewCell()
    }
}
extension ArtistsDetailViewController: TitleViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
