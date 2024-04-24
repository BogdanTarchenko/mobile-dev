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
                    
                    NavigationLink(destination: galleryEmpty()) {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
