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
        }
    }
}

struct SecondView: View {
    var body: some View {
        NavigationView {
            VStack {
                
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 140)
                    .foregroundColor(Color.gray)
                    .opacity(0.07)
                    .offset(y:-80)
                    .overlay(
                        Text("Photos")
                        .font(Font.system(size: 24).weight(.bold))
                        .offset(y: -35)
                    )
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 120, height: 120)
                    .foregroundColor(Color.gray)
                    .opacity(0.25)
                    .offset(x: -120, y: -70)
                    .overlay(
                        Image("plus")
                            .offset(x: -120, y: -70)
                        )
                
                Spacer()
                
                Image("arrow")
                    .offset(x: 15, y: -40)
                
                Text("Let's go!")
                    .font(Font.system(size: 46).weight(.bold))
                    .offset(y: -20)
                Text("Just add your photo here\nand start editing")
                    .multilineTextAlignment(.center)
                    .font(Font.system(size: 18).weight(.medium))
                    .foregroundColor(Color.gray)
                    .offset(y: 0)
                
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 180)
                    .foregroundColor(Color.gray)
                    .opacity(0.07)
                    .offset(y: 50)
                    .overlay(
                        NavigationLink(destination: SecondView()) {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(maxWidth: 350, maxHeight: 60)
                                .foregroundColor(Color.blue)
                                .offset(y: 35)
                                .overlay(
                                    Text("Start editing")
                                        .foregroundColor(.white)
                                        .font(Font.system(size: 18).weight(.medium))
                                        .offset(y: 35)
                                )
                        }
                    )
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
