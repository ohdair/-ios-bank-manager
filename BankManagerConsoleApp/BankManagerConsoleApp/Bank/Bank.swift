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

struct Bank: ConsoleMessagable {
    private let queue = Queue<Int>()
    private let teller = Teller()
    private static var customersPerDay = 0

    func execute() {
        printMessage(message: .startBanking)
        do {
            switch try command(){
            case .open:
                startBanking()
            case .close:
                return
            }
        } catch {
            print(error.localizedDescription)
        }
        execute()
    }

    private func command() throws -> BankState {
        guard let input = readLine() else {
            return .close
        }
        guard let command = BankState(rawValue: input) else {
            throw BankError.invalidCommand
        }
        return command
    }

    private func startBanking() {
        enqueueCustomers()
        let openTime = Date().now()
        serveCustomers()
        let takenTime = Date().takenTime(from: openTime)
        printMessage(message: .endBanking(customers: Bank.customersPerDay, takenTime: takenTime))
    }

    private func serveCustomers() {
        Bank.customersPerDay = queue.reduce(0) { customersPerDay, customer in
            queue.dequeue()
            teller.assist(customer)
            return customersPerDay + 1
        }
    }

    private func enqueueCustomers() {
        let customers = Int.random(in: Constants.rangeOfCustomers)
        for customer in 1...customers {
            queue.enqueue(customer)
        }
    }
}

extension Date {
    fileprivate func now() -> Double {
        return Double(self.timeIntervalSince1970)
    }

    fileprivate func takenTime(from openTime: Double) -> Double {
        let takenTime = Double(self.timeIntervalSince1970) - openTime
        return takenTime.floor()
    }
}

extension Double {
    fileprivate func floor() -> Double {
        var tmp = self * 10
        tmp.round(.down)
        return tmp / 10
    }
}
