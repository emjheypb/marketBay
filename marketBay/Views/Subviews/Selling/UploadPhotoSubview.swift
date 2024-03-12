//
//  UploadaPhotoButton.swift
//  marketBay
//
//  Created by EmJhey PB on 3/11/24.
//

import SwiftUI
import PhotosUI

struct UploadPhotoSubview: View {
    @Binding var listingImage: UIImage?
    var imageURL : String
    var isDisabled : Bool = false
    
    @State private var permissionGranted: Bool = false
    @State private var showSheet: Bool = false
    @State private var showPicker : Bool = false
    @State private var isUsingCamera : Bool = false
    
    var body: some View {
        Button {
            if(self.permissionGranted) {
                self.showSheet = true
            } else {
                self.checkPermission()
            }
        } label: {
            if(!imageURL.isEmpty && listingImage == nil) {
                AsyncImage(url: URL(string: imageURL)) {
                    image in
                    image.image?.resizable()
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
            } else {
                Image(uiImage: listingImage ?? UIImage(systemName: "photo")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
            }
        }
        .disabled(isDisabled)
        .actionSheet(isPresented: self.$showSheet){
            ActionSheet(title: Text("Select Photo"),
                        message: Text("Choose profile picture to upload"),
                        buttons: [
                            .default(Text("Choose photo from library")){
                                //show library picture picker
                                guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                                    print(#function, "No Library Access")
                                    return
                                }
                                
                                self.isUsingCamera = false
                                self.showPicker = true
                            },
                            .default(Text("Take a new pic from Camera")){
                                //open camera
                                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                                    print(#function, "No Camera Access")
                                    return
                                }
                                
                                self.isUsingCamera = true
                                self.showPicker = true
                            },
                            .cancel()
                        ])
        }
        .fullScreenCover(isPresented: self.$showPicker){
            if (isUsingCamera){
                //open camera Picker
                CameraPicker(selectedImage: self.$listingImage)
            }else{
                //open library picker
                PhotoLibraryPicker(selectedImage: self.$listingImage)
            }
        }
    }
    
    private func checkPermission(){
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined, .denied:
            self.permissionGranted = false
            requestPermission()
        case .authorized:
            self.permissionGranted = true
            self.showSheet = true
        case .limited, .restricted:
            // inform user
            break
        @unknown default:
            return
        }
    }
    
    private func requestPermission(){
        PHPhotoLibrary.requestAuthorization { status in
            switch(status) {
            case .notDetermined, .denied:
                self.permissionGranted = false
            case .authorized:
                self.permissionGranted = true
            case .limited, .restricted:
                // inform user
                break
            @unknown default:
                return
            }
        }
    }
}
