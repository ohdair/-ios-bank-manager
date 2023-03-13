//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    private let customView = CustomView()
    private let bank = Bank()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(customView.addClientButton)
        view.addSubview(customView.resetButton)
        view.addSubview(customView.timerLabel)
        view.addSubview(customView.waitingLabel)
        view.addSubview(customView.bankingLabel)
        view.addSubview(customView.waitingScrollView)
        view.addSubview(customView.bankingScrollView)

        customView.waitingScrollView.addSubview(customView.waitingStackView)
        customView.bankingScrollView.addSubview(customView.bankingStackView)

        customView.addClientButton.addTarget(self, action: #selector(addClients), for: .touchUpInside)
        customView.resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)

        customView.activeConstraint()

        NotificationCenter.default.addObserver(self, selector: #selector(makeWaitClient), name: .addClient, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(serveBankingClient), name: .bankingClient, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishBankingClient), name: .finishedBankingClient, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimerLabel), name: .bankTimer, object: nil)
    }
    
    @objc func updateTimerLabel(_ notification: Notification) {
        guard let bankTimer = notification.userInfo?["bankTimer"] as? String else {
            return
        }
        customView.timerLabel.text = "업무 시간 - \(bankTimer)"
    }

    @objc func makeWaitClient(_ notification: Notification) {
        guard let client = notification.userInfo?["client"] as? Client else {
            return
        }
        customView.waitingStackView.addArrangedSubview(makeLabel())

        func makeLabel() -> UILabel {
            let label = UILabel()
            label.tag = client.waitingNumber
            label.text = "\(client.waitingNumber) - \(client.type.description)"
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            label.textColor = colorOfType(client.type)
            return label
        }

        func colorOfType(_ type: BankingType) -> UIColor {
            guard type == .loan else { return .black }
            return UIColor(red: 164 / 255, green: 84 / 255, blue: 214 / 255, alpha: 1.0)
        }
    }

    @objc func serveBankingClient(_ notification: Notification) {
        guard let client = notification.userInfo?["client"] as? Client else {
            return
        }
        DispatchQueue.main.async {
            if let waitedClient = self.customView.waitingStackView.subviews.first(where: { $0.tag == client.waitingNumber }) {
                self.customView.bankingStackView.addArrangedSubview(waitedClient)
            }
        }
    }

    @objc func finishBankingClient(_ notification: Notification) {
        guard let client = notification.userInfo?["client"] as? Client else {
            return
        }
        DispatchQueue.main.async {
            if let bankingClient = self.customView.bankingStackView.subviews.first(where: { $0.tag == client.waitingNumber }) {
                bankingClient.removeFromSuperview()
            }
        }
    }

    @objc func addClients() {
        bank.enqueueClients()
        bank.assignBanking()
    }

    @objc func reset() {
        customView.waitingStackView.removeAllSubviews()
        customView.bankingStackView.removeAllSubviews()
        bank.reset()
        customView.timerLabel.text = "업무 시간 - 00:00:000"
    }
}

private extension UIView {
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}

extension Notification.Name {
    static let addClient = Notification.Name("addClient")
    static let bankingClient = Notification.Name("bankingClient")
    static let finishedBankingClient = Notification.Name("finishedBankingClient")
    static let bankTimer = Notification.Name("bankTimer")
}
