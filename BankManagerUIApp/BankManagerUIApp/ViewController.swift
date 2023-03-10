//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    // MARK: 타이머 변수선언
    let timerLabel = UILabel()
        var startTime: TimeInterval = 0
        var timer: Timer?

    private let customView = CustomView()
    private let bank = Bank()

    override func viewDidLoad() {
        
        // MARK: 타이머
        view.addSubview(timerLabel)
        startTime = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] _ in
            self?.updateTimerLabel()
        })
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        timerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        timerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        
        
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
    }
    
    // MARK: 타이머 관련 메서드
    func updateTimerLabel() {
        let currentTime = Date().timeIntervalSinceReferenceDate
        let elapsedTime = currentTime - startTime
        let seconds = Int(elapsedTime)
        let milliseconds = Int((elapsedTime * 100).truncatingRemainder(dividingBy: 100))
        let nanoseconds = Int((elapsedTime * 1000000).truncatingRemainder(dividingBy: 1000))
        let elapsedTimeText = String(format: "%02d:%02d:%03d", seconds, milliseconds, nanoseconds)
        timerLabel.text = elapsedTimeText
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
}
