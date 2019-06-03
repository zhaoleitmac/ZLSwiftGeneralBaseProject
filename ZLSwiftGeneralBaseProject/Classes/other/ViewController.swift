//
//  ViewController.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/13.
//  Copyright © 2017年 ZhaoLei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: BasicVC {

    @IBOutlet private weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var model = Model(property1: "1", property2: 1, type: .type2)
        self.button.rx.tap.asDriver().drive(onNext: {() in
            model.property2 += 1
            print(model.jsonDictionary() ?? [String : Any]())
        }).disposed(by: self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

struct Model: Codable {
    
    enum ModelType: Int, Codable {
        case type1 = 1
        case type2 = 2
    }
    
    var property1: String
    var property2: Int
    var type: ModelType
}
