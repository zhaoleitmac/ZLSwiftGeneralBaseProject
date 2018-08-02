//
//  Alamofire+QNExtenstion.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/6.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import Alamofire

extension DataRequest{
    public static func encodingJsonResponseSerializer(
        options: JSONSerialization.ReadingOptions = .allowFragments,
        encoding:String.Encoding? = nil
        )-> DataResponseSerializer<Any>{
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseEncodingJson(options: options, response: response, data: data, error: error)
        }
    }
    @discardableResult
    public func responseEncodingJson(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self{
            return response(
                queue: queue,
                responseSerializer: DataRequest.encodingJsonResponseSerializer(options: options),
                completionHandler: completionHandler
            )
    }
}


extension Request {
    public static func serializeResponseEncodingJson(
        encoding:String.Encoding? = nil,
        options: JSONSerialization.ReadingOptions,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<Any>
    {
        guard error == nil else { return .failure(error!) }
        let emptyDataStatusCodes: Set<Int> = [204, 205]
        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success(NSNull()) }
        
        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }
        
        var convertedEncoding = encoding
        
        if let encodingName = response?.textEncodingName as CFString!, convertedEncoding == nil {
            convertedEncoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(
                CFStringConvertIANACharSetNameToEncoding(encodingName))
            )
        }
        
        let actualEncoding = convertedEncoding ?? String.Encoding.isoLatin1
        
        if let string = String(data: validData, encoding: actualEncoding),
            let utf8Data = string.data(using: String.Encoding.utf8){
            do {
                let json = try JSONSerialization.jsonObject(with: utf8Data, options: options)
                return .success(json)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        } else {
            return .failure(AFError.responseSerializationFailed(reason: .stringSerializationFailed(encoding: actualEncoding)))
        }
        
        
    }
}


