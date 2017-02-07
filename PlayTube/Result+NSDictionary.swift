//
//  Result+NSDictionary.swift
//  PlayTube
//
//  Created by Adnan Basar on 12/01/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation
import Result

public typealias JSONObject = Dictionary<String,Any>
public typealias JSONArray = Array<JSONObject>

public typealias RSLT = Result<JSONObject,AnyError>
