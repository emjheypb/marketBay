//
//  CameraPicker.swift
//  marketBay
//
//  Created by EmJhey PB on 3/11/24.
//

import Foundation
import PhotosUI
import SwiftUI

struct CameraPicker : UIViewControllerRepresentable {
    @Binding var selectedImage : UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        var imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // nothing to update on UI
    }
    
    func makeCoordinator() -> CameraPicker.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent : CameraPicker
        
        init(parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.parent.selectedImage = image
                picker.dismiss(animated: true)
                
                PHPhotoLibrary.shared().performChanges {
                    let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    PHAssetCollectionChangeRequest(for: PHAssetCollection())?.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
                }
            } else {
                print(#function, "Original Image not available")
                return
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
