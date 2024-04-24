import SwiftUI
import PhotosUI

struct Gallery: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
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
                
                if selectedItem == nil {
                    HStack() {
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()) {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(maxWidth: 110, maxHeight: 110)
                                    .foregroundColor(Color.gray)
                                    .opacity(0.25)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .foregroundColor(Color.black)
                                            .font(Font.system(size: 60))
                                    )
                                    .aspectRatio(1/1, contentMode: .fit)
                            }
                        
                        .padding(.leading)
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
                    
                    RoundedRectangle(cornerRadius: 12)
                        .frame(maxWidth: 350, maxHeight: 60)
                        .foregroundColor(Color.blue)
                        .opacity(0.3)
                        .overlay(
                            HStack {
                                Image(systemName: "hammer")
                                    .foregroundColor(.white)
                                    .font(Font.system(size: 18).weight(.medium))
                                    .padding(.trailing, 8)
                                Text("Start editing")
                                    .foregroundColor(.white)
                                    .font(Font.system(size: 18).weight(.medium))
                            }
                        )

                        .padding()
                    Spacer()
                }
                
                if selectedItem != nil {
                    HStack() {
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()) {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(maxWidth: 110, maxHeight: 110)
                                    .foregroundColor(Color.gray)
                                    .opacity(0.25)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .foregroundColor(Color.black)
                                            .font(Font.system(size: 60))
                                        
                                    )
                                    .aspectRatio(1/1, contentMode: .fit)
                            }
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(maxWidth: 110, maxHeight: 110)
                                .cornerRadius(12)
                        }
                        Spacer()
                    }
                    .padding(.leading)
                    Spacer()
                    NavigationLink(destination: Gallery()) {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(maxWidth: 350, maxHeight: 60)
                            .foregroundColor(Color.blue)
                            .overlay(
                                HStack {
                                    Image(systemName: "hammer")
                                        .foregroundColor(.white)
                                        .font(Font.system(size: 18).weight(.medium))
                                        .padding(.trailing, 8)
                                    Text("Start editing")
                                        .foregroundColor(.white)
                                        .font(Font.system(size: 18).weight(.medium))
                                }
                            )
                    }
                        .padding()
                }
            }
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
    }
}

struct Gallery_Previews: PreviewProvider {
    static var previews: some View {
        Gallery()
    }
}
