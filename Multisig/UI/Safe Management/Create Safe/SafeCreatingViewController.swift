//
//  SafeCreatingViewController.swift
//  Multisig
//
//  Created by Mouaz on 6/21/23.
//  Copyright © 2023 Gnosis Ltd. All rights reserved.
//

import UIKit
import Lottie

class SafeCreatingViewController: UIViewController {

    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoView3: InfoView!
    @IBOutlet weak var infoView2: InfoView!
    @IBOutlet weak var infoView1: InfoView!

    override func viewDidLoad() {
        super.viewDidLoad()

        infoView1.set(text: "Creating an owner key for your Safe Account...", background: .clear, status: .loading)
        infoView2.set(text: "Securing it with your social login...", background: .clear, status: .loading)
        infoView3.set(text: "Creating your Safe Account...", background: .clear, status: .loading)
        titleLabel.setStyle(.title1)
        descriptionLabel.setStyle(.body)
        animationView.animation = LottieAnimation.named(isDarkMode ? "safeCreationDark" : "safeCreation",
                                                  animationCache: nil)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(accountCreated),
                                               name: .safeAccountOwnerCreated,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(accountSecured),
                                               name: .safeAccountOwnerSecured,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(safeCreated),
                                               name: .safeCreationUpdate,
                                               object: nil)

        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {_ in
            NotificationCenter.default.post(name: .safeAccountOwnerCreated, object: nil)
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {_ in
                NotificationCenter.default.post(name: .safeAccountOwnerSecured, object: nil)
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {_ in
                    NotificationCenter.default.post(name: .safeCreationUpdate, object: nil)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc func accountCreated() {
        infoView1.set(status: .success)
    }

    @objc func accountSecured() {
        infoView2.set(status: .success)
    }

    @objc func safeCreated() {
        infoView3.set(status: .success)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] timer in
            let view = SafeCreationSuccessViewController()
            self?.show(view, sender: self)
        }
    }
}

extension Notification.Name {
    static let safeAccountOwnerCreated = NSNotification.Name("io.gnosis.safe.safeAccountOwnerCreated")
    static let safeAccountOwnerSecured = NSNotification.Name("io.gnosis.safe.safeAccountOwner")
}
