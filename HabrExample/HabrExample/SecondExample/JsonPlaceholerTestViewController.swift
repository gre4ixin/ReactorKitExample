//
//  JsonPlaceholerTestViewController.swift
//  SpasiboRx
//
//  Created by Pavel Grechikhin on 01/10/2018.
//  Copyright © 2018 Pavel Grechikhin. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class JsonPlaceholerTestViewController: UIViewController, StoryboardView {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet var activityIdicator: UIActivityIndicatorView!
    @IBOutlet var nextPostButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bind(reactor: JsonPlaceholerTestReactorView) {
        
        nextPostButton.rx.tap.map { Reactor.Action.addButtonTapped }.bind(to: reactor.action).disposed(by: disposeBag)

        reactor.state.map { $0.load }.bind(to: activityIdicator.rx.isAnimating).disposed(by: disposeBag)
        reactor.state.map { !$0.load }.bind(to: activityIdicator.rx.isHidden).disposed(by: disposeBag)
        

        //table view
        reactor.state.map { $0.responseObject }.distinctUntilChanged().bind(to: tableView.rx.items(cellIdentifier: "Cell")) { (index, element, cell) in
            cell.textLabel?.text = element.title
        }.disposed(by: disposeBag)
        
        reactor.state.map { $0.error }.subscribe { [unowned self] (event) in
            guard let error = event.element else { return }
            if (error) {
                
                let alert = UIAlertController(title: "Ошибка", message: "Повторите операцию", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
        
    }
    
}
