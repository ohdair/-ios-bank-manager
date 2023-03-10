//
//  Teller.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

enum TellerState {
    case working
    case resting
}

class Teller {
    let type: BankingType
    var workState: TellerState

    init(type: BankingType) {
        self.type = type
        workState = .resting
    }
    
    func assist(_ client: Client){
        usleep(type.processingTime)
    }
}

private extension BankingType {
   var processingTime: UInt32 {
      switch self {
      case .loan:
          return 1100000
      case .deposit:
          return 700000
      }
   }
}
