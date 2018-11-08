//
//  MainVC.swift
//  attention
//
//  Created by Brendan Lensink on 2018-11-08.
//  Copyright © 2018 steamclock. All rights reserved.
//

import Bluejay
import UIKit

class MainVC: UIViewController {
    private let bluejay = Bluejay()

    private var peripherals = [ScanDiscovery]() {
        didSet {
            if let first = peripherals.first {
                connectTo(first)
            }
        }
    }
    private var selectedPeripheralIdentifier: PeripheralIdentifier?

    override func viewDidLoad() {
        super.viewDidLoad()

        bluejay.start()

        startScanning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConnected" {
            guard let destination = segue.destination as? ConnectedVC else {
                fatalError("Couldn't cast UIVC to ConnectedVC")
            }
            destination.bluejay = bluejay
            destination.peripheralIdentifier = selectedPeripheralIdentifier
        }
    }

    private func startScanning() {
        bluejay.scan(
            serviceIdentifiers: [
                ServiceIdentifier(uuid: "FFF0"),
                ServiceIdentifier(uuid: "FFE5"),
                ServiceIdentifier(uuid: "FFE0")
            ],
            discovery: { [weak self ] _, discoveries in
                guard let weakSelf = self else {
                    return .stop
                }
                weakSelf.peripherals = discoveries
                return .continue
            },
            stopped: { _, error in
                if let error = error {
                    print("scan stopped with error: \(error)")
                } else {
                    print("scan stopped without error")
                }
            }
        )
    }

    private func connectTo(_ peripheral: ScanDiscovery) {
        let identifier = peripheral.peripheralIdentifier
        bluejay.connect(identifier, timeout: .none) { [weak self] result in
            switch result {
            case .success(let peripheral):
                debugPrint("Connection to \(peripheral) successful.")

                guard let weakSelf = self else {
                    return
                }
                weakSelf.selectedPeripheralIdentifier = identifier
                weakSelf.bluejay.stopScanning()
                weakSelf.performSegue(withIdentifier: "showConnected", sender: self)
            case .failure(let error):
                debugPrint("Connection to \(identifier) failed with error: \(error.localizedDescription)")
            }
        }
    }
}
