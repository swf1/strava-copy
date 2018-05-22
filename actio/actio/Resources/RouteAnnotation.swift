//
//  RouteAnnotation.swift
//  actio
//
//  Created by Jason Hoffman on 5/18/18.
//  Copyright © 2018 corvus group. All rights reserved.
//

import Mapbox

class RouteAnnotation: MGLAnnotationView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2  // round
    }
}


