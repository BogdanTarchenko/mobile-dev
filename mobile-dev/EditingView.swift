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
    let isActive: Bool
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.system(size: 25))
                .foregroundColor(isActive ? .blue : .gray)
                .font(Font.system(size: 16).weight(.medium))
                .frame(width: 30, height: 30)
            Text(text)
                .foregroundColor(isActive ? .blue : .gray)
                .font(Font.system(size: 17).weight(.light))
        }
    }
}

struct ResizeUI: View {
    @ObservedObject var editImageViewModel: EditImageViewModel
    @State private var resizeSliderValue: Double = 1.0
    var resizeAction: (() -> Void)?
    
    var body: some View {
        VStack {
            Slider(value: $resizeSliderValue, in: 0.5...2, step: 0.1)
                .accentColor(.gray)
                .padding(.horizontal)
                .onChange(of: resizeSliderValue) { newValue in
                    editImageViewModel.resizeSliderValue = newValue
                }
            
            Text("Scaling: \(resizeSliderValue, specifier: "%.2f")x")
                .foregroundColor(.gray)
                .font(Font.system(size: 18).weight(.light))
                .padding()
            
            Button(action:{
                // Resize UI button
                resizeAction?()
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
}

struct FiltersUI: View {
    @ObservedObject var editImageViewModel: EditImageViewModel
    var negativeAction: (() -> Void)?
    var mosaicAction: (() -> Void)?
    var medianAction: (() -> Void)?
    
    var body: some View {
        HStack {
            Button(action:{
                // Negative
                negativeAction?()
            }) {
                BottomPanelButton(iconName: "minus.diamond", text: "Negative", isActive: false)
            }
            
            Spacer()
            
            Button(action:{
                // Mosaic
                mosaicAction?()
            }) {
                BottomPanelButton(iconName: "mosaic", text: "Mosaic", isActive: false)
            }
            
            Spacer()
            
            Button(action:{
                // Median
                medianAction?()
            }) {
                BottomPanelButton(iconName: "divide.square", text: "Median", isActive: false)
            }
        }
        .padding(.horizontal, 30)
    }
}

struct EditingView: View {
    @ObservedObject var editImageViewModel: EditImageViewModel
    
    @State private var isResizeActive = false
    @State private var isFiltersActive = false
    
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
                if editImageViewModel.isProcessing {
                    ZStack {
                        if let editedImage = editImageViewModel.editedImage {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(2)
                                .foregroundColor(.white)
                            Image(uiImage: editedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                                .frame(maxHeight: 400)
                                .foregroundColor(.black)
                                .opacity(0.5)
                                .blur(radius: 5)
                        } else {
                            Text("No image selected")
                                .foregroundColor(.gray)
                                .font(Font.system(size: 30).weight(.thin))
                                .padding(.top, 150)
                        }
                    }
                } else {
                    if let editedImage = editImageViewModel.editedImage {
                        Image(uiImage: editedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .frame(maxHeight: 400)
                    } else {
                        Text("No image selected")
                            .foregroundColor(.gray)
                            .font(Font.system(size: 30).weight(.thin))
                            .padding(.top, 150)
                    }
                }
                
                // Resize UI
                if isResizeActive {
                    ResizeUI(editImageViewModel: editImageViewModel, resizeAction: {
                        editImageViewModel.resizeImage()
                    })
                }
                
                // Filters UI
                if isFiltersActive {
                    FiltersUI(editImageViewModel: editImageViewModel, negativeAction: {
                        editImageViewModel.applyNegativeFilter()
                    }, mosaicAction: {
                        editImageViewModel.applyMosaicFilter()
                    }, medianAction: {
                        editImageViewModel.applyMedianFilter()
                    })
                }
                
                Spacer()
                
                // Bottom/Scroll button bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        
                        Button(action:{
                            // Rotate
                            editImageViewModel.rotateImage()
                        }) {
                            BottomPanelButton(iconName: "arrow.uturn.left.square", text: "Rotate", isActive: false)
                        }
                        
                        Button(action:{
                            // Filter
                            isFiltersActive = true
                            isResizeActive = false
                        }) {
                            BottomPanelButton(iconName: "camera.filters", text: "Filter", isActive: isFiltersActive)
                        }
                        
                        Button(action:{
                            // Resize
                            isResizeActive = true
                            isFiltersActive = false
                        }) {
                            BottomPanelButton(iconName: "square.resize.up", text: "Resize", isActive: isResizeActive)
                        }
                        
                        Button(action:{
                            // Face recognize
                        }) {
                            BottomPanelButton(iconName: "faceid", text: "Face AI", isActive: false)
                        }
                        
                        Button(action:{
                            // Vector
                        }) {
                            BottomPanelButton(iconName: "pencil.and.outline", text: "Vector", isActive: false)
                        }
                        
                        Button(action:{
                            // Retouch
                        }) {
                            BottomPanelButton(iconName: "wand.and.stars.inverse", text: "Retouch", isActive: false)
                        }
                        
                        Button(action:{
                            // Masking
                        }) {
                            BottomPanelButton(iconName: "theatermasks", text: "Masking", isActive: false)
                        }
                        
                        Button(action:{
                            // Affine
                        }) {
                            BottomPanelButton(iconName: "slider.vertical.3", text: "Affine", isActive: false)
                        }
                        
                        Button(action:{
                            // Cube
                        }) {
                            BottomPanelButton(iconName: "cube.fill", text: "Cube", isActive: false)
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
