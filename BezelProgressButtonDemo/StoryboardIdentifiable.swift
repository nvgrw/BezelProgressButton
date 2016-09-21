//
//  StoryboardIdentifiable.swift
//  BezelProgressButton
//
//  Created by Nik on 20/09/2016.
//  Copyright © 2016 Niklas Vangerow. All rights reserved.
//

import Foundation

/// Implemented by view controllers so that they can be identified
protocol StoryboardIdentifiable {
    static var identifier: String { get }
}
