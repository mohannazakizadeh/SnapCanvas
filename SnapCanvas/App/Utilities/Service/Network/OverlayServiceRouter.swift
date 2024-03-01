//
//  OverlayServiceRouter.swift
//  SnapCanvas
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import Foundation
import NetworkingInterface

final class OverlayServiceRouter: NetworkingRouterProtocol {
    var method: HTTPMethod {
        .get
    }

    var path: String {
        return "overlays"
    }
}
