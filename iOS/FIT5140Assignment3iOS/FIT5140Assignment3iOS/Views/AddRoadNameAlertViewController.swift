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
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var delegate:CustomRoadControllerDelegate?
    private var image:UIImage?
    
    var selectedRoad:UserSelectedRoadResponse?
    
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
        self.indicator.isHidden = true
        if let road = selectedRoad{
            initwithData(selectedRoad: road)
        }else{
            initWithoutData()
        }

    }
    
    func initwithData(selectedRoad:UserSelectedRoadResponse){
        self.nameField.text = selectedRoad.selectedRoadCustomName
        self.nameField.delegate = self
        if let storeUrl = selectedRoad.userCustomImage,storeUrl.count > 0{
            imageView.contentMode = .scaleAspectFill
            addImageLabel.isHidden = true
            ImageLoader.simpleLoad(storeUrl, imageView: imageView)
        }
    }
    
    func initWithoutData(){
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
        if let awsController = (UIApplication.shared.delegate as? AppDelegate)?.awsController,let image = self.image?.resizeImage(newWidth: 400)?.jpegData(compressionQuality: 60) {
            showIndicator()
            storedUrl = awsController.uploadFile(data:image,block: {(task,error) in
                DispatchQueue.main.async {
                    if error == nil{
                        self.removendicator()
                        self.delegate?.didCustomFinished(customName: name, storedUrl: storedUrl)
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.showToast(message: "Upload error:\(error!)")
                    }
                }

            })
        }else{
            delegate?.didCustomFinished(customName: name, storedUrl: storedUrl)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    private func showIndicator(){
        self.saveBtn.isEnabled = false
        self.saveBtn.setTitle("", for: .normal)
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    private func removendicator(){
        self.saveBtn.isEnabled = true
        self.saveBtn.setTitle("Save", for: .normal)
        indicator.isHidden = true
        self.saveBtn.subviews.forEach({(v) in v.removeFromSuperview()})
    }
    
}

protocol CustomRoadControllerDelegate {
    func didCustomFinished(customName:String, storedUrl:String)
}
