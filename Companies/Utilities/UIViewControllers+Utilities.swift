//
//  UIViewControllers+Utilities.swift
//  Companies
//
//  Created by Daniel Peach on 1/20/18.
//  Copyright © 2018 Daniel Peach. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupPlusButtonOnNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    // (Cancel Modal) Button Pressed
    @objc private func handleCancelModal() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLightBlueBackground(withHeight ofHeight: CGFloat) -> UIView {
        let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .backgroundPaleBlue
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: ofHeight),
            ])
        return backgroundView
    }
    
    func setupSaveButton(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: selector)
    }
}
