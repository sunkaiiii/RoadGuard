//
//  ImagePicker.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import Foundation
import UIKit

protocol ImagePickerDelegate:AnyObject{
    func didSelect(imageUrl:String,image:UIImage?)
}

//references on https://theswiftdev.com/picking-images-with-uiimagepickercontroller-in-swift-5/
class ImagePicker:NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    private let pickerController:UIImagePickerController
    private weak var presentationController:UIViewController?
    private weak var delegate:ImagePickerDelegate?
    
    init(presentationController:UIViewController, delegate:ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    func present(from sourceView:UIView){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let action = self.action(for: .camera, title: "Take photo"){
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll"){
            alertController.addAction(action)
        }
        
        if let action = self.action(for: .photoLibrary, title: "Photo library"){
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        self.presentationController?.present(alertController,animated: true)
    }
    
    private func pickerController(_ controller:UIImagePickerController, didSelect image:UIImage?){
        controller.dismiss(animated: true, completion: nil)
        let url = UUID().uuidString
        if let data = image?.pngData(){
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentDirectory = paths[0]
            let fileUrl = documentDirectory.appendingPathComponent(url)
            do{
                try data.write(to: fileUrl)
            }catch{}

        }
        self.delegate?.didSelect(imageUrl: url, image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect:nil)
        }
        self.pickerController(picker, didSelect:image)
    }
    
    
}
