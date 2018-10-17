//
//  HabrReactorView.swift
//  SpasiboRx
//
//  Created by Pavel Grechikhin on 26/09/2018.
//  Copyright © 2018 Pavel Grechikhin. All rights reserved.
//

import ReactorKit
import RxSwift

class HabrReactorView: Reactor {
    
    enum Action {
        case incrementButtonTapped
        case decrimentButtonTapped
    }
    
    enum Mutation {
        case incrementValue
        case decrimentValue
        case activityEnable
    }
    
    struct State {
        var reactValue: Int = 0
        var activity: Bool = false
    }
    
    var initialState: State
    
    init() {
        initialState = State()
    }
    
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .incrementButtonTapped:
            return Observable.just(Mutation.incrementValue)
        case .decrimentButtonTapped:
            return Observable.just(Mutation.decrimentValue)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .incrementValue:
            newState.reactValue += 1
        case .decrimentValue:
            newState.reactValue -= 1
        case .activityEnable:
            newState.activity = !state.activity
        }
        return newState
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        let newAction = action.map { (event) -> Action in
            if (event == Action.incrementButtonTapped) {
                return Action.decrimentButtonTapped
            } else {
                return Action.incrementButtonTapped
            }
        }
        return newAction
    }
    
}
