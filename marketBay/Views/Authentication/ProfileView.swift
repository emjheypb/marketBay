//
//  ProfileView.swift
//  marketBay
//  For View and Edit User Credentials
//  Created by EmJhey PB on 2/8/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appRootManager: AppRootManager
    //@EnvironmentObject var dataAccess: DataAccess
    @EnvironmentObject var authFireDBHelper: AuthenticationFireDBHelper
    
    @State private var loggedInUser: User?
    @State private var emailFromUI : String = ""
    @State private var nameFromUI : String = ""
    @State private var phoneNumberFromUI : String = ""
    @State private var errorMessage : String = ""
    @State private var successMessage : String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            //MenuTemplate()
            //    .alignmentGuide(.leading) { _ in -10 }
            Text("")
                .frame(maxWidth: .infinity)
            HStack{
                Spacer()
                Text("Profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                Spacer()
            }
            Spacer()
            Grid(alignment: .leading,horizontalSpacing: 10, verticalSpacing: 10){
                GridRow(alignment: .firstTextBaseline){
                    Text("Email")
                    Text(self.emailFromUI)
                }
                GridRow(alignment: .firstTextBaseline){
                    Text("Name")
                    TextField("Name", text: self.$nameFromUI)
                }
                GridRow(alignment: .firstTextBaseline){
                    Text("Phone Number")
                    TextField("Phone Number", text: self.$phoneNumberFromUI)
                }
            }
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
            HStack{
                Spacer()
                Text(self.successMessage)
                    .padding(self.successMessage.isEmpty ? 0.0 : 5.0)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .background(.green)
                    .font(.title3)
                    .cornerRadius(10.0)
                Spacer()
            }
            Spacer()
            HStack{
                Spacer()
                Button{
                    self.updateProfile()
                }label: {
                    Text("Update")
                }
                .buttonStyle(.borderedProminent)
                Spacer()
            }
            Spacer()
        }
        .padding()
        .onAppear(){
            loggedInUser = self.authFireDBHelper.user
            emailFromUI = loggedInUser?.id ?? ""
            nameFromUI = loggedInUser?.name ?? ""
            phoneNumberFromUI = loggedInUser?.phoneNumber ?? ""
        }
    }
    
    func updateProfile(){
        //empty field validation
        if self.nameFromUI.isEmpty || self.phoneNumberFromUI.isEmpty {
            self.errorMessage = "Empty fields are not allowed"
            self.successMessage = ""
            return
        }
        //phonenumber format validation
        else if Int(self.phoneNumberFromUI) == nil || self.phoneNumberFromUI.count != 10{
            self.errorMessage = "Invalid Phone Number Format"
            self.successMessage = ""
            return
        }
        //update user
        else{
            self.authFireDBHelper.update(newName: self.nameFromUI, newPhone: self.phoneNumberFromUI)
            self.errorMessage = ""
            self.successMessage = "Profile Updated Successfully"
        }
    }
}

#Preview {
    ProfileView()
}
