//
//  UserCellObject.swift
//  SpasiboRx
//
//  Created by Pavel Grechikhin on 16/10/2018.
//  Copyright © 2018 Pavel Grechikhin. All rights reserved.
//

import UIKit

protocol BaseCellObject {
    var heightCell: Float { get }
    var reuseIdentifier: String { get }
    var nibName: UINib { get }
}

class UserCellObject: BaseCellObject {
    
    var userImageURL: String?
    var userName: String?
    
    var heightCell: Float {
        return 60
    }
    
    var reuseIdentifier: String {
        return "UserCell"
    }
    
    var nibName: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
