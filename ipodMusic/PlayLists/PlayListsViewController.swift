//
//  PlayListsViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/16.
//

import UIKit
import SnapKit
import Combine

final class PlayListsViewController: UIViewController {
    
    private let viewModel = PlayListsViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var titleView = TitleView(title: "PlayLists", hasBackButton: true)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AlbumInfoTableViewCell.self, forCellReuseIdentifier: AlbumInfoTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        let backgroundView = MenuTableBackgroundView()
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
            await viewModel.fetchPlayLists()
        }
    }
}
extension PlayListsViewController {

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
        viewModel.playLists
            .receive(on: RunLoop.main)
            .sink { [unowned self] playlists in
                Spinner.hideLoading()
                guard let playlists = playlists else { return }
                if playlists.count > 0 {
                    self.tableView.backgroundView?.isHidden = true
                } else {
                    self.tableView.backgroundView?.isHidden = false
                }
                tableView.reloadData()
            }.store(in: &subscriptions)
    }
}
extension PlayListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let playLists = viewModel.originalPlayLists.value else { return }
        let playList = playLists[indexPath.item]
        let playListsDetailViewController = PlayListsDetailViewController(with: playList)
        navigationController?.pushViewController(playListsDetailViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
extension PlayListsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playLists.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumInfoTableViewCell.identifier, for: indexPath) as? AlbumInfoTableViewCell
        cell?.selectionStyle = .none
        if let playLists = viewModel.playLists.value {
            let playList = playLists[indexPath.item]
            cell?.update(with: playList)
        }
        return cell ?? UITableViewCell()
    }
}
extension PlayListsViewController: TitleViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
