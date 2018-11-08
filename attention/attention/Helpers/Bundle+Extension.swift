//
//  Bundle+Extension.swift
//  attention
//
//  Created by Brendan Lensink on 2018-11-08.
//  Copyright © 2018 steamclock. All rights reserved.
//

import Foundation

extension Bundle {

    var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
}
