//
//  FindPeopleViewController.swift
//  SpasiboRx
//
//  Created by Pavel Grechikhin on 15/10/2018.
//  Copyright © 2018 Pavel Grechikhin. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import RxAlamofire

class FindPeopleViewController: UIViewController, StoryboardView {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cell = UserCellObject()
        tableView.register(cell.nibName, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    func bind(reactor: FindPeopleReactor) {
        
        
        searchBar.rx.text
            .map { Reactor.Action.updateSearchValue($0 ?? "")}
            .skip(1)
            .debounce(1, scheduler: MainScheduler.instance)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .distinctUntilChanged()
            .map({ (state) -> [UserCellObject] in
            return UserFactory.makeCellObject(state.users)   
            })
            .bind(to: tableView.rx.items(cellIdentifier: "UserCell", cellType: UserCell.self))
            { (index, element, cell) in
                cell.configureWithCellObject(element)
            }.disposed(by: disposeBag)
        
    }

}
