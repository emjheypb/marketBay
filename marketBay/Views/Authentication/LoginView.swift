//
//  LoginView.swift
//  marketBay
//
//  Created by EmJhey PB on 2/8/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss)  var dismiss
    
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject var dataAccess: DataAccess
    
    var selectedPage : Screens?
    @State private var emailFromUI : String = ""
    @State private var passwordFromUI : String = ""
    @State private var rememberUser : Bool = false
    @State private var errorMessage : String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0){
            Spacer()
            Text("Email")
            TextField("Enter email address", text: self.$emailFromUI)
                .autocorrectionDisabled(true)
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .keyboardType(.emailAddress)
            Text("Password")
            SecureField("Enter password", text: self.$passwordFromUI)
                .autocorrectionDisabled(true)
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            Toggle(isOn: self.$rememberUser){
                Text("Remember Me")
            }
            .tint(.yellow)
            Spacer()
            HStack{
                Spacer()
                Text(self.errorMessage)
                    .padding(self.errorMessage.isEmpty ? 0.0 : 5.0)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .background(.red)
                    .font(.title3)
                    .cornerRadius(10.0)
                Spacer()
            }
            Spacer()
            HStack{
                Spacer()
                Button {
                   validateLogin()
                }label: {
                    Text("L O G I N")
                }
                Spacer()
            }
            NavigationLink {
                RegistrationView()
            }label: {
                Text("R E G I S T E R")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
        }
        .padding()
        .navigationTitle(Text("LOGIN"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func validateLogin(){
        //empty field validation
        if self.emailFromUI.isEmpty || self.passwordFromUI.isEmpty{
            self.errorMessage = "Please enter a valid email address and password"
            return
        }
        //validate enterred credentials
        guard let allUsersData = UserDefaults.standard.array(forKey: "allUsersData") as? [[String: Any]] else {
            return
        }
        if let userData = allUsersData.first(where: { ($0["email"] as? String) == self.emailFromUI }) {
            if userData["password"] as? String ?? "" == self.passwordFromUI {
                self.errorMessage = ""
                dataAccess.login(user: User(id: userData["id"] as! Int, name: userData["name"] as! String, email: userData["email"] as! String, password: userData["password"] as! String, phoneNumber: userData["phoneNumber"] as! String))
                appRootManager.currentRoot = selectedPage ?? .marketplaceView
                dismiss()
            }
            else{
                self.errorMessage = "Incorrect Password"
                return
            }
        }
        else{
            self.errorMessage = "Invalid Credentials"
            return
        }
    }
}

#Preview {
    LoginView()
}
