//
//  ViewController.swift
//  TravelTaipei
//
//  Created by user on 2024/12/27.
//

import UIKit
import SnapKit
import Combine

class FrontPageViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AttractionViewCell.self, forCellReuseIdentifier: "AttractionViewCell")
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private let viewModel = FrontPageViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        let languageButton = UIBarButtonItem(
            title: "語言".localized,
            style: .plain,
            target: self,
            action: #selector(didTapLanguageButton)
        )
        navigationItem.rightBarButtonItem = languageButton
    }

    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.$newsList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
            .store(in: &cancellables)
        
        viewModel.$attractions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - language change
    @objc private func didTapLanguageButton() {
        let languageMenu = UIAlertController.createLanguageSelectionMenu {
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                          let window = sceneDelegate.window else { return }

            let navigationController = UINavigationController(rootViewController: FrontPageViewController())
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        
        if let popoverController = languageMenu.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(languageMenu, animated: true, completion: nil)
    }
}

extension FrontPageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            let count = viewModel.newsList.count <= 5 ? viewModel.newsList.count : 5
            return count
        } else if section == 1 {
            return viewModel.attractions.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = viewModel.cellType(for: indexPath)
        else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cellType.configure(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellType = viewModel.cellType(for: indexPath) as? AttractionCellType {
            let vc = AttractionViewController(cellModel: cellType.model)
            navigationController?.pushViewController(vc, animated: true)
        } else if let cellType = viewModel.cellType(for: indexPath) as? NewsCellType,
                  let urlString = cellType.model.urlString,
                  let url = URL(string: urlString) {
            let alert = UIAlertController.displayURLSelectionAlert { [weak self] openOption in
                switch openOption {
                case .internal:
                    let vc = WebViewController(url: url)
                    self?.navigationController?.pushViewController(vc, animated: true)
                case .external:
                    UIApplication.shared.open(url)
                }
            }
            
            present(alert, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        guard offsetY > contentHeight - height - 50 else { return }
        viewModel.attractionNextPage()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitle[section]
    }
}
