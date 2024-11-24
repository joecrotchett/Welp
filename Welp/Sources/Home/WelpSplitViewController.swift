//
//  WelpSplitViewController.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import UIKit

// MARK: - WelpSplitViewController

final class WelpSplitViewController: UISplitViewController {

    // MARK: Depedencies

    let repository = WelpBusinessRepository(
        searchService: WelpSearchService(
            requestManager: RequestManager(
                apiManager: WelpAPIManager()
            )
        ),
        locationService: LocationManager()
    )

    // MARK: Lifecycle

    override init(style: UISplitViewController.Style) {
        super.init(style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredDisplayMode = .oneBesideSecondary

        let searchViewController = WelpSearchViewController(businessRepository: self.repository)
        searchViewController.delegate = self
        let masterNavigationController = UINavigationController(rootViewController: searchViewController)
        let detailViewController = BusinessWebViewController(business: nil)
        self.viewControllers = [masterNavigationController, detailViewController]
        self.delegate = searchViewController
    }

    // MARK: Public Interface

    func open(business: Business) {
        let vc = BusinessWebViewController(business: business)
        let navController = UINavigationController(rootViewController: vc)
        self.showDetailViewController(navController, sender: nil)
    }
}

// MARK: - WelpSearchViewControllerDelegate

extension WelpSplitViewController: WelpSearchViewControllerDelegate {
    func welpSearchViewController(_ viewController: WelpSearchViewController, openBusiness business: Business) {
        open(business: business)
    }
}
