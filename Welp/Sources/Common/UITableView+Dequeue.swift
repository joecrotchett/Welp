//
//  properties.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import UIKit

extension UITableView {
    /// This helper allows us to write cleaner dequeuing calls by taking advantage of Swift
    /// Generics, and our `reuseIdentifier` class properties in UITableViewCell and
    /// UITableViewHeaderFooterView, to cut out common code, and eliminate the optional
    /// returned by `dequeueReusableCell(withIdentifier:for:)`.
    /// ### The old way:
    /// `guard let cell = tableView.dequeueReusableCell(withIdentifier: BusinessCell.reuseIdentifier(), for: indexPath) as? BusinessCell else { return UITableViewCell() }`
    /// ### The new way:
    /// `let cell: BusinessCell = tableView.dequeue(for: indexPath)

    func dequeue<T : UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }

    func dequeue<T: UITableViewHeaderFooterView>() -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
    }
}

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell : ReusableView {}
extension UITableViewHeaderFooterView : ReusableView {}
