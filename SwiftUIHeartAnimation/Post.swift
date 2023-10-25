//
//  Post.swift
//  SwiftUIHeartAnimation
//
//  Created by Kaori Persson on 2023-10-25.
//

import SwiftUI

struct Post: Identifiable {
  var id = UUID().uuidString
  var imageName: String
  var isLiked: Bool = false
}
