//
//  WelpSearchView.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import UIKit
import Combine

final class WelpSearchView: NiblessView {

    private enum ViewConstants {
        static let labelPadding = 16.0
    }

    // MARK: Views

    private let resultsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(BusinessCell.self, forCellReuseIdentifier: BusinessCell.reuseIdentifier)
        return tableView
    }()

    // MARK: Dependencies

    private let repository: BusinessRepository

    // MARK: Public Interface

    @Published private(set) var selectedBusiness: Business? = nil
    @Published private(set) var requestNextPage: Void = ()

    var businesses: [Business] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    init(repository: BusinessRepository) {
        self.repository = repository
        super.init(frame: .zero)
        self.setUpView()
        self.setUpLayout()
    }

    func updateQuery(_ query: String) {
        guard !query.isEmpty else { return }
        resultsLabel.text = String(localized:"Showing search results for \"\(query)\"")
    }

    // MARK: - Private Interface

    private func setUpView() {
        tableView.dataSource = self
        tableView.delegate = self

        addSubview(resultsLabel)
        addSubview(tableView)
    }

    private func setUpLayout() {
        resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            resultsLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: ViewConstants.labelPadding),
            resultsLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: ViewConstants.labelPadding),
            resultsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewConstants.labelPadding),

            tableView.topAnchor.constraint(equalTo: resultsLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension WelpSearchView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        businesses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BusinessCell = tableView.dequeue(for: indexPath)
        let business = businesses[indexPath.row]
        cell.configure(with: business, indexPath: indexPath, repository: repository)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension WelpSearchView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedBusiness = businesses[indexPath.row]
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 2 {
            requestNextPage = ()
        }
    }
}
