//
//  JsonPlaceholerTestReactorView.swift
//  SpasiboRx
//
//  Created by Pavel Grechikhin on 01/10/2018.
//  Copyright © 2018 Pavel Grechikhin. All rights reserved.
//

import ReactorKit
import RxSwift
import RxAlamofire

let baseUrl = "http://jsonplaceholder.typicode.com/posts/"

class JsonPlaceholerTestReactorView: Reactor {
    
    var bag = DisposeBag()
    
    enum Action {
        // actiom cases
        case addButtonTapped
    }

    enum Mutation {
        // mutation cases
        case showActivity, hideActivity
        case updateIdentifier(Int)
        case successWithData(ResponseObject), errorRequest
    }
    
    struct State: Equatable {
        
        //state
        var load: Bool = false
        var responseObject: [ResponseObject] = []
        var currentIdentifier: Int = 0
        var error: Bool = false
        var errorText = ""
        
        static func == (lhs: JsonPlaceholerTestReactorView.State, rhs: JsonPlaceholerTestReactorView.State) -> Bool {
            return lhs.responseObject == rhs.responseObject
        }
    }
    
    let initialState: State
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .addButtonTapped:
            return Observable.concat([
                Observable.just(Mutation.showActivity),
                Observable.just(Mutation.updateIdentifier(self.currentState.currentIdentifier + 1)),
                makeRequest(with: self.currentState.currentIdentifier + 1),
                Observable.just(Mutation.hideActivity)
                                      ])
         }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
         case .showActivity:
            newState.load = true
         case .hideActivity:
            newState.load = false
         case .updateIdentifier(let identifier):
            newState.currentIdentifier = identifier
         case .errorRequest:
            newState.error = true
         case .successWithData(let data):
            var items = state.responseObject
            items.append(data)
            newState.responseObject = items
        }
        return newState
    }
    
    
    //MARK: - Private
    private func makeRequest(with identifier:Int) -> Observable<Mutation> {
        let currentId = (identifier <= 0) && (identifier > 100) ? 1 : identifier
        return requestData(.get, "\(baseUrl)\(currentId)").map({ (response) -> Mutation in
            if (response.0.statusCode == 404) {
                return Mutation.errorRequest
            } else {
                let response = try! JSONDecoder().decode(ResponseObject.self, from: response.1)
                return Mutation.successWithData(response)
            }
        })
    }
    
}

// model
struct ResponseObject: Codable, Equatable {
    var userId: Int
    var title: String
    var body: String
    var id: Int
}
