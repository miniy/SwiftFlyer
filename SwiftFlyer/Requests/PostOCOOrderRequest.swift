//
//  PostOCOOrderRequest.swift
//  SwiftFlyer
//
//  Created by Ryo Ishikawa on 2018/01/28.
//  Copyright © 2017 Ryo Ishikawa. All rights reserved.
//

import Foundation

@available(iOS 11.0, *)
public final class PostOCOOrderRequest: Requestable {
    
    public typealias Response = ParentOrderResult
    
    public var path: String {
        return "/v1/me/sendparentorder"
    }
    
    public var httpMethod: HTTPMethod {
        return .post
    }
    
    public var isAuthorizedRequest: Bool {
        return true
    }
    
    public var httpBody: Data? {
        var json: [String: Any] = [:]
        
        json.appendingQueryParameter(key: "order_method", value: ParentOrderType.oco)
        json.appendingQueryParameter(key: "minute_to_expire", value: minuteToExpire)
        json.appendingQueryParameter(key: "time_in_force", value: timeInForce)
        
        let parameters = orders.map { order -> [String: Any] in
            var parameter: [String: Any] = [:]
            
            parameter.appendingQueryParameter(key: "product_code", value: order.productCode)
            parameter.appendingQueryParameter(key: "condition_type", value: order.conditionType)
            parameter.appendingQueryParameter(key: "side", value: order.side)
            parameter.appendingQueryParameter(key: "price", value: order.price)
            parameter.appendingQueryParameter(key: "trigger_price", value: order.triggerPrice)
            parameter.appendingQueryParameter(key: "offset", value: order.offset)
            parameter["size"] = "\(order.size)"

            return parameter
        }
        
        json["parameters"] = parameters
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys])
        
        return jsonData
    }
    
    public let orders: [Order]
    public let minuteToExpire: Int?
    public let timeInForce: TimeInForce?
    
    public init(orders: [Order],
                minuteToExpire: Int? = nil,
                timeInForce: TimeInForce? = nil
        ) {
        self.orders = orders
        self.minuteToExpire = minuteToExpire
        self.timeInForce = timeInForce
    }
}

