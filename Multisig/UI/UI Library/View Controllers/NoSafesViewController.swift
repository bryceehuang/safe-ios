//
//  NoSafesViewController.swift
//  Multisig
//
//  Created by Dmitry Bespalov on 21.10.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import UIKit

class NoSafesViewController: ContainerViewController {
    var hasSafeViewController: UIViewController!
    var noSafeViewController: UIViewController!
    var safeDepolyingViewContoller: UIViewController!

    var notificationCenter = NotificationCenter.default
    // preconditions
    //      hasSafeVC and noSafeVC are set
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(reloadContent), name: .selectedSafeChanged, object: nil)
        reloadContent()
    }

    @objc private func reloadContent() {
        do {
            let safeOrNil = try Safe.getSelected()
            if let safe = safeOrNil {
                if safe.safeStatus == .deployed {
//                    viewControllers = [safeDepolyingViewContoller]
//                    displayChild(at: 0, in: view)

                    viewControllers = [hasSafeViewController]
                    displayChild(at: 0, in: view)
                } else {
                    viewControllers = [safeDepolyingViewContoller]
                    displayChild(at: 0, in: view)
                }
            } else {
                viewControllers = [noSafeViewController]
                displayChild(at: 0, in: view)
            }
        } catch {
            App.shared.snackbar.show(
                error: GSError.error(description: "Failed to check loaded safes", error: error))
        }
    }
}
