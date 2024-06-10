//
//  ViewController.swift
//  TaskApp
//
//  Created by Nilgul Cakir on 2.06.2024.
//

import UIKit
import SnapKit

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, QRScannerDelegate {

    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let viewModel = TaskViewModel()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchTasks()
    }

    private func setupUI() {
        
        title = "VERO TASK"
        
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(scanQRCode))
        
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "Search code"
        searchBar.barTintColor = .clrGray
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(string: "Search code", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshTasks), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           view.addGestureRecognizer(tapGesture)
        
        setupConstraints()
    }

    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    private func setupBindings() {
        viewModel.onTasksUpdated = { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTasks
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let task = viewModel.task(at: indexPath.row)
        cell.configure(with: task)
        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTasks(with: searchText)
    }

    @objc private func refreshTasks() {
        viewModel.fetchTasks()
    }

    @objc private func scanQRCode() {
        let scannerVC = QRScannerVC()
        scannerVC.delegate = self
        scannerVC.onDismiss = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(scannerVC, animated: true)
    }

    func didScanQRCode(value: String) {
        searchBar.text = value
        viewModel.searchTasks(with: value)
    }
}
