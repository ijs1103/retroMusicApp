//
//  MusicViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/16.
//

import UIKit
import SnapKit
import Combine

enum MusicMenu: CaseIterable {
    case coverflow, playlists, artists, albums, search
    var title: String {
        switch self {
        case .coverflow:
            return "Cover Flow"
        case .playlists:
            return "Playlists"
        case .artists:
            return "Artists"
        case .albums:
            return "Albums"
        case .search:
            return "Search"
        }
    }
}

final class MusicViewController: UIViewController {
    
    //private let viewModel = MusicViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var titleView = TitleView(title: "Music", hasBackButton: true)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
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
        setupNavigation()
    }
}
extension MusicViewController {
    private func setupNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
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
//        viewModel.isSubscribing
//            .receive(on: RunLoop.main)
//            .sink { [unowned self] isSubscribing in
//                if !isSubscribing {
//                    self.messageAlert(message: "Apple Music을 구독해주세요.")
//                }
//            }.store(in: &subscriptions)
    }
}
extension MusicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            return
        case 1:
            let playListsViewController = PlayListsViewController()
            navigationController?.pushViewController(playListsViewController, animated: true)
            return
        case 2:
            let artistsViewController = ArtistsViewController()
            navigationController?.pushViewController(artistsViewController, animated: true)
            return
        case 3:
            let albumsViewController = AlbumsViewController()
            navigationController?.pushViewController(albumsViewController, animated: true)
            return
        case 4:
            let searchViewController = SearchViewController()
            navigationController?.pushViewController(searchViewController, animated: true)
            return
        default:
            break
        }
    }
}
extension MusicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MusicMenu.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as? MenuTableViewCell
        cell?.addCustomDisclosureIndicator(with: .white)
        cell?.selectionStyle = .none
        cell?.updateTitle(with: MusicMenu.allCases[indexPath.item].title)
        return cell ?? UITableViewCell()
    }
}
extension MusicViewController: TitleViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
