//
//  UserCell.swift
//  SpasiboRx
//
//  Created by Pavel Grechikhin on 16/10/2018.
//  Copyright © 2018 Pavel Grechikhin. All rights reserved.
//

import UIKit
import RxAlamofire
import RxSwift

protocol BaseCell {
    func configureWithCellObject(_ cellObject: BaseCellObject)
}

class UserCell: UITableViewCell, BaseCell {

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userImage: UIImageView!
    var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func configureWithCellObject(_ cellObject: BaseCellObject) {
        guard let userCellObject = cellObject as? UserCellObject else { fatalError("\(#function) Передан неверный cell object") }
        
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
        self.userImage.layer.masksToBounds = true
        if userCellObject.userName != nil {
            self.setupNameLabel(with: userCellObject.userName!)
        }
        
        if userCellObject.userImageURL != nil {
            self.setupImage(with: userCellObject.userImageURL!)
        }
    }
    
    private func setupImage(with urlString: String) {
        requestData(.get, urlString).subscribe { [unowned self] (event) in
            guard let imageData = event.element?.1 else { return }
            self.userImage.image = UIImage(data: imageData)
        }.disposed(by: bag)
    }
    
    private func setupNameLabel(with name: String) {
        self.userNameLabel.text = name
    }
    
}
