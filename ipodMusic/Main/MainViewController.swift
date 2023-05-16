//
//  MainViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/15.
//

import UIKit
import SnapKit
import Combine

enum MainMenu: CaseIterable {
    case music, settings, nowPlaying
    var title: String {
        switch self {
        case .music:
            return "Music"
        case .settings:
            return "Settings"
        case .nowPlaying:
            return "Now Playing"
        }
    }
}

final class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var titleView = TitleView(title: "iPod", hasBackButton: false)
    
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
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        viewModel.checkIsSubscribingFromDB()
    }
}
extension MainViewController {
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
            $0.height.equalTo(40.0)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func bind() {
        viewModel.isSubscribing
            .receive(on: RunLoop.main)
            .sink { [unowned self] isSubscribing in
                if !isSubscribing {
                    self.messageAlert(message: "Apple Music을 구독해주세요.")
                }
            }.store(in: &subscriptions)
    }
}
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
//            if !viewModel.isSubscribing.value {
//                return
//            }
            let musicViewController = MusicViewController()
            navigationController?.pushViewController(musicViewController, animated: true)
        case 1:
            let settingsViewController = SettingsViewController()
            navigationController?.pushViewController(settingsViewController, animated: true)
        case 2:
            if !viewModel.isSubscribing.value {
                return
            }
        default:
            break
        }
    }
}
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainMenu.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as? MenuTableViewCell
        cell?.addCustomDisclosureIndicator(with: .white)
        cell?.selectionStyle = .none
        cell?.updateTitle(with: MainMenu.allCases[indexPath.item].title)
        return cell ?? UITableViewCell()
    }
}
