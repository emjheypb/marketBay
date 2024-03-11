//
//  FireAuthHelper.swift
//  marketBay
//
//  Created by EmJhey PB on 2/27/24.
//

import Foundation
import FirebaseAuth

class FireAuthHelper: ObservableObject{    
    @Published var user: FirebaseAuth.User?
    var listener: AuthStateDidChangeListenerHandle? = nil
    
    func listenToAuthState() {
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else {
                return
            }
            
            self.user = user
        }
    }
    
    func signUp(email : String, password : String){
        Auth.auth().createUser(withEmail: email, password: password) {
            [self] authResult, error in
            guard let result = authResult else {
                print(#function, "ERROR: \(error)")
                return
            }
            
            print(#function, "Result: \(result)")
            
            switch(authResult) {
            case .none: print(#function, "FAILED")
            case .some(_):
                print(#function, "SUCCESS")
                
                UserDefaults.standard.set(self.user?.email, forKey: UserDefaultsEnum.USER_EMAIL.rawValue)
                UserDefaults.standard.set(password, forKey: UserDefaultsEnum.USER_PASSWORD.rawValue)
            }
        }
    }
    
    func signIn(email : String, password : String, completionHandler: @escaping(FirebaseAuth.User?, AuthErrorCode?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) {
            [self] authResult, error in
            guard let result = authResult else {
                print(#function, "ERROR: \(error)")
                completionHandler(nil, error as! AuthErrorCode?)
                return
            }
            
            print(#function, "Result: \(result)")
            
            switch(authResult) {
            case .none:
                print(#function, "FAILED")
                completionHandler(nil, error as! AuthErrorCode?)
            case .some(_):
                print(#function, "SUCCESS")
                self.user = authResult?.user
                
                UserDefaults.standard.set(self.user?.email, forKey: UserDefaultsEnum.USER_EMAIL.rawValue)
                UserDefaults.standard.set(password, forKey: UserDefaultsEnum.USER_PASSWORD.rawValue)
                completionHandler(authResult?.user, nil)
            }
            return
        }
    }
    
    func signOut(){
        do {
            try? Auth.auth().signOut()
            self.user = nil
        } catch let err as NSError {
            print(#function, "Logout FAILED: \(err)")
        }
    }
    
}
