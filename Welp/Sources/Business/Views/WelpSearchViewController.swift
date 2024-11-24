//
//  WelpSearchViewController.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import Combine
import SafariServices
import UIKit
import WebKit

// MARK: - WelpSearchViewControllerDelegate

protocol WelpSearchViewControllerDelegate: AnyObject {
    func welpSearchViewController(_ viewController: WelpSearchViewController, openBusiness: Business)
}

// MARK: - WelpSearchViewController

final class WelpSearchViewController: NiblessViewController {

    @Published private var searchText: String = ""
    private var cancellables: Set<AnyCancellable> = []
    private let searchController = UISearchController(searchResultsController: nil)
    private let contentView: WelpSearchView
    private let viewModel: WelpSearchViewModel
    weak var delegate: WelpSearchViewControllerDelegate?

    init(businessRepository: BusinessRepository) {
        self.contentView = WelpSearchView(repository: businessRepository)
        self.viewModel = WelpSearchViewModel(repository: businessRepository)
        super.init()
    }

    override func loadView() {
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        wireSignals()
    }

    // MARK: Private Interface

    private func setUpView() {
        view.backgroundColor = .white
        title = String(localized: "Welp Business Search")

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = String(localized: "Search Businesses")
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func wireSignals() {
        contentView.$selectedBusiness
            .receive(on: RunLoop.main)
            .sink { [weak self] business in
                guard let self, let business else { return }
                self.presentActionSheet(for: business)
            }
            .store(in: &cancellables)

        viewModel.$businesses
            .receive(on: RunLoop.main)
            .sink { [weak self] businesses in
                guard let self, let query = searchController.searchBar.text else { return }
                self.contentView.businesses = businesses
                self.contentView.updateQuery(query)
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMessage in
                guard let self, let errorMessage else { return }
                self.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)

        $searchText
            .throttle(for: .seconds(1.0), scheduler: RunLoop.main, latest: true)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self, !query.isEmpty else { return }
                Task {
                    await self.viewModel.searchBusinesses(query: query)
                }
            }
            .store(in: &cancellables)

        contentView.$requestNextPage
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: true)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self, let query = searchController.searchBar.text, !query.isEmpty else { return }
                Task {
                    await self.viewModel.loadNextPage(query: query)
                }
            }
            .store(in: &cancellables)
    }

    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: String(localized: "Error"), message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: String(localized: "OK"), style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    private func presentActionSheet(for business: Business) {
        let alertStyle: UIAlertController.Style = UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet

        let actionSheet = UIAlertController(title: business.name, message: String(localized: "What would you like to do?"), preferredStyle: alertStyle)
        actionSheet.popoverPresentationController?.sourceView = self.view

        let closeAction = UIAlertAction(title: String(localized: "Close"), style: .cancel, handler: nil)
        let safariAction = UIAlertAction(title: String(localized: "Open in Safari"), style: .default) { _ in
            guard let url = URL(string: business.url) else { return }
            UIApplication.shared.open(url)
        }
        let webviewAction = UIAlertAction(title: String(localized: "Open in WebView"), style: .default) { [weak self] _ in
            guard let self else { return }
            self.delegate?.welpSearchViewController(self, openBusiness: business)
        }

        actionSheet.addAction(closeAction)
        actionSheet.addAction(safariAction)
        actionSheet.addAction(webviewAction)

        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - UISearchResultsUpdating

extension WelpSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else { return }
        searchText = query
    }
}

// MARK: - UISplitViewControllerDelegate

extension WelpSearchViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        .primary
    }
}
