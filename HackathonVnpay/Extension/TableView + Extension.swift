//
//  TableView + Extension.swift
//  HackathonVnpay
//
//  Created by pc on 14/10/2023.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueCell<T: UITableViewCell>(_ anyClass: T.Type, at indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: String(describing: anyClass), for: indexPath) as? T
        return cell ?? T()
    }
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_ anyClass: T.Type) -> T {
        let view = dequeueReusableHeaderFooterView(withIdentifier: String(describing: anyClass)) as? T
        return view ?? T()
    }
    
    func registerCell<T: UITableViewCell>(_ anyClass: T.Type, nibType: Bool = true) {
        return nibType
            ? register(UINib(nibName: String(describing: anyClass), bundle: nil),
                       forCellReuseIdentifier: String(describing: anyClass))
            : register(anyClass, forCellReuseIdentifier: String(describing: anyClass))
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ anyClass: T.Type, nibType: Bool = true) {
        return nibType
            ? register(UINib(nibName: String(describing: anyClass), bundle: nil),
                       forHeaderFooterViewReuseIdentifier: String(describing: anyClass))
            : register(anyClass, forHeaderFooterViewReuseIdentifier: String(describing: anyClass))
    }
    
    func indicatorView() -> UIActivityIndicatorView{
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil {
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 80)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            
            if #available(iOS 13.0, *) {
                activityIndicatorView.style = .large
            } else {
                // Fallback on earlier versions
                activityIndicatorView.style = .whiteLarge
            }
            
            activityIndicatorView.color = UIColor(hexString: "#002A69")
            activityIndicatorView.hidesWhenStopped = true

            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        }
        else {
            return activityIndicatorView
        }
    }

    func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)){
        indicatorView().startAnimating()
        if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    closure()
                }
            }
        }
    }

    func stopLoading() {
        if self.tableFooterView != nil {
            self.indicatorView().stopAnimating()
            self.tableFooterView = nil
        }
        else {
            self.tableFooterView = nil
        }
    }
}

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(_ anyClass: T.Type, at indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: anyClass), for: indexPath) as? T
        return cell ?? T()
    }
    
    func registerCell<T: UICollectionViewCell>(_ anyClass: T.Type, nibType: Bool = true) {
        return nibType
            ? register(UINib(nibName: String(describing: anyClass), bundle: nil),
                       forCellWithReuseIdentifier: String(describing: anyClass))
            : register(anyClass, forCellWithReuseIdentifier: String(describing: anyClass))
    }
    
    func registerHeaderFooter<T: UICollectionReusableView>(_ anyClass: T.Type, kind: String, nibType: Bool = true) {
        return nibType
            ? register(UINib(nibName: String(describing: anyClass), bundle: nil),
                       forSupplementaryViewOfKind: kind,
                       withReuseIdentifier: String(describing: anyClass))
            : register(anyClass,
                       forSupplementaryViewOfKind: kind,
                       withReuseIdentifier: String(describing: anyClass))
    }
}
