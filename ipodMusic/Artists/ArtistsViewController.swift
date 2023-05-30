//
//  ArtistsViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/25.
//

import UIKit
import SnapKit
import Combine

final class ArtistsViewController: UIViewController {
    
    private let viewModel = ArtistsViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var titleView = TitleView(title: "Artists", hasBackButton: true)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        let backgroundView = TableBackgroundView(with: "No saved artists")
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
extension ArtistsViewController {

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
        viewModel.artists
            .receive(on: RunLoop.main)
            .sink { [unowned self] artists in
                Spinner.hideLoading()
                guard let artists = artists else { return }
                if artists.count > 0 {
                    self.tableView.backgroundView?.isHidden = true
                } else {
                    self.tableView.backgroundView?.isHidden = false
                }
                tableView.reloadData()
            }.store(in: &subscriptions)
    }
}
extension ArtistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let artists = viewModel.artists.value else { return }
        let artistId = artists[indexPath.item].id
        let artistName = artists[indexPath.item].artistName
        let artistsDetailViewController = ArtistsDetailViewController(id: artistId, artistName: artistName)
        navigationController?.pushViewController(artistsDetailViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}
extension ArtistsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.artists.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as? MenuTableViewCell
        cell?.selectionStyle = .none
        if let artists = viewModel.artists.value {
            let artistName = artists[indexPath.item].artistName
            cell?.updateTitle(with: artistName)
        }
        return cell ?? UITableViewCell()
    }
}
extension ArtistsViewController: TitleViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
