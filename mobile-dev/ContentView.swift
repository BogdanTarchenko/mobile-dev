import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Image("starting-screen-background")
                    .aspectRatio(contentMode: .fill)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Photo Editor")
                        .font(Font.system(size: 36).weight(.bold))
                        .foregroundColor(Color.white)
                        .offset(x:20, y:610)
                    
                    Text("Edit photos using built-in image\nprocessing filters, try out an AI technology")
                        .font(Font.system(size: 18).weight(.medium))
                        .foregroundColor(Color.white)
                        .lineSpacing(5)
                        .offset(x:20, y:610)
                    
                    NavigationLink(destination: SecondView()) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .font(Font.system(size: 16).weight(.medium))
                            .frame(width: 350, height: 60)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }

                    .offset(x:20, y:610)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .frame(width: 150, height: 40)
                            .foregroundColor(Color.blue)
                                        
                        Text("Powered by HITs")
                            .foregroundColor(.white)
                            .font(Font.system(size: 18).weight(.medium))
                    }
                    .offset(x: 20, y: 345)
                }
                .padding()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
        }
    }
}

struct SecondView: View {
    var body: some View {
        VStack {
            Text("Second Page")
                .font(.title)
                .foregroundColor(.black)
        }
        .navigationBarBackButtonHidden(true)
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
