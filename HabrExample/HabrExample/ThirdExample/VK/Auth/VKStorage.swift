//
//  VKStorage.swift
//  SpasiboRx
//
//  Created by Pavel Grechikhin on 15/10/2018.
//  Copyright © 2018 Pavel Grechikhin. All rights reserved.
//

import Foundation

class DataStorage {
    static var sharedInstance = DataStorage()
    
    var token: String?
}
