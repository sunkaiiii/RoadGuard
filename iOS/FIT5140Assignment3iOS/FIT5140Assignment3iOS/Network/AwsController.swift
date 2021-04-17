//
//  AwsController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/11/20.
//

import Foundation
import AWSS3


/// upload image to s3 references on https://medium.com/@iamayushverma/uploading-photos-videos-files-to-aws-s3-using-swift-4-1241f690a993
class AwsController{
    let bucketName = ""

    //TODO need to fill up the aws key
    let accessKey = ""
    let secretKey = ""
    
    init() {
        let provider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        guard let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider: provider) else{
            return
        }
        AWSServiceManager.default()?.defaultServiceConfiguration = configuration
    }
    func uploadFile(data:Data,block:AWSS3TransferUtilityUploadCompletionHandlerBlock? = nil)->String {
        let key = UUID().uuidString + ".jpg"
        let utility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.setValue("public-read-write", forRequestHeader: "x-amz-acl")
        expression.setValue("public-read-write", forRequestParameter: "x-amz-acl")
        utility.uploadData(data, bucket: bucketName,key: key, contentType: "image/jpg", expression: expression, completionHandler:block).continueWith(block: {(task)->Any? in
            if let res = task.result {
                print("upload task result = \(res)")
            }

            if let err = task.error {
                print("upload task error = \(err)")
            }
            return nil
        })
        return "https://"+bucketName+".s3.amazonaws.com/"+key
    }
}
