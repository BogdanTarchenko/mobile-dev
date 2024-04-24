import SwiftUI

struct galleryEmpty: View {
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
                NavigationLink(destination: galleryEmpty()) {
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

struct galleryEmpty_Previews: PreviewProvider {
    static var previews: some View {
        galleryEmpty()
    }
}
