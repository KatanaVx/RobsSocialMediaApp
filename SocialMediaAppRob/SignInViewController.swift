//
//  SignInViewController.swift
//  SocialMediaAppRob
//
//  Created by Roberto Cruz Quesada on 12/2/16.
//  Copyright © 2016 Roberto Cruz Quesada. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper


class SignInViewController: UIViewController {

    @IBOutlet var emailTextField: ABetterTextField!
    @IBOutlet var passwordTextField: ABetterTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "GoToFeedViewController", sender: nil)
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("ROB: Unable to authenticate with Firebase - \(error)")
            } else {
                print("ROB: Successfully authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }
    
    //        Actual Facebook login button...
    //        let loginButton = FBSDKLoginButton.init()
    //        loginButton.center = self.view.center
    //        self.view.addSubview(loginButton)
    @IBAction func facebookButtonPressed(_ sender: Any) {
    
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("ROB: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("ROB: User cancelled Facebook authentication")
            } else {
                print("ROB: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }

    @IBAction func signInButtonPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("ROB: Email user authenticated with Firebase")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("ROB: Unable to authenticate with Firebase using email")
                        } else {
                            print("ROB: Successfully authenticated with Firebase")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ROB: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "GoToFeedViewController", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

