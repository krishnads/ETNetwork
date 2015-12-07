//
//  ETNetwork.swift
//  ETNetwork
//
//  Created by ethan on 15/11/30.
//  Copyright © 2015年 ethan. All rights reserved.
//

import Foundation


///wrap the alamofire method
public enum ETRequestMethod {
    case Options, Get, Head, Post, Put, Patch, Delete, Trace, Connect
    
    var method: Method {
        switch self {
        case .Options:
            return Method.OPTIONS
        case .Get:
            return Method.GET
        case .Head:
            return Method.HEAD
        case .Post:
            return Method.POST
        case .Put:
            return Method.PUT
        case .Patch:
            return Method.PATCH
        case .Delete:
            return Method.DELETE
        case .Trace:
            return Method.TRACE
        case .Connect:
            return Method.CONNECT
            
        }
    }
}

///wrap the alamofire ParameterEncoding
public enum ETRequestParameterEncoding {
    case Url
    case UrlEncodedInURL
    case Json
    case PropertyList(NSPropertyListFormat, NSPropertyListWriteOptions)
    
    var encode: ParameterEncoding {
        switch self {
        case .Url:
            return ParameterEncoding.URL
        case .UrlEncodedInURL:
            return ParameterEncoding.URLEncodedInURL
        case .Json:
            return ParameterEncoding.JSON
        case .PropertyList(let format, let options):
            return ParameterEncoding.PropertyList(format, options)
        }
    }
}



public enum ETResponseSerializer {
    case Data, String, Json, PropertyList
}


/**
 the request delegate callback
 */
public protocol ETRequestDelegate : class {
    func requestFinished(request: ETRequest)
    func requestFailed(request: ETRequest)
}

/**
 make ETRequestDelegate callback method optional
 */
public  extension ETRequestDelegate {
    func requestFinished(request: ETRequest) {
        
    }
    func requestFailed(request: ETRequest) {
        
    }
}

/**
 conform to custom your own NSURLRequest
 if you conform to this protocol, the ETRequestProtocol will be ignored
 */
public protocol ETRequestCustom {
    var customUrlRequest: NSURLRequest { get}
}

/**
 conform to custom your own request cache
 */
public protocol ETRequestCacheProtocol: class {
    var cacheSeconds: Int { get }
    var cacheVersion: UInt64 { get }
}

public extension ETRequestCacheProtocol {
    ///default value 0
    var cacheVersion: UInt64 { return 0 }
}

public protocol ETRequestDownloadProtocol: class {
//    var destinationURL: DownloadFileDestination { get }
    var resumeData: NSData? { get }
}

public extension ETRequestDownloadProtocol {
//    var destinationURL: DownloadFileDestination { return Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask) }
    var resumeData: NSData? { return nil }
}

public protocol ETREquestUploadProtocol: class {
    var uploadType: UploadType { get }
    var fileURL: NSURL? { get }
    var fileData: NSData? { get }
    var formData: [UploadWrap]? { get }
}

/**
 your subclass must conform this protocol
 */
public protocol ETRequestProtocol : class {
    var requestUrl: String { get }
    
    var taskType: TaskType { get }
    var baseUrl: String { get }
    var method: ETRequestMethod { get }
    var parameters:  [String: AnyObject]? { get }
    
    var headers: [String: String]? { get }
    var parameterEncoding: ETRequestParameterEncoding { get }
    var responseStringEncoding: NSStringEncoding { get }
    var responseJsonReadingOption: NSJSONReadingOptions { get }
    var responseSerializer: ETResponseSerializer { get }
}

/**
 make ETRequestProtocol some methed default and optional
 */
public extension ETRequestProtocol {
        var taskType: TaskType { return .Data }
    var baseUrl: String { return ETNetworkConfig.sharedInstance.baseUrl }
    
    var method: ETRequestMethod { return .Post }
    var parameters: [String: AnyObject]? { return nil }
    var headers: [String: String]? { return nil }
    var parameterEncoding: ETRequestParameterEncoding { return  .Json }
    var responseStringEncoding: NSStringEncoding { return NSUTF8StringEncoding }
    var responseJsonReadingOption: NSJSONReadingOptions { return .AllowFragments }
    var responseSerializer: ETResponseSerializer { return .Json }
}


public enum TaskType {
    case Data, Download, Upload
}


struct UploadTypeKey {
    static let fileName = "UploadTypeKeyFileName"
    static let name = "UploadTypeKeyName"
    static let data = "UploadTypeKeyData"
    static let mimeType = "UploadTypeMimeType"
}

public class UploadWrap {
    var name: String
    var fileName: String?
    var mimeType: String?

    init(name: String, fileName: String? = nil, mimeType: String? = nil) {
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

 public final class UploadWrapData: UploadWrap {
    var data: NSData
    init(name: String, fileName: String?, mimeType: String?, data: NSData) {
        self.data = data
        super.init(name: name, fileName: fileName, mimeType: mimeType)
    }
}

public final class UploadWrapFileURL: UploadWrap {
    var fileURL: NSURL

    init(name: String, fileName: String?, mimeType: String?, fileURL: NSURL) {
        self.fileURL = fileURL
        super.init(name: name, fileName: fileName, mimeType: mimeType)
    }
}

public final class UploadWrapStream: UploadWrap {
    var stream: NSInputStream
    init(name: String, fileName: String?, mimeType: String?, stream: NSInputStream) {
        self.stream = stream
        super.init(name: name, fileName: fileName, mimeType: mimeType)
    }
}

struct UploadData {
    var data: NSData
    var name: String
    var fileName: String
    var mimeType: String
}

public enum UploadType {
    case FileData, FileURL, FormData
}
//name easily
typealias JobRequest = Request
typealias JobManager = Manager