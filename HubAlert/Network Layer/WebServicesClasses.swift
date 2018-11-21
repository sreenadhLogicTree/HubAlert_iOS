//
//  WebServicesClasses.swift
//  HubAlertSample
//
//  Created by Thirupathi on 29/10/18.
//  Copyright © 2018 Rama Krishna. All rights reserved.
//

import Foundation


enum ServiceNames: String {
    
    case VerifyMobileNumber = "VerifyMobileNumber"
    case GetAlertModules = "GetAlertModules"
    case GetDefaultAlerts = "GetDefaultAlerts"
    case InsertAppDeviceDetails = "InsertAppDeviceDetails"
    case GetNotifications = "GetNotifications"
    case InserAlertNotification = "InserAlertNotification"
    case SendFeedback = "SendFeedback"

    
}

@objc protocol ServiceHandler_Delegate: AnyObject {
    
    @objc optional
    func verifiedPhoneumber(response:[AnyHashable:AnyObject])
    @objc optional
    func alertModules(response:[AnyHashable : AnyObject])
    @objc optional
    func alerts(response:[AnyHashable : AnyObject])
    @objc optional
    func alertSent(response:[AnyHashable : AnyObject])
    @objc optional
    func alertsReceived(response:[AnyHashable : AnyObject])
    @objc optional
    func feedbackSent(response:[AnyHashable : AnyObject])
    func unauthorized(alert:String)
    func otherError(alert:String)

}



class ServiceHandler: NSObject {
    
    var delegate: ServiceHandler_Delegate?
    
    func callForVerifyMobileNumberRequest(withDict strDict: [String:AnyObject])
    {
        let httpReq: HttpRequest = HttpRequest()
        httpReq.establishConnectionWithReqString(strDict, Delegate: self, serviceNum: ServiceNames.VerifyMobileNumber)
    }
    func getAlertModulesRequest(withDict requestDict: [String:AnyObject])
    {
        let httpReq: HttpRequest = HttpRequest()
        httpReq.establishConnectionWithReqString(requestDict, Delegate: self, serviceNum: ServiceNames.GetAlertModules)
    }
    func getAlertsRequest(withDict requestDict: [String:AnyObject])
    {
        let httpReq: HttpRequest = HttpRequest()
        httpReq.establishConnectionWithReqString(requestDict, Delegate: self, serviceNum: ServiceNames.GetDefaultAlerts)
    }
    func sendAlertRequest(withDict requestDict: [String:AnyObject])
    {
        let httpReq: HttpRequest = HttpRequest()
        httpReq.establishConnectionWithReqString(requestDict, Delegate: self, serviceNum: ServiceNames.InserAlertNotification)
    }
    
    func sendFeedbackRequest(withDict requestDict: [String:AnyObject])
    {
        let httpReq: HttpRequest = HttpRequest()
        httpReq.establishConnectionWithReqString(requestDict, Delegate: self, serviceNum: ServiceNames.SendFeedback)
    }
    
    func getNotifications(withDict requestDict: [String:AnyObject])
    {
        let httpReq: HttpRequest = HttpRequest()
        httpReq.establishConnectionWithReqString(requestDict, Delegate: self, serviceNum: ServiceNames.GetNotifications)
    }
    
    @objc func responseReceived(_ responseData: Any)
    {
        let responseRec: WebResponse = responseData as! WebResponse
        let serviceName: ServiceNames = responseRec.serviceName
        let ReceievedData: Data = responseRec.data
        
        switch serviceName {
        case .VerifyMobileNumber:
            do {
                let dataDicty: Any? = try JSONSerialization.jsonObject(with: ReceievedData, options: [])
                if dataDicty != nil {
                    print("data dict = \(dataDicty.debugDescription)")
                    self.delegate?.verifiedPhoneumber!(response: dataDicty as! [AnyHashable : AnyObject])
                    
                } else {
                    
                }
                
            } catch {
                print("error catched")
            }
        case .GetAlertModules:
            do {
                let dataDicty: Any? = try JSONSerialization.jsonObject(with: ReceievedData, options: [])
                if dataDicty != nil {
                    print("data dict = \(dataDicty.debugDescription)")
                    self.delegate?.alertModules!(response: dataDicty as! [AnyHashable : AnyObject])
                    
                } else {
                    
                }
                
            } catch {
                print("error catched")
            }
            print("Handle alert modules here")
        case .GetDefaultAlerts:
            do {
                let dataDicty: Any? = try JSONSerialization.jsonObject(with: ReceievedData, options: [])
                if dataDicty != nil {
                    print("data dict = \(dataDicty.debugDescription)")
                    
                    if self.delegate != nil{
                        
                        guard let dataDicty = dataDicty as? [AnyHashable : AnyObject] else {return}
                        self.delegate?.alerts!(response: dataDicty)
                        
                    }
                    
                } else {
                    
                }
                
            } catch {
                print("error catched")
            }
            print("Handle default alerts")
        case .InsertAppDeviceDetails:
            print("Hanlde app device details")
        case .GetNotifications:
            do {
                let dataDicty: Any? = try JSONSerialization.jsonObject(with: ReceievedData, options: [])
                if dataDicty != nil {
                    print("data dict = \(dataDicty.debugDescription)")
                    
                    if self.delegate != nil{
                        guard let dataDicty = dataDicty as? [AnyHashable : AnyObject] else {return}
                        self.delegate?.alertsReceived!(response: dataDicty)
                    }
                    
                } else {
                    
                }
                
            } catch {
                print("error catched")
            }
            print("Handle get notifications")
        case .InserAlertNotification:
            do {
                let dataDicty: Any? = try JSONSerialization.jsonObject(with: ReceievedData, options: [])
                if dataDicty != nil {
                    print("data dict = \(dataDicty.debugDescription)")
                    
                    if self.delegate != nil{
                        guard let dataDicty = dataDicty as? [AnyHashable : AnyObject] else {return}
                        self.delegate?.alertSent!(response: dataDicty)
                    }
                    
                } else {
                    
                }
                
            } catch {
                print("error catched")
            }
        
        case .SendFeedback:
            do {
                let dataDicty: Any? = try JSONSerialization.jsonObject(with: ReceievedData, options: [])
                if dataDicty != nil {
                    print("data dict = \(dataDicty.debugDescription)")
                    
                    if self.delegate != nil{
                        guard let dataDicty = dataDicty as? [AnyHashable : AnyObject] else {return}
                        self.delegate?.feedbackSent!(response: dataDicty)
                    }
                    
                } else {
                    
                }
                
            } catch {
                print("error catched")
            }
            
            
            
        default:
            print("new service name found, write code")
        }
    }
    
    @objc func internalServerError(_ error:Error) {
        
        
    }
    
    @objc func showTimeOutError() {
        
    }
    
    @objc func BadRequestError400() {
        
    }
    
    @objc func UnAuthorized401(_ data:Data) {
        
        let dataDicty: [String:String]? = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : String]
        var message = "You are not authorized"
        
        if dataDicty != nil {
            if (dataDicty?["Response"]) != nil{
                message = (dataDicty?["Response"])!
            }
            else if (dataDicty?["Message"]) != nil{
                message = (dataDicty?["Message"])!
            }
            
        print("401 - \(dataDicty)")
        }
        else{
            
        }
        
        if self.delegate != nil{
            
            self.delegate?.unauthorized(alert: message)
        }
        
        
    }
    
    func otherError(data:Data) {
        
        guard let dataDicty: [String:String]? = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : String] else {return}
        print("otherError - \(dataDicty)")

        var message = "Some Error Occured"
        
        if dataDicty != nil {
            if (dataDicty?["Response"]) != nil{
                message = (dataDicty?["Response"])!
            }
            else if (dataDicty?["Message"]) != nil{
                message = (dataDicty?["Message"])!
            }
            
            print("otherError - \(dataDicty)")
        }
        else{
            print("response - \(String(data: data, encoding: .utf8))")
            
            guard let text = String(data: data, encoding: .utf8) else {return}
            
            if let data = text.data(using: .utf8){
                var dict:Dictionary<String, Any>?
                do{
                    dict = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>
                    
                    if dict != nil {
                        
                        if (dict?["Response"]) != nil{
                            
                            if let dictRes = dict?["Response"] as? [String : String]{
                            
                                if dictRes["Message"] != nil{
                                    message = dictRes["Message"]!
                                }
                            }
                        }
                        else if (dict?["Message"]) != nil{
                            message = (dict?["Message"])! as! String
                        }
                    }
                    
                } catch let error{
                    
                    print(error)
                }
                
            }
        }
        
        if self.delegate != nil{
            
            self.delegate?.otherError(alert: message)
        }
        
    }
    
    func otherErrorDescription(error:Error) {
        
        
        var message = "Some Error Occured"
        
        if error != nil{
            message = error.localizedDescription
        }
        
        
        if self.delegate != nil{
            
            self.delegate?.otherError(alert: message)
        }
        
    }
    
}


private class HttpRequest: NSObject {
    var serverResponseCode: ServerCodes!
    var data: Data!
    var delegate: ServiceHandler!
    var serviceName: ServiceNames!
    
    
    override init() {
        super.init()
    }
    
    func establishConnectionWithReqString(_ dictRequest:[String:AnyObject], Delegate delegate: ServiceHandler, serviceNum name: ServiceNames)
    {
        self.delegate = delegate
        self.serviceName = name
        
        let reqUrl: URL = self.generateRequestUrlWith(controllerAndActionString: name.rawValue)
        
        var request: URLRequest = URLRequest(url: reqUrl, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 60)
        do{
        var requestData = try JSONSerialization.data(withJSONObject: dictRequest, options: [])
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(format: "%lu", requestData.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = requestData
        print("Request - \(dictRequest)")
        URLSession.shared.dataTask(with: request) { (dataReceived, responseReceived, ErrorGot) in
            
            print("response code = \((responseReceived as! HTTPURLResponse).statusCode)")
            print("response - \(responseReceived)")
            print("ErrorGot - \(ErrorGot)")
            self.serverResponseCode = ServerCodes(rawValue: (responseReceived as! HTTPURLResponse).statusCode)

            switch self.serverResponseCode {
                
            case .OK?:
                if dataReceived != nil {
                    let response: WebResponse = WebResponse()
                    response.data = dataReceived
                    response.isError = false
                    response.serviceName = self.serviceName
                    
                    if self.delegate != nil && self.delegate.responds(to: #selector(self.delegate.responseReceived(_:))) {
                        self.delegate.performSelector(onMainThread: #selector(self.delegate.responseReceived(_:)), with: response, waitUntilDone: true)
                    }
                } else {
                    print("data is nil")
                }
                
            /*case .InternalServerError?:
                if self.delegate != nil && self.delegate.responds(to: #selector(self.delegate.internalServerError)) {
                    self.delegate.performSelector(onMainThread: #selector(self.delegate.internalServerError), with: nil, waitUntilDone: true)
                }
                
            case .GatewayTimeout?:
                if self.delegate != nil && self.delegate.responds(to: #selector(self.delegate.showTimeOutError))
                {
                    self.delegate.performSelector(onMainThread: #selector(self.delegate.showTimeOutError), with: nil, waitUntilDone: true)
                }
                
            case .BadRequest?:
                if self.delegate != nil && self.delegate.responds(to: #selector(self.delegate.BadRequestError400)) {
                    self.delegate.performSelector(onMainThread: #selector(self.delegate.BadRequestError400), with: nil, waitUntilDone: true)
                }*/
            case .Unauthorized?:
                if self.delegate != nil && self.delegate.responds(to: #selector(self.delegate.UnAuthorized401(_ :))) {
                    self.delegate.performSelector(onMainThread: #selector(self.delegate.UnAuthorized401(_ :)), with: dataReceived, waitUntilDone: true)
                }
                
                
                
            default:
                if dataReceived != nil{
                    self.delegate.otherError(data: dataReceived!)
                    return
                }
                
                if ErrorGot != nil{
                    self.delegate.otherErrorDescription(error: ErrorGot!)

                }
               /* if self.delegate != nil && self.delegate.responds(to: #selector(self.delegate.otherError())) {
                    self.delegate.performSelector(onMainThread: #selector(self.delegate.otherError(_ :)), with: dataReceived, waitUntilDone: true)
                }*/
                print("Error - \(ErrorGot?.localizedDescription)")
                print("found new response code = \(self.serverResponseCode)")
                
            }
            
            }.resume()
        }
        catch{
            print(error.localizedDescription)
        }
        
    }
    
    private func generateRequestUrlWith(controllerAndActionString: String) -> URL
    {
        let url: URL = URL(string: (NetworkUtil.serviceUrl + controllerAndActionString).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        return url
    }
    
}

private class WebResponse: NSObject {
    
    var isError: Bool = false
    var serviceName: ServiceNames!
    var data: Data!
    
    override init() {
        super.init()
        
    }
    
}
enum ServerCodes: Int {
    
    case Continue = 100
    case SwitchingProtocols = 101
    case OK = 200
    case Created = 201
    case Accepted = 202
    case NonAuthoritativeInformation = 203
    case NoContent = 204
    case ResetContent = 205
    case PartialContent = 206
    case MultipleChoices = 300
    case MovedPermanently = 301
    case Found = 302
    case SeeOther = 303
    case NotModified = 304
    case UseProxy = 305
    case Unused = 306
    case TemporaryRedirect = 307
    case BadRequest = 400
    case Unauthorized = 401
    case PaymentRequired = 402
    case Forbidden = 403
    case NotFound = 404
    case MethodNotAllowed = 405
    case NotAcceptable = 406
    case ProxyAuthenticationRequired = 407
    case RequestTimeout = 408
    case Conflict = 409
    case Gone = 410
    case LengthRequired = 411
    case PreconditionFailed = 412
    case RequestEntityTooLarge = 413
    case RequestURLTooLong = 414
    case UnsupportedMediaType = 415
    case RequestedRangeNotSatisfiable = 416
    case ExpectationFailed = 417
    case InternalServerError = 500
    case NotImplemented = 501
    case BadGateway = 502
    case ServiceUnavailable = 503
    case GatewayTimeout = 504
    case HTTPVersionNotSupported = 505
}
