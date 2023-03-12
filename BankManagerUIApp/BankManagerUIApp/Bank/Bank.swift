//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by 박재우 on 2023/02/23.
//

import Foundation

enum BankState: String {
    case open = "1"
    case close = "2"
}

class Bank {
    private var clientsPerDay = 0
    private let bankQueue = BankQueue()
    private let bankTimer = BankTimer()
    private let bankTeller: [Teller] = {
        var tellers: [Teller] = []
        Constants.tellerStaffing.forEach { (bankingType, tellerCount) in
            for _ in 1...tellerCount {
                let teller = Teller.init(type: bankingType)
                tellers.append(teller)
            }
        }
        return tellers
    }()

    func assignBanking() {
        if !bankTimer.isValid() {
            bankTimer.start()
        }
        bankTeller.forEach { teller in
            serveClient(teller)
        }
    }

    private func serveClient(_ teller: Teller) {
        guard teller.workState == .resting else { return }
        teller.workState = .working
        DispatchQueue.global().async() { [self] in
            let queue = bankQueue.get(of: teller.type)
            let semaphore = bankQueue.semaphore(for: teller.type)

            while !queue.isEmpty() {
                semaphore.wait()
                guard let client = queue.dequeue() else {
                    teller.workState = .resting
                    semaphore.signal()
                    return
                }
                NotificationCenter.default.post(name: .bankingClient, object: nil, userInfo: ["client": client])
                semaphore.signal()
                teller.assist(client)
                NotificationCenter.default.post(name: .finishedBankingClient, object: nil, userInfo: ["client": client])
            }
            teller.workState = .resting
            if isRestAllofTeller() {
                bankTimer.pause()
            }
        }
    }

    private func isRestAllofTeller() -> Bool {
        var bool = true
        bankTeller.forEach { teller in
            bool = (teller.workState == .resting) && bool
        }
        return bool
    }

    func enqueueClients() {
        for waitingNumber in clientsPerDay + 1...clientsPerDay + Constants.tenOfClients {
            let client = Client(waitingNumber: waitingNumber)
            let queue = bankQueue.get(of: client.type)
            NotificationCenter.default.post(name: .addClient, object: nil, userInfo: ["client": client])
            queue.enqueue(client)
            clientsPerDay += 1
        }
    }

    func reset() {
        BankingType.allCases.forEach { type in
            let queue = bankQueue.get(of: type)
            queue.clear()
        }
        clientsPerDay = 0
        bankTimer.reset()
    }
}

private extension Date {
    func now() -> Double {
        return Double(self.timeIntervalSince1970)
    }

    func takenTime(from openTime: Double) -> Double {
        let takenTime = Double(self.timeIntervalSince1970) - openTime
        return takenTime.floor()
    }
}

private extension Double {
    func floor() -> Double {
        var tmp = self * 10
        tmp.round(.down)
        return tmp / 10
    }
}
