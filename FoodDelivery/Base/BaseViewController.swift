//
//  BaseViewController.swift
//  FoodDelivery
//
//  Created by PC1562 on 10/1/25.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
    }
    
}
