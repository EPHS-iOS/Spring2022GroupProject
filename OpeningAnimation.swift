struct animationScreen: View{
   
    // Will need some padding
  fileprivate struct square: View{
    fileprivate var color: Color
    var body: some View{
      Rectangle().aspectRatio(1, contentMode: .fit).frame(width: 100, height: 100, alignment: .center).foregroundColor(color).overlay{
        Rectangle().stroke(lineWidth: 2).aspectRatio(1, contentMode: .fit).frame(width: 100, height: 100, alignment: .center).foregroundColor(Color.black)
      }
    }
  }
   
  @State fileprivate var rotation: Double
  @State fileprivate var rotToAchieve: Double
  fileprivate var x: Int
  fileprivate var y: Int
   
  fileprivate var timings: [Double]
   
 
  init(animationTimings t: [Double] = [1.5, 1.8, 2.0], offsetX x: Int = 20, offsetY y: Int = 25, originalRotation r: Double = 45, rotationToAchieve rt: Double = 180+45){
     
    self.timings = t
    self.x = x
    self.y = y
    self.rotation = r
    self.rotToAchieve = rt
     
  }
  var body: some View{
    ZStack{
      square(color: Color.black)
        .rotationEffect(.degrees(rotation), anchor: .center)
        .animation(Animation.easeInOut(duration: timings[0]), value: rotation)
      ZStack{
        square(color: Color.white)
          .rotationEffect(.degrees(rotation), anchor: .center)
          .animation(Animation.easeInOut(duration: timings[1]), value: rotation)
      }.offset(x: CGFloat(x), y: CGFloat(y))
      ZStack{
        square(color: Color(hexString: "c94848"))
          .rotationEffect(.degrees(rotation), anchor: .center)
          .animation(Animation.easeInOut(duration: timings[2]), value: rotation)
      }.offset(x: CGFloat(x*2), y: CGFloat(y*2))

    }.onAppear{
      DispatchQueue.main.async {
        rotation = rotToAchieve
      }
       
    }
  }
}
