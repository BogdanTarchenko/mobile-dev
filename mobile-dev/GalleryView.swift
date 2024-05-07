import SwiftUI
import PhotosUI

struct GalleryView: View {
    @ObservedObject var editImageViewModel: EditImageViewModel
    @State private var selectedImageData: Data? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 15) {
                ZStack {
                    NavigationLink(destination: WelcomeView()){
                        BottomPanelButton(iconName: "chevron.backward", text: "Back", isActive: false)
                        Spacer()
                    }
                    .padding()
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 250)
                        .foregroundColor(Color.gray)
                        .opacity(0.07)
                        .overlay(
                            Text("Photos")
                                .font(Font.system(size: 24).weight(.bold))
                        )
                        .edgesIgnoringSafeArea(.top)
                }
                
                if selectedItem == nil {
                    HStack() {
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
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
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        if let selectedImageData = selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxHeight: 300)
                                .cornerRadius(12)
                                .padding()
                                .opacity(0.6)
                                .overlay(
                                    HStack {
                                        Image(systemName: "plus")
                                            .foregroundColor(.black)
                                            .font(Font.system(size: 60).weight(.medium))
                                            .padding(.trailing, 8)
                                    }
                                )
                        }
                    }
                    Spacer().padding(.leading)
                    Spacer()
                    NavigationLink(destination: EditingView(editImageViewModel: editImageViewModel)) {
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
            if let newItem = newItem {
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        selectedImageData = data
                        if let uiImage = UIImage(data: selectedImageData!) {
                            editImageViewModel.originalImage = uiImage
                            editImageViewModel.nonChangedImage = uiImage
                        }
                    }
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
        GalleryView(editImageViewModel: EditImageViewModel())
    }
}
