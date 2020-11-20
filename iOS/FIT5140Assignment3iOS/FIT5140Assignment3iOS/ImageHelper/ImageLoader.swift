//
//  ImageLoader.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import Foundation
import UIKit

//Load a image with cache and local storage
final class ImageLoader: NSObject {

    
    static let loaderDelegate = ImageLoaderDelegate()

    
    
    private override init() {
        
    }

    static func load(_ imageUrl:String?)->ImageLoaderProcess{
        return ImageLoaderProcess(imageUrl: imageUrl,delegate: loaderDelegate)
    }
    
    static func simpleLoad(_ imageUrl:String?, imageView:UIImageView){
        return ImageLoaderProcess(imageUrl: imageUrl, delegate: loaderDelegate).placeHolder(UIImage(named: "Loading")!).onEmptyHolder(UIImage(named: "PlaceHolder")!).into(imageView)
    }
    
    static func simpleLoad(_ imageUrl:String?, onComplete: @escaping(String, UIImage?)->Void){
        return ImageLoaderProcess(imageUrl: imageUrl, delegate: loaderDelegate).load(onComplete: onComplete)
    }
    

    //To encapsulate and hide the interface of the implemented interfaces, using another delegate class.
    class ImageLoaderDelegate:NSObject,URLSessionTaskDelegate, URLSessionDownloadDelegate{
        // Usage of lock, references on https://developer.apple.com/documentation/foundation/nslocking/1416318-lock
        let lock = NSLock()
        private var taskMap = [URLSessionDownloadTask:ImageDownloadTask]()
        private var imageCache = NSCache<AnyObject, AnyObject>()
        private var session:URLSession?
        private let config = URLSessionConfiguration.background(withIdentifier: "ImageLoader")
        
        override init() {
            super.init()
            session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        }
        
        func loadImage(_ imageUrl:String, onComplete: @escaping(String, UIImage?)->Void){
            //TODO more string filter
            let renamedUrl =  imageUrl.replacingOccurrences(of: "/", with: "_")
            if let data = imageCache.object(forKey: renamedUrl as AnyObject){
                onComplete(renamedUrl,UIImage(data: data as! Data))
                return
            }
            
            
            if let uiImage = retriveImage(forKey: renamedUrl, inStorageType: .fileSystem){
                if let data = uiImage.pngData(){
                    imageCache.setObject(data as AnyObject, forKey: renamedUrl as AnyObject)
                }
                onComplete(renamedUrl, uiImage)
                return
            }
            
            if let uiImage = UIImage(named: imageUrl){
                if let data = uiImage.pngData(){
                    imageCache.setObject(data as AnyObject, forKey: renamedUrl as AnyObject)
                }
                onComplete(renamedUrl, uiImage)
            }
            
            guard let url = URL(string: imageUrl) else {
                return
            }
            
            guard let session = session else {
                return
            }
            
            let task = session.downloadTask(with: url)
            taskMap[task] = ImageDownloadTask(imageUrl,onComplete: onComplete)
            task.resume()
        }
        
        
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            do{
                let data = try Data(contentsOf: location)
                if let imageTask = taskMap[downloadTask]{
                    let renamedUrl =  imageTask.url.replacingOccurrences(of: "/", with: "_")
                    imageCache.setObject(data as AnyObject, forKey: renamedUrl as AnyObject)
                    self.lock.lock()
                    if taskMap[downloadTask] != nil{
                        taskMap.removeValue(forKey: downloadTask)
                    }
                    self.lock.unlock()
                    let image = UIImage(data: data)
                    if let image = image{
                        storeImage(image: image, forKey: renamedUrl, wtihStorageType: .fileSystem)
                    }
                    DispatchQueue.main.async {
                        imageTask.onComplete(renamedUrl, image)
                    }
                }
            }catch let error{
                print(error.localizedDescription)
            }
        }
        
        
        private func storeImage(image:UIImage, forKey key:String, wtihStorageType storageType: StorageType){
            if let pngRepresentation = image.pngData(){
                switch storageType {
                case .fileSystem:
                    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    let documentDirecotry = paths[0]
                    let fileUrl = documentDirecotry.appendingPathComponent(key)
                    do{
                        try pngRepresentation.write(to: fileUrl)
                    }catch{
                        return
                    }
                    break
                case .userDefaults:
                    UserDefaults.standard.set(pngRepresentation, forKey: key)
                    break
                }
            }
        }
        
        private func retriveImage(forKey key:String, inStorageType storageType: StorageType) -> UIImage? {
            switch storageType {
            case .fileSystem:
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let documentsDirectory = paths[0]
                let imageUrl = documentsDirectory.appendingPathComponent(key)
                let image = UIImage(contentsOfFile: imageUrl.path)
                return image
            case .userDefaults:
                if let imageData = UserDefaults.standard.object(forKey: key) as? Data{
                    return UIImage(data: imageData)
                }
                break
            }
            return nil
        }
    }
    
    private enum StorageType{
        case userDefaults
        case fileSystem
    }
    private class ImageDownloadTask{
        let url:String
        let onComplete:(String,UIImage?)->Void
        
        init(_ url:String, onComplete: @escaping (String,UIImage?)->Void) {
            self.url = url
            self.onComplete = onComplete
        }
    }
    
    final class ImageLoaderProcess{
        var imageUrl:String?
        weak var placeHolder:UIView?
        weak var placeHolderImage:UIImage?
        weak var onErrorHolder:UIView?
        weak var onEmptyHolder:UIView?
        weak var onEmptyImage:UIImage?
        
        weak var loaderDelegate:ImageLoaderDelegate?
        private var placeHolderType:PlaceHolderType = .none
        private var emptyHolderType:PlaceHolderType = .none
        private enum PlaceHolderType{
            case image
            case view
            case none
        }

        init(imageUrl:String?, delegate:ImageLoaderDelegate) {
            self.imageUrl = imageUrl
            self.loaderDelegate = delegate
        }
        
        func placeHolder(_ placeHolder:UIView)->ImageLoaderProcess{
            self.placeHolder = placeHolder
            placeHolderType = .view
            return self
        }
        
        func placeHolder(_ placeHolder:UIImage)->ImageLoaderProcess{
            placeHolderImage = placeHolder
            placeHolderType = .image
            return self
        }
        
        func onEmptyHolder(_ empty:UIView)->ImageLoaderProcess{
            onEmptyHolder = empty
            emptyHolderType = .view
            return self
        }
        
        func onEmptyHolder(_ empty:UIImage)->ImageLoaderProcess{
            onEmptyImage = empty
            emptyHolderType = .image
            return self
        }
        
        func load(onComplete: @escaping(String, UIImage?)->Void){
            if let imageUrl = imageUrl{
                loaderDelegate?.loadImage(imageUrl, onComplete: {(url,image) in
                    onComplete(url,image)
                })
            }
        }
        
        func into(_ imageView:UIImageView){
            imageView.image = nil
            switch placeHolderType {
                case .image:
                    imageView.image = self.placeHolderImage
                case .view:
                    imageView.addSubview(placeHolder!)
                case .none:
                    break
            }
            guard let imageUrl = imageUrl else{
                switch self.emptyHolderType {
                case .image:
                    imageView.image = self.onEmptyImage
                case .view:
                    imageView.addSubview(self.onEmptyHolder!)
                case .none:
                    break
                }
                return
            }
            loaderDelegate?.loadImage(imageUrl, onComplete: {(url,image) in
                if let image = image{
                    for view in imageView.subviews{
                        if view == self.placeHolder{
                            view.removeFromSuperview()
                        }
                    }
                    imageView.image = image
                }else{
                    switch self.emptyHolderType {
                    case .image:
                        imageView.image = self.onEmptyImage
                    case .view:
                        imageView.addSubview(self.onEmptyHolder!)
                    case .none:
                        break
                    }
                }
            })
        }
    }
}
