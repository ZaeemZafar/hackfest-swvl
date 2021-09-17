//
//  ImagePickerHelper.swift
//  Hackfest-swvl
//
//  Created by zaktech on 9/5/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation
import AVKit

class ImagePickerHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    static let shared: ImagePickerHelper = ImagePickerHelper()
    var imagePicker = UIImagePickerController()
    var imageRecieved: ImageCompletion?
    
    func showAlert(on viewController: UIViewController, onSelect: ImageCompletion?) {
        imagePicker.delegate = self
        imageRecieved = onSelect
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                self?.openCamera(on: viewController)
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (granted: Bool) in
                    if granted {
                        //access allowed
                        self?.openCamera(on: viewController)
                        
                    } else {
                        //access denied
                        UIAlertController.showAlertWithSettingsPrompt(title: "Hackfest-swvl", message: "You are not allowed to access system Camera, please allow Hackfest-swvl to access Camera from Settings.", fromViewController: viewController)
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { [weak self] _ in
            self?.openGallary(on: viewController)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        viewController.present(alert, animated: true)
    }
    
    private func openCamera(on viewController: UIViewController) {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraDevice = .front
            imagePicker.allowsEditing = true
            viewController.present(imagePicker, animated: true)
            
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true)
        }
    }
    
    private func openGallary(on viewController: UIViewController) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- UIImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        image.printSize()
        imageRecieved?(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
