//
//  ContentView.swift
//  swiftui-animations-island
//
//  Created by 지정훈 on 2022/12/15.
//

import SwiftUI
import MapKit


import SwiftUI
import CoreLocationUI
import MapKit

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    // 원을 보여줄지 결정하는 Bool값
    @State private var animateSmallCircle = false
    @State private var animateLargeCircle = false
    
    // 현재위치 버튼을 누를때 Circle()을 보여주게 만듬
    @State var circleShowBool : Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: 맵 부분
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            //
            if circleShowBool {
                Circle() // Large circle: Scale and opacity animations
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color(#colorLiteral(red: 0.1232414171, green: 0.5427253246, blue: 0.9920887351, alpha: 1)))
                    .opacity(animateLargeCircle ? 0: 0.5)
                    .scaleEffect(animateLargeCircle ? 1.4 : 0)
                    .offset(y: -330)
                    //easeOut 빠른 속도로 애니메이션을 시작 애니메이션 끝에 다다를수록 점점 느려짐
                    .animation(Animation.easeOut(duration: 1).delay(1).repeatCount(1, autoreverses: false))
//                    .animation(Animation.easeOut(duration: 1).delay(1).repeatForever(autoreverses: false))
                    .onAppear(){
                        self.animateLargeCircle.toggle()
                    }
                
//                Circle() // Small circle: Scale animation
//                    .frame(width: 14, height: 14)
//                    .foregroundColor(Color(#colorLiteral(red: 0.1232414171, green: 0.5427253246, blue: 0.9920887351, alpha: 1)))
//                    .scaleEffect(animateSmallCircle ? 0.8 : 1.4)
//                    .offset(y: -300)
//                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
//                    .onAppear(){
//                        self.animateSmallCircle.toggle()
//                    }
            }

            VStack {
                Spacer()
                LocationButton {
                    //현재 위치를 보여지게 만들어줌
                    locationManager.requestLocation()
                    circleShowBool.toggle()
                }
                .frame(width: 180, height: 40)
                .cornerRadius(30)
                .symbolVariant(.fill)
                .foregroundColor(.white)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

