//
//  SearchResultArtistsViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/30.
//

import UIKit
import SnapKit
import MusicKit
import Combine

final class SearchResultArtistsViewController: UIViewController {

    private let viewModel: SearchResultArtistsViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var titleView = TitleView(title: "Artists", hasBackButton: true)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        return tableView
    }()
    
    init(with data: [ArtistsDatum]) {
        self.viewModel = SearchResultArtistsViewModel(with: data)
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
extension SearchResultArtistsViewController {
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
extension SearchResultArtistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.parsedData[indexPath.item]
        let searchResultArtistsDetailVC = SearchResultArtistsDetailViewController(with: data)
        navigationController?.pushViewController(searchResultArtistsDetailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}

extension SearchResultArtistsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.parsedData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as? MenuTableViewCell
        cell?.selectionStyle = .none
        let artistName = viewModel.parsedData[indexPath.item].artistName
        cell?.updateTitle(with: artistName)
        return cell ?? UITableViewCell()
    }
}
    
extension SearchResultArtistsViewController: TitleViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
