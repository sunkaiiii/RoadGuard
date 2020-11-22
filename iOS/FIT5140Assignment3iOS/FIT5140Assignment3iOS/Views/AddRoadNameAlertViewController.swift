//
//  AddRoadNameAlertViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/11/20.
//

import UIKit

class AddRoadNameAlertViewController: UIViewController,UIImagePickerControllerDelegate,ImagePickerDelegate {

    

    var imagePicker:ImagePicker?
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet var saveBtn: UIView!
    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var delegate:CustomRoadControllerDelegate?
    private var image:UIImage?
    
    init(delegate:CustomRoadControllerDelegate) {
        super.init(nibName: "AddRoadNameAlertViewController", bundle: Bundle.main)
        self.delegate = delegate
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.showImagePicker(recognzier:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.nameField.text = "Date: "+dateFormatter.string(from: Date.init())
        self.nameField.delegate = self
    }
    
    func didSelect(imageUrl: String, image: UIImage?) {
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.image = image
        addImageLabel.isHidden = true
    }
    
    @objc func showImagePicker(recognzier:UITapGestureRecognizer){
        imagePicker?.present(from: imageView)
    }

    @IBAction func saveCustomInformation(_ sender: Any) {
        var storedUrl = ""
        guard let name = self.nameField.text,name.count != 0 else{
            showToast(message: "Custom name cannot be empty")
            return
        }
        if let awsController = (UIApplication.shared.delegate as? AppDelegate)?.awsController,let image = self.image?.resizeImage(newWidth: 400)?.jpegData(compressionQuality: 80) {
            storedUrl = awsController.uploadFile(data:image)
        }
        delegate?.didCustomFinished(customName: name, storedUrl: storedUrl)
        dismiss(animated: true, completion: nil)
    }
    
}

protocol CustomRoadControllerDelegate {
    func didCustomFinished(customName:String, storedUrl:String)
}
