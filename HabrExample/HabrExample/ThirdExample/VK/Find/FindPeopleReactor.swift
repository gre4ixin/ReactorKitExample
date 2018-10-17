//
//  FindPeopleReactor.swift
//  SpasiboRx
//
//  Created by Pavel Grechikhin on 15/10/2018.
//  Copyright © 2018 Pavel Grechikhin. All rights reserved.
//

import ReactorKit
import RxSwift
import RxAlamofire
import RxCocoa

class FindPeopleReactor: Reactor {
    
    let interactor = VKInteractor()
    
    enum Action {
        case updateSearchValue(String)
    }
    
    enum Mutation {
        case findingPeople([UserModel])
        case error
        case clearUserList
    }
    
    struct State: Equatable {
        var error: Bool = false
        var users: [UserModel] = []
        
        static func == (lhs: FindPeopleReactor.State, rhs: FindPeopleReactor.State) -> Bool {
            return lhs.users == rhs.users
        }
    }
    
    var initialState: State
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateSearchValue(let data):
            interactor.searchingName = data
            if data.isEmpty {
                return Observable.just(Mutation.clearUserList)
            }
            return interactor.searchRequest().map({ (response) -> Mutation in
                guard let resp = response else { return Mutation.error }
                return Mutation.findingPeople(resp.response.items)
            })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .findingPeople(let result):
            newState.users = result
            newState.error = false
        case .clearUserList:
            newState.error = false
            newState.users = []
        case .error:
            newState.error = true
        }
        return newState
    }
    
}
