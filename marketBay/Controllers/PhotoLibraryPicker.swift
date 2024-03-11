//
//  PhotoLibraryPicker.swift
//  marketBay
//
//  Created by EmJhey PB on 3/11/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct PhotoLibraryPicker : UIViewControllerRepresentable {
    @Binding var selectedImage : UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoLibraryPicker>) -> some UIViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        var imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: PhotoLibraryPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<PhotoLibraryPicker>) {
        // nothing to update on UI
    }
    
    func makeCoordinator() -> PhotoLibraryPicker.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator : NSObject, PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            if(results.count <= 0) {
                return
            }
            
            if let selectedImage = results.first {
                if selectedImage.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    selectedImage.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        guard error == nil else {
                            print(#function, "Cannot Convert")
                            return
                        }
                        
                        if let img = image {
                            self.parent.selectedImage = img as? UIImage
                        }
                    }
                } else {
                    print(#function, "Invalid UIImage")
                }
            }
        }
        
        var parent : PhotoLibraryPicker
        
        init(parent: PhotoLibraryPicker) {
            self.parent = parent
        }
    }
}
