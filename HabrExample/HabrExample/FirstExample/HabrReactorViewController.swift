//
//  HabrReactorViewController.swift
//  SpasiboRx
//
//  Created by Pavel Grechikhin on 26/09/2018.
//  Copyright © 2018 Pavel Grechikhin. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

class HabrReactorViewController: UIViewController, StoryboardView {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var decrimentButton: UIButton!
    @IBOutlet var incrementButton: UIButton!
    @IBOutlet var label: UILabel!
    var disposeBag: DisposeBag = DisposeBag()
    
    func bind(reactor: HabrReactorView) {
        incrementButton.rx.tap.map { Reactor.Action.incrementButtonTapped }.bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        decrimentButton.rx.tap.map { Reactor.Action.decrimentButtonTapped }.bind(to: reactor.action).disposed(by: disposeBag)
        
        reactor.state.map { String($0.reactValue) }.bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.activity }.bind(to: activityIndicator.rx.isAnimating).disposed(by: disposeBag)
        
        reactor.state.map { !$0.activity }.bind(to: activityIndicator.rx.isHidden).disposed(by: disposeBag)
        
        
        
    }
}
