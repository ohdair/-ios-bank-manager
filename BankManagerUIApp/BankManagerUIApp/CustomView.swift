//
//  CustomView.swift
//  BankManagerUIApp
//
//  Created by 박재우 on 2023/03/09.
//

import UIKit

class CustomView {
    let addClientButton: UIButton = {
        let button = UIButton()
        button.setTitle("고객 10명 추가", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("초기화", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "업무 시간 - 00:00:000"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let waitingLabel: UILabel = {
        let label = UILabel()
        label.text = "대기중"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 101 / 255, green: 196 / 255, blue: 102 / 255, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let bankingLabel: UILabel = {
        let label = UILabel()
        label.text = "업무중"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 88 / 255, green: 86 / 255, blue: 207 / 255, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let waitingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let waitingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let bankingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let bankingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    func activeConstraint() {
        let addClientButtonConstraint = [
            addClientButton.topAnchor.constraint(equalTo: addClientButton.superview!.safeAreaLayoutGuide.topAnchor),
            addClientButton.leadingAnchor.constraint(equalTo: addClientButton.superview!.leadingAnchor),
            addClientButton.widthAnchor.constraint(equalToConstant: addClientButton.superview!.frame.width * 0.45),
            addClientButton.heightAnchor.constraint(equalToConstant: 40)
        ]

        let resetButtonConstraint = [
            resetButton.topAnchor.constraint(equalTo: addClientButton.topAnchor),
            resetButton.trailingAnchor.constraint(equalTo: addClientButton.superview!.trailingAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: addClientButton.superview!.frame.width * 0.45),
            resetButton.heightAnchor.constraint(equalToConstant: 40)
        ]

        let timerLabelConstraint = [
            timerLabel.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 20),
            timerLabel.centerXAnchor.constraint(equalTo: addClientButton.superview!.centerXAnchor)
        ]

        let waitingLabelConstraint = [
            waitingLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            waitingLabel.leadingAnchor.constraint(equalTo: addClientButton.superview!.leadingAnchor),
            waitingLabel.trailingAnchor.constraint(equalTo: addClientButton.superview!.centerXAnchor)
        ]

        let bankingLabelConstraint = [
            bankingLabel.topAnchor.constraint(equalTo: waitingLabel.topAnchor),
            bankingLabel.leadingAnchor.constraint(equalTo: addClientButton.superview!.centerXAnchor),
            bankingLabel.trailingAnchor.constraint(equalTo: addClientButton.superview!.trailingAnchor)
        ]

        let waitingScrollViewConstraint = [
            waitingScrollView.topAnchor.constraint(equalTo: waitingLabel.bottomAnchor, constant: 20),
            waitingScrollView.leadingAnchor.constraint(equalTo: waitingLabel.leadingAnchor),
            waitingScrollView.trailingAnchor.constraint(equalTo: waitingLabel.trailingAnchor),
            waitingScrollView.bottomAnchor.constraint(equalTo: addClientButton.superview!.safeAreaLayoutGuide.bottomAnchor)
        ]

        let waitingStackViewConstraint = [
            waitingStackView.topAnchor.constraint(equalTo: waitingScrollView.topAnchor),
            waitingStackView.leadingAnchor.constraint(equalTo: waitingScrollView.leadingAnchor),
            waitingStackView.trailingAnchor.constraint(equalTo: waitingScrollView.trailingAnchor),
            waitingStackView.centerXAnchor.constraint(equalTo: waitingScrollView.centerXAnchor),
            waitingStackView.bottomAnchor.constraint(equalTo: waitingScrollView.bottomAnchor)
        ]

        let bankingScrollViewConstraint = [
            bankingScrollView.topAnchor.constraint(equalTo: bankingLabel.bottomAnchor, constant: 20),
            bankingScrollView.leadingAnchor.constraint(equalTo: bankingLabel.leadingAnchor),
            bankingScrollView.trailingAnchor.constraint(equalTo: bankingLabel.trailingAnchor),
            bankingScrollView.bottomAnchor.constraint(equalTo: addClientButton.superview!.safeAreaLayoutGuide.bottomAnchor)
        ]

        let bankingStackViewConstraint = [
            bankingStackView.topAnchor.constraint(equalTo: bankingScrollView.topAnchor),
            bankingStackView.leadingAnchor.constraint(equalTo: bankingScrollView.leadingAnchor),
            bankingStackView.trailingAnchor.constraint(equalTo: bankingScrollView.trailingAnchor),
            bankingStackView.centerXAnchor.constraint(equalTo: bankingScrollView.centerXAnchor),
            bankingStackView.bottomAnchor.constraint(equalTo: bankingScrollView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(addClientButtonConstraint)
        NSLayoutConstraint.activate(resetButtonConstraint)
        NSLayoutConstraint.activate(timerLabelConstraint)
        NSLayoutConstraint.activate(waitingLabelConstraint)
        NSLayoutConstraint.activate(bankingLabelConstraint)
        NSLayoutConstraint.activate(waitingStackViewConstraint)
        NSLayoutConstraint.activate(waitingScrollViewConstraint)
        NSLayoutConstraint.activate(bankingStackViewConstraint)
        NSLayoutConstraint.activate(bankingScrollViewConstraint)
    }
}
