//
//  SearchingInteractor.swift
//  SpasiboRx
//
//  Created by Pavel Grechikhin on 15/10/2018.
//  Copyright © 2018 Pavel Grechikhin. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire


class VKInteractor {

    let baseURLString = "https://api.vk.com/method/users.search?q="
    let fieldsString = "&fields=first_name,last_name,photo&access_token="
    let version = "&v=5.80"
    var searchingName = ""
    
    var url: String {
        let name = searchingName.replacingOccurrences(of: " ", with: "%20")
        let token = DataStorage.sharedInstance.token!
        let urlStr = "\(baseURLString)\(name)\(fieldsString)\(token)\(version)"
        return urlStr
    }
    
    func searchRequest() -> Observable<ServerResponse?> {
        return requestData(.get, "\(url)").map({ (response, data) -> ServerResponse? in
            for i in 201...404 {
                if i == response.statusCode {
                    return nil
                }
            }
            do {
                let result = try JSONDecoder().decode(ServerResponse.self, from: data)
                return result
            } catch {
                return nil
            }
        })
    }
    
}


struct ServerResponse: Codable {
    var response: ItemsModel
}

struct ItemsModel: Codable {
    var count: Int
    var items: [UserModel]
}

struct UserModel: Codable, Equatable {
    var first_name: String
    var last_name: String
    var photo: String?
}
