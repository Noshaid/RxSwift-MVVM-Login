//
//  ViewController.swift
//  RxSwift MVVM Intro
//
//  Created by Noshaid Ali on 11/08/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag() //memory managemnt, clean everything
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        usernameTF.becomeFirstResponder()
        
        _ = usernameTF.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.usernameTextPublishSubject)
        _ = passwordTF.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.passwordTextPublishSubject)
        
        loginViewModel.isValid().bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
        loginViewModel.isValid().map { $0 ? 1 : 0.1 }.bind(to: loginBtn.rx.alpha).disposed(by: disposeBag)
        loginViewModel.isValid().map { $0 ? "Now Login" : "Can't Login" }.bind(to: loginBtn.rx.title()).disposed(by: disposeBag)
    }

    @IBAction func tappedLoginButton(_ sender: Any) {
        print("Tapped!!!")
    }
}

class LoginViewModel {
    
    //subjects
    let usernameTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    
    //observable
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(usernameTextPublishSubject.asObservable().startWith(""), passwordTextPublishSubject.asObservable().startWith("")).map { username, password in
            return username.count > 3 && password.count > 3
        }.startWith(false)
    }
}
