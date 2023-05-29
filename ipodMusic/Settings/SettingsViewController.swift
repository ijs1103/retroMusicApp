//
//  SettingsViewController.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/05/15.
//

import UIKit
import SnapKit
import Combine

final class SettingsViewController: UIViewController {
    
    private let viewModel = SettingsViewModel()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var titleView = TitleView(title: "Settings", hasBackButton: true)
    
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
        viewModel.checkIsSubscribingFromDB()
    }
}
extension SettingsViewController {
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
        viewModel.isSubscribing
            .receive(on: RunLoop.main)
            .sink { [unowned self] isSubscribing in
                self.tableView.reloadData()
            }.store(in: &subscriptions)
    }
}
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            return
        case 1:
            viewModel.toggleSigninOut()
        default:
            break
        }
    }
}
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as? MenuTableViewCell
        cell?.addCustomDisclosureIndicator(with: .white)
        cell?.selectionStyle = .none
        if indexPath.item == 0 {
            cell?.updateTitle(with: "About")
        } else {
            let title = viewModel.isSubscribing.value ? "Sign out" : "Sign in"
            cell?.updateTitle(with: title)
        }
        return cell ?? UITableViewCell()
    }
}
extension SettingsViewController: TitleViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
