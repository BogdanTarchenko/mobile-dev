import SwiftUI

struct LoadingView: View {
    var selectedImageData: Data?
    var body: some View {
        VStack {
            HStack {
                Button(action:{
                    // тут должно быть действие
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .font(Font.system(size: 16).weight(.medium))
                        .frame(width: 60, height: 40)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action:{
                    // тут должно быть действие
                }) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                        .font(Font.system(size: 16).weight(.medium))
                        .frame(width: 40, height: 40)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                Button(action:{
                    // тут должно быть действие
                }) {
                    Image(systemName: "arrow.circlepath")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                        .font(Font.system(size: 16).weight(.medium))
                        .frame(width: 40, height: 40)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                Button(action:{
                    // тут должно быть действие
                }) {
                    Image(systemName: "arrow.uturn.forward")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                        .font(Font.system(size: 16).weight(.medium))
                        .frame(width: 40, height: 40)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action:{
                    // тут должно быть действие
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .font(Font.system(size: 16).weight(.medium))
                        .frame(width: 60, height: 40)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            
            if let imageData = selectedImageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 350, maxHeight: 450)
                        }
            else {
                Text("No image selected")
                    .frame(maxWidth: 350, maxHeight: 450)
                    .foregroundColor(.white)
            }
            
            VStack {
                Spacer()
                Image(systemName: "circle.circle")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .padding()
                Text("Wait for it...")
                    .foregroundColor(.gray)
                Text("We are saving your photo")
                    .foregroundColor(.gray)
                Spacer()
            }
            
            Spacer()
            
                        
        }
        .background(Color.black)
    }
    
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(selectedImageData: nil)
    }
}
