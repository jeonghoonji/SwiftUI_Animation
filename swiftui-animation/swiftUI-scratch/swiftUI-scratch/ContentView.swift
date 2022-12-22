//
//  ContentView.swift
//  swiftUI-scratch
//
//  Created by 지정훈 on 2022/12/22.
//

import SwiftUI

struct ContentView: View {
    @State var onFinish: Bool = false
    
    var body: some View {
        VStack {
            
            
            ScratchCardView(cursorSize: 50, onFinish: $onFinish) {
                
                VStack{
                    Image("image2")
                }
                
                
            } overlayView: {        //overlayView 위에 띄워주는 쪽 같음
                Image("image1")     //image1아직 긁지 않은 복권 이미지
            }
            
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//오우... 아직은 이해할 수가 없음
struct ScratchCardView<Content: View,overlayImage: View>: View{
    var content : Content
    var overlayView: overlayImage
    
    
    init(cursorSize: CGFloat,onFinish: Binding<Bool> ,@ViewBuilder content: @escaping() -> Content,@ViewBuilder overlayView: @escaping() -> overlayImage) {
        self.content = content()
        self.overlayView = overlayView()
        self.cursorSize = cursorSize
        self._onFinish = onFinish
        
    }
    
    //제스처를 시작할때 제로값으로 시작
    @State var startingPoint: CGPoint = .zero
    
    // 제스처의 좌표값들을 저장
    @State var points: [CGPoint] = []
    
    
    //제스처의 좌표값을 받아져올 수 있게 해주는 거 같음
    @GestureState var gestureLocation: CGPoint = .zero
    
    var cursorSize: CGFloat
    
    @Binding var onFinish: Bool
    
    var body: some View{
        ZStack{
            overlayView
                .opacity(onFinish ? 0 : 1  )
            content
                .mask(
                    ZStack{
                        if !onFinish{
                            // 좌표대로 긁어주는 선
                            SratchMask(points: points, startingPoint: startingPoint)
                                .stroke(style: StrokeStyle(lineWidth: cursorSize,lineCap: .round, lineJoin: .round))
                        }else{
                            Rectangle()
                        }
                    }
                    
                )
                .gesture(
                    // 화면 좌표를 가져오는거 같음
                    DragGesture()
                        .updating($gestureLocation, body: { value, out, _ in
                            out = value.location
                            DispatchQueue.main.async{
                                if startingPoint == .zero{
                                    startingPoint == value.location
                                }
                                
                                points.append(value.location)
                                print(points)
                            }
                        })
                        .onEnded({ value in
                            withAnimation {
                                onFinish = true
                            }
                        })
                )
            
               
        }.frame(width: 300,height: 300)
            .cornerRadius(20)
    }
    func resetView(){
        points.removeAll()
        startingPoint = .zero
        
    }
}

struct SratchMask: Shape{
    var points: [CGPoint]
    var startingPoint: CGPoint
    
    func path(in rect: CGRect) -> Path {
        
        //startingPoint부터 points 계속 좌표별로 이어서 그려주는 거 같음
        return Path{ path in
            path.move(to:startingPoint)
            path.addLines(points)
            
        }
        
    }
}
