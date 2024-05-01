import SwiftUI

struct TopPanelBackButton: View {
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: 22))
            .foregroundColor(.white)
            .font(Font.system(size: 16).weight(.medium))
            .frame(width: 40, height: 40)
            .background(Color.black)
            .cornerRadius(10)
    }
}

struct TopPanelButton: View {
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: 22))
            .foregroundColor(.gray)
            .font(Font.system(size: 16).weight(.medium))
            .frame(width: 40, height: 40)
            .background(Color.black)
            .cornerRadius(10)
    }
}

struct BottomPanelButton: View {
    let iconName: String
    let text: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.system(size: 25))
                .foregroundColor(.gray)
                .font(Font.system(size: 16).weight(.medium))
                .frame(width: 30, height: 30)
            Text(text)
                .foregroundColor(.gray)
                .font(Font.system(size: 17).weight(.light))
        }
    }
}

struct EditingView: View {
    @ObservedObject var editImageViewModel: EditImageViewModel
    @State private var sliderValue: Double = 1.0
    @State private var isResizeActive = false
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                
                // Top button bar
                HStack {
                    
                    NavigationLink(destination: GalleryView(editImageViewModel: EditImageViewModel())){
                        TopPanelBackButton(iconName: "chevron.backward")
                    }
                    
                    Spacer()
                    
                    Button(action:{
                        // Undo
                        editImageViewModel.undo()
                    }) {
                        TopPanelButton(iconName: "arrow.uturn.backward")
                    }
                    Button(action:{
                        // Clear
                        editImageViewModel.resetToOriginalImage()
                    }) {
                        TopPanelButton(iconName: "arrow.circlepath")
                    }
                    Button(action:{
                        // Redo
                        editImageViewModel.redo()
                    }) {
                        TopPanelButton(iconName: "arrow.uturn.forward")
                    }
                    
                    Spacer()
                    
                    Button(action:{
                        editImageViewModel.saveImage()
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
                
                // SelectedImageView
                if let editedImage = editImageViewModel.editedImage {
                    Image(uiImage: editedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(maxHeight: 400)
                }
                else {
                    Text("No image selected")
                        .foregroundColor(.gray)
                        .font(Font.system(size: 30).weight(.thin))
                        .padding(.top, 150)
                }
                
                // Resize UI
                if isResizeActive {
                    VStack {
                        Slider(value: $sliderValue, in: 0.5...2, step: 0.1)
                            .accentColor(.gray)
                            .padding(.horizontal)
                            .onChange(of: sliderValue) { newValue in
                                editImageViewModel.sliderValue = newValue
                            }
                        
                        Text("Scaling: \(sliderValue, specifier: "%.2f")x")
                            .foregroundColor(.gray)
                            .font(Font.system(size: 18).weight(.light))
                            .padding()
                        
                        Button(action:{
                            // Resize UI button
                            editImageViewModel.resizeImage()
                        }) {
                            Text("Resize")
                                .foregroundColor(.white)
                                .font(Font.system(size: 18).weight(.medium))
                                .frame(width: 160, height: 55)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                }
                
                Spacer()
                
                // Bottom/Scroll button bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        
                        Button(action:{
                            // Rotate
                            editImageViewModel.rotateImage()
                        }) {
                            BottomPanelButton(iconName: "arrow.uturn.left.square", text: "Rotate")
                        }
                        
                        Button(action:{
                            // Filter
                        }) {
                            BottomPanelButton(iconName: "camera.filters", text: "Filter")
                        }
                        
                        Button(action:{
                            // Resize
                            isResizeActive = true
                        }) {
                            BottomPanelButton(iconName: "square.resize.up", text: "Resize")
                        }
                        
                        Button(action:{
                            // Face recognize
                        }) {
                            BottomPanelButton(iconName: "faceid", text: "Face AI")
                        }
                        
                        Button(action:{
                            // Vector
                        }) {
                            BottomPanelButton(iconName: "pencil.and.outline", text: "Vector")
                        }
                        
                        Button(action:{
                            // Retouch
                        }) {
                            BottomPanelButton(iconName: "wand.and.stars.inverse", text: "Retouch")
                        }
                        
                        Button(action:{
                            // Masking
                        }) {
                            BottomPanelButton(iconName: "theatermasks", text: "Masking")
                        }
                        
                        Button(action:{
                            // Affine
                        }) {
                            BottomPanelButton(iconName: "slider.vertical.3", text: "Affine")
                        }
                        
                        Button(action:{
                            // Cube
                        }) {
                            BottomPanelButton(iconName: "cube.fill", text: "Cube")
                        }
                        
                    }
                    .padding(.horizontal, 30)
                }
            }
            .background(Color.black)
        }
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        EditingView(editImageViewModel: EditImageViewModel())
    }
}
