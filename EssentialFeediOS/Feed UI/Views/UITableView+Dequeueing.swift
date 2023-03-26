//
//  UITableView+Extension.swift
//  EssentialFeediOS
//
//  Created by Fatih Sağlam on 26.03.2023.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
