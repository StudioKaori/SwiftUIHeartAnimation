//
//  Home.swift
//  SwiftUIHeartAnimation
//
//  Created by Kaori Persson on 2023-10-25.
//

import SwiftUI

struct Home: View {
  var body: some View {
    NavigationView {
      
    }
  }
}

#Preview {
  ContentView()
}

struct HeartLike: View {
  @State var isTapped: Bool = false
  @State var startAnimation = false
  @State var bgAnimation = false
  @State var resetBg = false
  @State var fireworkAnimation = false
  @State var animationEnded = false
  
  // to avoid tap during animation
  @State var tapComplete = false
  
  var body: some View {
    Image(systemName: resetBg ? "suit.heart.fill" : "suit.heart")
      .font(.system(size: 46))
      .foregroundColor(resetBg ? .red : .gray)
      .scaleEffect(startAnimation && !resetBg ? 0 : 1)
      .background(
        ZStack {
          CustomShape(radius: resetBg ? 29 : 0)
            .fill(Color.purple)
            .clipShape(Circle())
            .frame(width: 50, height: 50)
            .scaleEffect(bgAnimation ? 2.2 : 0)
          
          ZStack {
            // rondom colors
            let colors: [Color] = [.red, .purple, .green, .yellow, .pink]
            
            ForEach(1...6, id: \.self) { index in
              Circle()
                .fill(colors.randomElement()!)
                .frame(width: 12, height: 12)
                .offset(x: fireworkAnimation ? 80 : 40)
                .rotationEffect(.init(degrees: Double(index) * 60))
            }
            
            ForEach(1...6, id: \.self) { index in
              Circle()
                .fill(colors.randomElement()!)
                .frame(width: 8, height: 8)
                .offset(x: fireworkAnimation ? 64 : 24)
                .rotationEffect(.init(degrees: Double(index) * 60))
              //.rotationEffect(.init(degrees: -45))
            }
            
          }
        }
          .opacity(resetBg ? 1 : 0)
          .opacity(animationEnded ? 0 : 1)
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      .contentShape(Rectangle())
      .onTapGesture {
        if tapComplete {
          // reset back
          startAnimation = false
          bgAnimation = false
          resetBg = false
          fireworkAnimation = false
          animationEnded = false
          tapComplete = false
          return
        }
        
        if startAnimation {
          return
        }
        
        isTapped = true
        
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
          startAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
          withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
            bgAnimation = true
          }
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
              resetBg = true
            }
            
            // firework
            withAnimation(.spring()) {
              fireworkAnimation = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
              withAnimation(.easeOut(duration: 0.4)) {
                animationEnded = true
              }
              
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                tapComplete = true
              }
              
            }
          }
        }
      }
  }
}

struct CustomShape: Shape {
  var radius: CGFloat
  
  // animation path won't work in preview
  //  var animatableData: CGFloat {
  //    get { return radius}
  //    set { radius = newValue }
  //  }
  
  func path(in rect: CGRect) -> Path {
    return Path { path in
      path.move(to: CGPoint(x: 0, y: 0))
      path.addLine(to: CGPoint(x: 0, y: rect.height))
      path.addLine(to: CGPoint(x: rect.width, y: rect.height))
      path.addLine(to: CGPoint(x: rect.width, y: 0))
      
      // add center circle
      let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
      path.move(to: center)
      path.addArc(center: center, radius: radius, startAngle: .zero, endAngle: .init(degrees: 360), clockwise: false)
    }
  }
}
