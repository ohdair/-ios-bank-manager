//
//  BankTimer.swift
//  BankManagerUIApp
//
//  Created by 박재우 on 2023/03/12.
//

import UIKit

class BankTimer {
    private var timer: Timer?
    private var startTime: TimeInterval = 0
    private var previousBankingTime: TimeInterval = 0
    private var description: String {
        let elapsedTime = previousBankingTime + elapsedTime()
        let seconds = Int(elapsedTime)
        let milliseconds = Int((elapsedTime * 100).truncatingRemainder(dividingBy: 100))
        let nanoseconds = Int((elapsedTime * 1000000).truncatingRemainder(dividingBy: 1000))
        return String(format: "%02d:%02d:%03d", seconds, milliseconds, nanoseconds)
    }

    func start() {
        startTime = Date().timeIntervalSinceReferenceDate
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] _ in
                NotificationCenter.default.post(name: .bankTimer, object: nil, userInfo: ["bankTimer": self?.description as Any])
            })
        }
    }

    func pause() {
        previousBankingTime += elapsedTime()
        timer?.invalidate()
        timer = nil
    }

    func reset() {
        previousBankingTime = 0
        timer?.invalidate()
        timer = nil
    }

    func isValid() -> Bool {
        return ((timer?.isValid) != nil)
    }

    private func elapsedTime() -> TimeInterval {
        let current = Date().timeIntervalSinceReferenceDate
        return current - startTime
    }
}
