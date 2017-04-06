//
//  ViewController.swift
//  RxSample
//
//  Created by mitake on 2017/04/06.
//  Copyright © 2017 mitake. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var num1TextField: UITextField!
    @IBOutlet weak var num2TextField: UITextField!
    @IBOutlet weak var resultTextLabel: UILabel!
    @IBOutlet weak var isValidButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ユーザからの入力値を足し合わせるストリーム
        let input = Observable
            .combineLatest(num1TextField.rx.text.orEmpty, num2TextField.rx.text.orEmpty) { textValue1, textValue2 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0)
            }
        
        // 合計値をラベルに反映するストリーム
        input
            .map { $0.description }
            .bindTo(resultTextLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        // 合計値の値をもとに、ボタンの有効/無効を切り替えるストリーム
        input
            .map { $0 > 100 }
            .bindTo(isValidButton.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
    }
    
    // キーボードを view tap でしまう
    @IBAction func tapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

