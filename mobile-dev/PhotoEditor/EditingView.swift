import SwiftUI

struct EditingView: View {
    @ObservedObject var editImageViewModel: EditImageViewModel
    
    @State private var isRotateActive = false
    @State private var isResizeActive = false
    @State private var isFiltersActive = false
    @State private var isRetouchActive = false
    @State private var isMaskingActive = false
    
    @State var touchLocation: CGPoint?
    

    
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
                            CubesView()
                                .scaleEffect(0.1)
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
                } else if isRetouchActive {
                    GeometryReader { geometry in
                                VStack {
                                    if let editedImage = editImageViewModel.editedImage {
                                        Image(uiImage: editedImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity, maxHeight: 400)
                                            .gesture(
                                                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                                    .onChanged { value in
                                                        touchLocation = value.location
                                                        if isRetouchActive {
                                                            editImageViewModel.retouchImage(at: value.location, in: geometry.size)
                                                        }
                                                    }
                                                    .onEnded { _ in
                                                        touchLocation = nil
                                                    }
                                            )
                                    }
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
                // Rotate UI
                if isRotateActive {
                    RotateUI(editImageViewModel: editImageViewModel, rotateAction: {
                        editImageViewModel.rotateImage()
                    })
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
                    }, gaussianBlurAction: {
                        editImageViewModel.applyGaussianBlurFilter()
                    })
                }
                
                // Retouch UI
                if isRetouchActive {
                    RetouchUI(editImageViewModel: editImageViewModel, retouchAction: {
                    })
                }
                
                // Masking UI
                if isMaskingActive {
                    MaskingUI(editImageViewModel: editImageViewModel, maskingAction: {
                        editImageViewModel.applyUnsharpMask()
                    })
                }
                
                Spacer()
                
                // Bottom/Scroll button bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        
                        Button(action:{
                            // Rotate
                            isRotateActive = true
                            isFiltersActive = false
                            isResizeActive = false
                            isRetouchActive = false
                            isMaskingActive = false
                        }) {
                            BottomPanelButton(iconName: "arrow.uturn.left.square", text: "Rotate", isActive: isRotateActive)
                        }
                        
                        Button(action:{
                            // Filter
                            isFiltersActive = true
                            isResizeActive = false
                            isRotateActive = false
                            isRetouchActive = false
                            isMaskingActive = false
                        }) {
                            BottomPanelButton(iconName: "camera.filters", text: "Filter", isActive: isFiltersActive)
                        }
                        
                        Button(action:{
                            // Resize
                            isResizeActive = true
                            isFiltersActive = false
                            isRotateActive = false
                            isRetouchActive = false
                            isMaskingActive = false
                        }) {
                            BottomPanelButton(iconName: "square.resize.up", text: "Resize", isActive: isResizeActive)
                        }
                        
                        Button(action:{
                            // Face recognize
                            editImageViewModel.detectFacesInImage()
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
                            isRetouchActive = true
                            isResizeActive = false
                            isFiltersActive = false
                            isRotateActive = false
                            isMaskingActive = false
                        }) {
                            BottomPanelButton(iconName: "wand.and.stars.inverse", text: "Retouch", isActive: isRetouchActive)
                        }
                        
                        Button(action:{
                            // Masking
                            isMaskingActive = true
                            isRetouchActive = false
                            isResizeActive = false
                            isFiltersActive = false
                            isRotateActive = false
                        }) {
                            BottomPanelButton(iconName: "theatermasks", text: "Masking", isActive: isMaskingActive)
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

struct EditingView_Previews: PreviewProvider {
    static var previews: some View {
        EditingView(editImageViewModel: EditImageViewModel())
    }
}
