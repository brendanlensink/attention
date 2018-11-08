//
//  ConnectedVC.swift
//  attention
//
//  Created by Brendan Lensink on 2018-11-08.
//  Copyright © 2018 steamclock. All rights reserved.
//

import Bluejay
import UIKit

class ConnectedVC: UIViewController {
    weak var bluejay: Bluejay?
    var peripheralIdentifier: PeripheralIdentifier?

    @IBOutlet private var attentionButton: UIButton!
    @IBOutlet private var hungryButton: UIButton!
    @IBOutlet private var danceButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let bluejay = bluejay else {
            fatalError("Need to set bluejay")
        }

        navigationController?.setNavigationBarHidden(true, animated: false)
        bluejay.register(observer: self)
    }

    @IBAction func touchDown(_ sender: UIButton) {
        writeColor(r: 0xFF, g: 0x00, b: 0x00)
    }

    @IBAction func hungryTouchDown(_ sender: Any) {
        writeColor(r: 0x00, g: 0x00, b: 0xFF)
    }

    @IBAction func danceTouchDown(_ sender: UIButton) {
        danceParty()
    }

    @IBAction func touchUpInside(_ sender: Any) {
        touchUp()
    }

    @IBAction func touchUpOutside(_ sender: Any) {
        touchUp()
    }

    private func touchUp() {
        writeColor(r: 0x00, g: 0x00, b: 0x00)
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

    private func danceParty() {
        let partyVC = DancePartyVC()
        partyVC.bluejay = bluejay
        navigationController?.present(partyVC, animated: false, completion: nil)
    }
}

extension ConnectedVC: ConnectionObserver {
    func connected(to peripheral: Peripheral) {}

    func disconnected(from peripheral: Peripheral) {}
}
