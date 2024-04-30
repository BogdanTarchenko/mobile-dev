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

struct LoadingView: View {
    @ObservedObject var editImageViewModel: EditImageViewModel
    @State private var sliderValue: Double = 1
    @State private var resizeSelect = false
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                
                // Top button bar
                HStack {
                    
                    NavigationLink(destination: Gallery(editImageViewModel: EditImageViewModel())){
                        TopPanelBackButton(iconName: "chevron.backward")
                    }
                    
                    Spacer()
                    
                    Button(action:{
                        // Undo
                    }) {
                        TopPanelButton(iconName: "arrow.uturn.backward")
                    }
                    Button(action:{
                        // Clear
                    }) {
                        TopPanelButton(iconName: "arrow.circlepath")
                    }
                    Button(action:{
                        // Redo
                    }) {
                        TopPanelButton(iconName: "arrow.uturn.forward")
                    }
                    
                    Spacer()
                    
                    Button(action:{
                        // Save
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
                }
                else {
                    Text("No image selected")
                        .foregroundColor(.gray)
                        .font(Font.system(size: 30).weight(.thin))
                        .padding(.top, 150)
                }
                
                Spacer()
                
                if resizeSelect {
                    VStack {
                        Slider(value: $sliderValue, in: 0.5...2, step: 0.1)
                            .accentColor(.gray)
                            .padding()
                            .onChange(of: sliderValue) { newValue in
                                editImageViewModel.sliderValue = newValue
                            }
                        
                        Text("Scaling: \(sliderValue, specifier: "%.2f")x")
                            .foregroundColor(.white)
                            .font(Font.system(size: 17).weight(.light))
                            .padding()
                        Button(action:{
                            // Save
                            editImageViewModel.resizeImage()
                        }) {
                            Text("Resize and save")
                                .foregroundColor(.white)
                                .font(Font.system(size: 18).weight(.medium))
                                .frame(width: 180, height: 60)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                
                Spacer()
                
                // Bottom/Scroll button bar
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    Spacer()
                    
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
                            resizeSelect = true
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
                }
                .padding(.horizontal, 30)
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
        LoadingView(editImageViewModel: EditImageViewModel())
    }
}
