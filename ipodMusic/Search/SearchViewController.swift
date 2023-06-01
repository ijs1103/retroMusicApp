//
//  SearchViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/29.
//

import UIKit
import SnapKit
import MusicKit
import Combine

final class SearchViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private let searchController = UISearchController()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchInfoTableViewCell.self, forCellReuseIdentifier: SearchInfoTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupViews()
        setupDelegates()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }
}
extension SearchViewController {
    private func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    private func setupViews() {
        [tableView].forEach {
            view.addSubview($0)
        }
        tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    private func setupDelegates() {
        searchController.searchBar.delegate = self
    }
    private func bind() {
        viewModel.searchCount
            .receive(on: RunLoop.main)
            .sink { [unowned self] searchCount in
                Spinner.hideLoading()
                // 검색결과가 없는경우
                if viewModel.searchTerm.value != "", searchCount == nil {
                    self.messageAlert(message: "검색결과가 없습니다.")
                }
                tableView.reloadData()
            }.store(in: &subscriptions)
    }
}
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            return
        case 1:
            guard let artists = viewModel.searchResults.value?.artists else { return }
            let searchResultArtistsVC = SearchResultArtistsViewController(with: artists)
            navigationController?.pushViewController(searchResultArtistsVC, animated: true)
            return
        case 2:
            guard let songs = viewModel.searchResults.value?.songs else { return }
            let searchResultSongsVC = SearchResultsSongsViewController(with: songs)
            navigationController?.pushViewController(searchResultSongsVC, animated: true)
            return
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchInfoTableViewCell.identifier, for: indexPath) as? SearchInfoTableViewCell
        cell?.selectionStyle = .none
        let searchInfo: SearchInfo
        switch indexPath.item {
        case 0:
            searchInfo = (image: UIImage(named: "search_icon")!, title: "Search", subTitle: "Results for: \(viewModel.searchTerm.value)")
            cell?.update(with: searchInfo)
        case 1:
            searchInfo = (image: UIImage(named: "artists_icon")!, title: "Artists", subTitle: "\(viewModel.searchCount.value?.artists ?? 0) artists")
            cell?.update(with: searchInfo)
        case 2:
            searchInfo = (image: UIImage(named: "song_icon")!, title: "Songs", subTitle: "\(viewModel.searchCount.value?.songs ?? 0) songs")
            cell?.update(with: searchInfo)
        default:
            break
        }
        return cell ?? UITableViewCell()
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        viewModel.didChangeSearchTerm(with: searchTerm)
        searchBar.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}
