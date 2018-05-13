//
//  APIService.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 12/26/17.
//  Copyright © 2017 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation
import Alamofire

typealias LoginHandler = (_ success:User?,_ error:String) ->Void
typealias ChangePasswordHandler = (_ success:Bool,_ error:String) ->Void
typealias RecoveryPasswordHandler = (_ success:Bool,_ error:String) ->Void
typealias RegisterHanlder = (_ success:Bool,_ data:User?,_ message:String) -> Void
typealias GetServiceGroupsHandler = (_ success:[ServiceGroup]?,_ error:String) ->Void
typealias GetServicesHandler = (_ success:[Service]?,_ error:String) ->Void
typealias GetServiceDetailsHandler = (_ success:[ServiceDetails]?,_ error:String) ->Void
typealias GetOrdersHandler = (_ success:[Order]?,_ maxRows:Int,_ error:String) ->Void
typealias GetOrderDetailsHandler = (_ success:Bool,_ orderDetails:[OrderDetails]?,_ error:String) ->Void
typealias ReuseOrderDetailsHandler = (_ success:Bool, _ OrderDetails:[OrderDetails], _ message:String) -> ()
typealias SaveOrderHanlder = (_ success:Bool, _ message:String) -> ()
typealias GetMessagesHandler = (_ success:[Message]?,_ maxRows:Int,_ error:String) ->Void
typealias GetMessageSummaryHandler = (_ success:Bool,_ summary:MessageSummary?,_ message:String) -> ()
typealias UpdateMessageStatusHandler = (_ returnCode:Int,_ returnMessage:String) -> ()

class APIService {
    
    static let serviceUrl: String = "http://locnp.ddns.net/api";
    
    static let headers: HTTPHeaders = [
        "Authorization": "Basic bGV0bWV3YXNoOmxldG1ld2FzaEBBcGkxMjM=",
        "Accept": "application/json"
    ]
    
    
    /**
        Verify user
     */
    class func login(phone:String, password:String, handler: @escaping LoginHandler) {
        let url = serviceUrl + "/Customer/verify"
        print("Request: \(url)")
        let params:[String:String] = [
            "phone": phone,
            "password": password
        ]
        Alamofire
            .request(url, method: .post, parameters: params, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(nil, "Đăng nhập thất bại! (1)")
                        break
                    }
                    guard let success = results.object(forKey: "Success") as? Bool else {
                        handler(nil, "Đăng nhập thất bại! (2)")
                        break
                    }
                    if success {
                        guard let data = results.object(forKey: "Data") as? NSDictionary else {
                            handler(nil, "Đăng nhập thất bại (3)")
                            break
                        }
                        guard let user = User.fromDictionary(dict: data) else {
                            handler(nil, "Đăng nhập thất bại (3)")
                            break
                        }
                        // Success
                        handler(user, "Đăng nhập thành công!")
                        
                    } else {
                
                        // Fail
                        handler(nil, (results.object(forKey: "Data") as? String) ?? "Đăng nhập thất bại (3)")
                    }
                    break
                case .failure(let error):
                    handler(nil, "Đăng nhập thất bại! (4) \(error)")
                }
        }
    }
    
    /**
        Change password api
     */
    class func changePass(phone:String, currentPass:String, newPass:String, handler: @escaping ChangePasswordHandler) {
        let url = serviceUrl + "/Customer/changePassword"
        print("Request: \(url)")
        let params:[String:String] = [
            "phone": phone,
            "passwordCurrent": currentPass,
            "password": newPass
        ]
        Alamofire
            .request(url, method: .post, parameters: params, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(false, "Đăng nhập thất bại! (1)")
                        break
                    }
                    guard let success = results.object(forKey: "Success") as? Bool else {
                        handler(false, "Đăng nhập thất bại! (2)")
                        break
                    }
                    if success {
                        handler(true, "Đổi mật khẩu thành công!")
                    } else {
                        handler(false, "Đổi mật khẩu thất bại (3)")
                    }
                    break
                case .failure(let error):
                    handler(false, "Đổi mật khẩu thất bại \(error)")
                }
        }
    }
    
    /**
        Recovery password
     */
    class func recoveryPassword(phone:String, email:String, handler: @escaping RecoveryPasswordHandler) {
        let url = serviceUrl + "/Customer/RecoveryPassword"
        print("Request: \(url)")
        let params:[String:String] = [
            "phone": phone,
            "email": email
        ]
        Alamofire
            .request(url, method: .post, parameters: params, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(false, "Khôi phục mật khẩu thất bại (1)")
                        break
                    }
                    guard let success = results.object(forKey: "Success") as? Bool else {
                        handler(false, "Khôi phục mật khẩu thất bại (2)")
                        break
                    }
                    guard let message = results.object(forKey: "Data") as? String else {
                        handler(false, "Khôi phục mật khẩu thất bại (3)")
                        break
                    }
                    handler(success, message)
                    break
                case .failure(let error):
                    handler(false, "Đổi mật khẩu thất bại \(error)")
                }
        }
    }

    
    /**
        Register new customer
     */
    class func register(fullname:String, phone:String, password:String, email:String, handler: @escaping RegisterHanlder) {
        let url = serviceUrl + "/Customer/register"
        print("Request: \(url)")
        let params:[String:String] = [
            "fullname": fullname,
            "phone": phone,
            "password": password,
            "email": email
        ]
        Alamofire
            .request(url, method: .post, parameters: params, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(false, nil, "Đăng ký tài khoản thất bại (1)")
                        break
                    }
                    guard let success = results.object(forKey: "Success") as? Bool else {
                        handler(false, nil, "Đăng ký tài khoản thất bại! (2)")
                        break
                    }
                    if success {
                        // Get user info
                        let user = User(phone: phone, fullname: fullname, email: email, address: "")
                        handler(true, user, "Đăng ký tài khoản thành công!")
                    
                    } else {
                        let message = results.object(forKey: "Data") as? String
                        handler(false, nil, message ?? "Đăng ký tài khoản thất bại! (3)")
                    }
                    break
                case .failure(let error):
                    handler(false, nil, "Đăng ký tài khoản thất bại \(error)")
                }
        }
    }
    
    /**
        Make request to server to get service groups
     */
    class func getServiceGroups(handler: @escaping GetServiceGroupsHandler) {
        let url = serviceUrl + "/Service/getServiceGroups"
        print("Request: \(url)")
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(nil, "Nạp dữ liệu thất bại! (1)")
                        break
                    }
                    guard let _ = results.object(forKey: "Success") as? Bool else {
                        handler(nil, "Nạp dữ liệu thất bại! (2)")
                        break
                    }
                    
                    guard let data = results.object(forKey: "Data") as? NSArray else {
                        handler(nil, "Nạp dữ liệu thất bại! (3)")
                        break
                    }
                    
                    let groups = ServiceGroup.fromArray(arr: data)
                    handler(groups, "Nạp danh sách nhóm dịch vụ thành công!")
                    
                case .failure(let error):
                    handler(nil, "Nạp dữ liệu thất bại! (4) \(error)")
                }
        }
    }
    
    /**
        Make request to server to get services
     */
    class func getServices(groupId:Int, handler: @escaping GetServicesHandler) {
        let url = serviceUrl + "/Service/getServices?groupId=\(groupId)"
        print("Request: \(url)")
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(nil, "Nạp dữ liệu thất bại! (1)")
                        break
                    }
                    guard let _ = results.object(forKey: "Success") as? Bool else {
                        handler(nil, "Nạp dữ liệu thất bại! (2)")
                        break
                    }
                    
                    guard let data = results.object(forKey: "Data") as? NSArray else {
                        handler(nil, "Nạp dữ liệu thất bại! (3)")
                        break
                    }
                    
                    let services = Service.fromArray(arr: data)
                    handler(services, "Nạp danh sách dịch vụ thành công!")
                    
                case .failure(let error):
                    handler(nil, "Nạp dữ liệu thất bại! (4) \(error)")
                }
        }
    }
    
    /**
        Make request to server to get service details
    */
    class func getServiceDetails(serviceId:Int, handler: @escaping GetServiceDetailsHandler) {
        let url = serviceUrl + "/Service/getServiceDetails?serviceId=\(serviceId)"
        print("Request: \(url)")
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(nil, "Nạp dữ liệu thất bại! (1)")
                        break
                    }
                    guard let _ = results.object(forKey: "Success") as? Bool else {
                        handler(nil, "Nạp dữ liệu thất bại! (2)")
                        break
                    }
                    
                    guard let data = results.object(forKey: "Data") as? NSArray else {
                        handler(nil, "Nạp dữ liệu thất bại! (3)")
                        break
                    }
                    
                    let serviceDetails = ServiceDetails.fromArray(arr: data)
                    handler(serviceDetails, "Nạp chi tiết dịch vụ thành công!")
                    
                case .failure(let error):
                    handler(nil, "Nạp dữ liệu thất bại! (4) \(error)")
                }
        }
    }
    
    /**
     *  Nạp danh sách đơn hàng
     */
    class func getOrders(phone:String, skip:Int, take:Int, handler: @escaping GetOrdersHandler) {
        let url = serviceUrl + "/Order/getOrders?phone=\(phone)&skip=\(skip)&take=\(take)"
        print("Request: \(url)")
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(nil, 0, "Nạp dữ liệu thất bại! (1)")
                        break
                    }
                    guard let _ = results.object(forKey: "Success") as? Bool else {
                        handler(nil, 0, "Nạp dữ liệu thất bại! (2)")
                        break
                    }
                    
                    guard let data = results.object(forKey: "Data") as? NSArray else {
                        handler(nil, 0, "Nạp dữ liệu thất bại! (3)")
                        break
                    }
                    
                    let orders = Order.fromArray(arr: data)
                    let maxRows = results.object(forKey: "MaxRows") as? Int
                    handler(orders, maxRows ?? 0, "Nạp danh sách đơn hàng thành công!")
                    
                case .failure(let error):
                    handler(nil, 0, "Nạp dữ liệu thất bại! (4) \(error)")
                }
        }
    }
    
    /**
     *  Nạp chi tiết đơn hàng
     */
    class func getOrderDetails(orderId:Int, handler: @escaping GetOrderDetailsHandler) {
        let url = serviceUrl + "/Order/getOrderDetails?orderId=\(orderId)"
        print("Request: \(url)")
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(false, nil, "Nạp dữ liệu thất bại! (1)")
                        break
                    }
                    guard let success = results.object(forKey: "Success") as? Bool else {
                        handler(false, nil, "Nạp dữ liệu thất bại! (2)")
                        break
                    }
                    if success {
                        // Success
                        guard let data = results.object(forKey: "Data") as? NSArray else {
                            handler(false, nil, "Nạp dữ liệu thất bại! (4)")
                            break
                        }
                        let orderDatails = OrderDetails.fromArray(arr: data)
                        handler(true, orderDatails, "Nạp danh sách chi tiết đơn hàng thành công!")
                    } else {
                        // Fail
                        let message = results.value(forKey: "Data") as? String
                        handler(false, nil, "Nạp dữ liệu thất bại! (3) \(message ?? "")")
                    }
                    break
    
                case .failure(let error):
                    handler(false, nil, "Nạp dữ liệu thất bại! (5) \(error)")
                }
        }
    }
    
    /**
     *  Sử dụng lại chi tiết đơn hàng
     */
    class func reuseOrder(orderId:Int, handler: @escaping ReuseOrderDetailsHandler) {
        let url = serviceUrl + "/Order/reuseOrderDetails?orderId=\(orderId)"
        print("Request: \(url)")
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(false, [], "Nạp dữ liệu thất bại! (1)")
                        break
                    }
                    guard let success = results.object(forKey: "Success") as? Bool else {
                        handler(false, [], "Nạp dữ liệu thất bại! (2)")
                        break
                    }
                    if success {
                        // Success
                        guard let data = results.object(forKey: "Data") as? NSArray else {
                            handler(false, [], "Nạp dữ liệu thất bại! (4)")
                            break
                        }
                        let orderDatails = OrderDetails.fromArray(arr: data)
                        handler(true, orderDatails, "Sử dụng lại chi tiết đơn hàng thành công!")
                    } else {
                        // Fail
                        let message = results.value(forKey: "Data") as? String
                        handler(false, [], "Nạp dữ liệu thất bại! (3) \(message ?? "")")
                    }
                    break
                    
                case .failure(let error):
                    handler(false, [], "Nạp dữ liệu thất bại! (5) \(error)")
                }
        }
    }
    
    /**
        Lưu đơn hàng
     */
    class func saveOrder(phone:String, fullname:String, address:String, note:String, serviceBookings:[ServiceBooking], handler: @escaping SaveOrderHanlder) {
        let url = serviceUrl + "/Order/save"
        print("Request: \(url)")
        var jsonServiceBookingString = ""
        jsonServiceBookingString += "[\n"
        for index in 0..<serviceBookings.count {
            let sb = serviceBookings[index]
            jsonServiceBookingString += "\t{\n"
            jsonServiceBookingString += "\t\t\"bookType\": 0,\n"
            jsonServiceBookingString += "\t\t\"groupId\":\"\(sb.groupId)\",\n"
            jsonServiceBookingString += "\t\t\"groupName\":\"\(sb.groupName)\",\n"
            jsonServiceBookingString += "\t\t\"serviceId\":\"\(sb.serviceId)\",\n"
            jsonServiceBookingString += "\t\t\"serviceName\":\"\(sb.serviceName)\",\n"
            jsonServiceBookingString += "\t\t\"totalAmount\": \(sb.totalAmount),\n"
            jsonServiceBookingString += "\t\t\"discountAmount\": \(sb.discountAmount),\n"
            jsonServiceBookingString += "\t\t\"paymentAmount\": \(sb.paymentAmount),\n"
            jsonServiceBookingString += "\t\t\"details\": [\n"
            for index2 in 0..<sb.details.count {
                let item = sb.details[index2]
                jsonServiceBookingString += "\t\t\t{\n"
                jsonServiceBookingString += "\t\t\t\t\"itemId\": \(item.itemId ?? 0),\n"
                jsonServiceBookingString += "\t\t\t\t\"itemName\": \"\(item.itemName ?? "")\",\n"
                jsonServiceBookingString += "\t\t\t\t\"unit\": \"\(item.unit ?? "")\",\n"
                jsonServiceBookingString += "\t\t\t\t\"price\": \(item.price ),\n"
                jsonServiceBookingString += "\t\t\t\t\"priceOriginal\": \(item.priceOriginal )\n"
                jsonServiceBookingString += index2 < sb.details.count - 1 ? "\t\t\t},\n" : "\t\t\t}\n"
            }
            jsonServiceBookingString += "\t\t]\n"
            jsonServiceBookingString += index < serviceBookings.count - 1 ? "\t},\n" : "\t}\n"
        }
        jsonServiceBookingString += "]"
        
        print(jsonServiceBookingString)
        
        // convert String to NSData and NSData to AnyObject
        let data:NSData = jsonServiceBookingString.data(using: String.Encoding.utf8)! as NSData
        let jsonServiceBookings: AnyObject? = try? JSONSerialization.jsonObject(with: data as Data, options: []) as AnyObject
        
        let params:[String:Any] = [
            "phone": phone,
            "fullname": fullname,
            "address": address,
            "note": note,
            "serviceBookings": jsonServiceBookings ?? []
        ]
        
        Alamofire
            .request(url, method: .post, parameters: params, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(false, "Lưu đơn hàng thất bại (1)")
                        break
                    }
                    guard let success = results.object(forKey: "Success") as? Bool else {
                        handler(false, "Lưu đơn hàng thất bại (2)")
                        break
                    }
                    guard let message = results.object(forKey: "Data") as? String else {
                        handler(false, "Lưu đơn hàng thất bại (3)")
                        break
                    }
                    handler(success, message)
                    break
                case .failure(let error):
                    handler(false, "Lưu đơn hàng thất bại! \(error)")
                }
        }

    }
    
    /**
     * Nạp danh sách thông báo
     **/
    class func getMessages(phone:String, skip:Int, take:Int, handler: @escaping GetMessagesHandler) {
        let url = serviceUrl + "/Message/getMessages?phone=\(phone)&skip=\(skip)&take=\(take)"
        print("Request: \(url)")
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(nil, 0, "Nạp dữ liệu thất bại! (1)")
                        break
                    }
                    guard let _ = results.object(forKey: "Success") as? Bool else {
                        handler(nil, 0, "Nạp dữ liệu thất bại! (2)")
                        break
                    }
                    
                    guard let data = results.object(forKey: "Data") as? NSArray else {
                        handler(nil, 0, "Nạp dữ liệu thất bại! (3)")
                        break
                    }
                    
                    let messages = Message.fromArray(arr: data)
                    let maxRows = results.object(forKey: "MaxRows") as? Int
                    handler(messages, maxRows ?? 0, "Nạp danh sách thông báo thành công!")
                    
                case .failure(let error):
                    handler(nil, 0, "Nạp dữ liệu thất bại! (4) \(error)")
                }
        }
    }
    
    /**
     * Thống kê trạng thái tin
     **/
    class func getMessageSummary(phone:String, handler: @escaping GetMessageSummaryHandler) {
        let url = serviceUrl + "/Message/getCustomerMessageSummary?phone=\(phone)"
        print("Request: \(url)")
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(false, nil, "Nạp dữ liệu thất bại! (1)")
                        break
                    }
                    guard let success = results.object(forKey: "Success") as? Bool else {
                        handler(false, nil, "Nạp dữ liệu thất bại! (2)")
                        break
                    }
                    if success {
                        let data = results.object(forKey: "Data") as? NSDictionary
                        let summary = MessageSummary.fromDictionary(dict: data!)
                        handler(true, summary, "Nạp dữ liệu thành công!")
                    } else {
                        let message = results.object(forKey: "Data") as? String ?? "Nạp dữ liệu thất bại! (3)"
                        handler(false, nil, message)
                    }
                case .failure(let error):
                    handler(false, nil, "Nạp dữ liệu thất bại! (4) \(error)")
                }
        }
    }
    
    /**
     * Thống kê trạng thái tin
     **/
    class func updateMessageStatus(messageId:Int, status:Int, handler: @escaping UpdateMessageStatusHandler) {
        let url = serviceUrl + "/Message/updateMessageStatus?messageId=\(messageId)&status=\(status)"
        print("Request: \(url)")
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let results = response.result.value as? NSDictionary else {
                        handler(1, "Nạp dữ liệu thất bại! (1)")
                        return
                    }
                    guard let success = results.object(forKey: "Success") as? Bool else {
                        handler(2, "Nạp dữ liệu thất bại! (2)")
                        return
                    }
                    if success {
                        guard let data = results.object(forKey: "Data") as? NSDictionary else {
                            handler(3, "Nạp dữ liệu thất bại! (3)")
                            return
                        }
                        let returnCode = data.object(forKey: "ReturnCode") as? Int ?? 1000
                        let returnMessage = data.object(forKey: "ReturnMessage") as? String ?? "Nạp dữ liệu thất bại! (4)"
                        handler(returnCode, returnMessage)
                    } else {
                        let message = results.object(forKey: "Data") as? String ?? "Nạp dữ liệu thất bại! (3)"
                        handler(3, message)
                    }
                case .failure(let error):
                    handler(4, "Nạp dữ liệu thất bại! (4) \(error)")
                }
        }
    }
}
