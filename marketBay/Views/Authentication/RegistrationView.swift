//
//  RegistrationView.swift
//  marketBay
//
//  Created by EmJhey PB on 2/8/24.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss)  var dismiss
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    @EnvironmentObject var authDBHelper : AuthenticationFireDBHelper
    
    @State private var emailFromUI : String = ""
    @State private var nameFromUI : String = ""
    @State private var passwordFromUI : String = ""
    @State private var phoneNumberFromUI : String = ""
    @State private var errorMessage : String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            CustomBackFragment()
            Spacer()
            Text("Name")
            TextField("Enter name", text: self.$nameFromUI)
                .autocorrectionDisabled(true)
                .autocapitalization(.words)
                .keyboardType(.alphabet)
            Text("Email")
            TextField("Enter email address", text: self.$emailFromUI)
                .autocorrectionDisabled(true)
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .keyboardType(.emailAddress)
            Text("Password")
            SecureField("Enter password (min 6 characters)", text: self.$passwordFromUI)
                .autocorrectionDisabled(true)
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            Text("Phone Number")
            TextField("Enter phone number", text: self.$phoneNumberFromUI)
                .autocorrectionDisabled(true)
                .autocapitalization(.words)
                .keyboardType(.alphabet)
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
                    validateRegistration()
                }label: {
                    Text("R E G I S T E R")
                }
                Spacer()
            }
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
    
    func validateRegistration(){
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        //empty field validation
        if self.nameFromUI.isEmpty || self.emailFromUI.isEmpty || self.passwordFromUI.isEmpty || self.phoneNumberFromUI.isEmpty {
            self.errorMessage = "Please fill in all the fields to register"
            return
        }
        //email format validation
        else if !emailPredicate.evaluate(with: self.emailFromUI){
            self.errorMessage = "Invalid Email Format"
            return
        }
        //phonenumber format validation
        else if Int(self.phoneNumberFromUI) == nil || self.phoneNumberFromUI.count != 10{
            self.errorMessage = "Invalid Phone Number Format"
            return
        }
        //password length validation
        else if self.passwordFromUI.count < 6{
            self.errorMessage = "Weak Password. Length should be greater than 6 characters."
            return
        }
        //register user
        else{
            let user = User(id: self.emailFromUI, name: self.nameFromUI, phoneNumber: self.phoneNumberFromUI)
            self.errorMessage = ""
            self.authDBHelper.insert(newData: user)
            self.fireAuthHelper.signUp(email: emailFromUI, password: passwordFromUI)
            dismiss()
        }
    }
}

#Preview {
    RegistrationView()
}
