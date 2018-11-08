//
//  DancePartyVC.swift
//  attention
//
//  Created by Brendan Lensink on 2018-11-08.
//  Copyright © 2018 steamclock. All rights reserved.
//

import Bluejay
import UIKit

private enum DanceColor: String, CaseIterable {
    case red
    case blue
    case purple
    case pink
    case yellow
    case orange
    case green

    var uiColor: UIColor {
        switch self {
        case .red: return UIColor.red
        case .blue: return UIColor.blue
        case .purple: return UIColor.purple
        case .pink: return UIColor(hex: "E800CA")
        case .yellow: return UIColor.yellow
        case .orange: return UIColor.orange
        case .green: return UIColor(hex: "00FF37")
        }
    }

    var hexColor: (r: UInt8, g: UInt8, b: UInt8) {
        switch self {
        case .red: return (r: 0xFF, g: 0x00, b: 0x00)
        case .blue: return (r: 0x00, g: 0x00, b: 0xFF)
        case .purple: return (r: 0x68, g: 0x35, b: 0x89)
        case .pink: return (r: 0xE8, g: 0x00, b: 0xCA)
        case .yellow: return (r: 0xFF, g: 0xFF, b: 0x00)
        case .orange: return (r: 0xFF, g: 0x85, b: 0x00)
        case .green: return (r: 0x0B, g: 0xFF, b: 0x00)
        }
    }
}

class DancePartyVC: UIViewController {
    weak var bluejay: Bluejay?

    private var tickCount = 0
    private var timer: Timer!
    private var previousColor: DanceColor!

    override func viewDidLoad() {
        super.viewDidLoad()

        tickCount = 0
        let color = DanceColor.allCases.randomElement()!
        writeColor(r: color.hexColor.r, g: color.hexColor.g, b: color.hexColor.b)
        view.backgroundColor = color.uiColor
        previousColor = color

        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(tick(_:)), userInfo: nil, repeats: true)
    }

    @objc private func tick(_ sender: Any) {
        guard tickCount < 10 else {
            writeColor(r: 0x00, g: 0x00, b: 0x00)
            timer.invalidate()
            dismiss(animated: true, completion: nil)
            return
        }

        let randomColor = DanceColor.allCases.filter { $0 != previousColor }.randomElement()!
        view.backgroundColor = randomColor.uiColor

        let randomHex = randomColor.hexColor
        writeColor(r: randomHex.r, g: randomHex.g, b: randomHex.b)

        previousColor = randomColor
        tickCount += 1
    }

    private func writeColor(r: UInt8, g: UInt8, b: UInt8) {
        guard let bluejay = bluejay else {
            fatalError("Need to set bluejay")
        }

        let data = Data(bytes: [0x56, r, g, b, 0x00, 0xf0, 0xaa])

        let serviceID = ServiceIdentifier(uuid: "FFE5")
        let charID = CharacteristicIdentifier(uuid: "FFE9", service: serviceID)
        bluejay.write(to: charID, value: data) { _ in
            print("SENT COLOR")
        }
    }
}
