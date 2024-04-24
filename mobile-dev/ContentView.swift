import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack(alignment:.leading) {
                Image("starting-screen-background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                    RoundedRectangle(cornerRadius: 6)
                        .frame(maxWidth: 150, maxHeight: 40)
                        .foregroundColor(Color.blue)
                        .overlay(
                            Text("Powered by HITs")
                                .foregroundColor(.white)
                                .font(Font.system(size: 18).weight(.medium))
                            )
                    
                    Text("Photo Editor")
                        .font(Font.system(size: 36).weight(.bold))
                        .foregroundColor(Color.white)
                    
                    Text("Edit photos using built-in image\nprocessing filters, try out an AI technology")
                        .font(Font.system(size: 18).weight(.medium))
                        .foregroundColor(Color.white)
                        .lineSpacing(5)
                    
                    NavigationLink(destination: SecondView()) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .font(Font.system(size: 16).weight(.medium))
                            .frame(maxWidth: 500, maxHeight: 60)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 70)
                }
                .padding()
            }
        }
    }
}

struct SecondView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 15) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .foregroundColor(Color.gray)
                    .opacity(0.07)
                    .overlay(
                        Text("Photos")
                            .font(Font.system(size: 24).weight(.bold))
                    )
                    .edgesIgnoringSafeArea(.top)
                
                HStack() {
                    Button(action: {
                        // тут должно быть действие на открытие галереи
                    }) {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(maxWidth: 130, maxHeight: 130)
                            .foregroundColor(Color.gray)
                            .opacity(0.25)
                            .overlay(
                                Image("plus")
                            )
                            .aspectRatio(1/1, contentMode: .fit)
                    }
                    .padding([.leading])
                    Spacer()
                }
                
                Spacer()
                
                Image("arrow")
                
                Text("Let's go!")
                    .font(Font.system(size: 46).weight(.bold))
                Text("Just add your photo here\nand start editing")
                    .multilineTextAlignment(.center)
                    .font(Font.system(size: 18).weight(.medium))
                    .foregroundColor(Color.gray)
                
                Spacer()
                NavigationLink(destination: SecondView()) {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(maxWidth: 350, maxHeight: 60)
                        .foregroundColor(Color.blue)
                        .overlay(
                            Text("Start editing")
                                .foregroundColor(.white)
                                .font(Font.system(size: 18).weight(.medium))
                        )
                }
                .padding()
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
