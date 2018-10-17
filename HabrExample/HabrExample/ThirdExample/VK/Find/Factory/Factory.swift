//
//  Factory.swift
//  SpasiboRx
//
//  Created by Pavel Grechikhin on 17/10/2018.
//  Copyright © 2018 Pavel Grechikhin. All rights reserved.
//

import Foundation

class UserFactory {
    
    static func makeCellObject(_ userModel: [UserModel]) -> [UserCellObject]{
        var cellObjects: [UserCellObject] = []
        for user in userModel {
            let userCellObject = UserCellObject()
            userCellObject.userName = user.first_name + " " + user.last_name
            userCellObject.userImageURL = user.photo
            cellObjects.append(userCellObject)
        }
        return cellObjects
    }
}
