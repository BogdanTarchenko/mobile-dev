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

struct RotateUI: View {
    @ObservedObject var editImageViewModel: EditImageViewModel
    @State private var rotateSliderValue: Int = 90
    var rotateAction: (() -> Void)?
    
    var body: some View {
        
        Slider(value: Binding<Double>(
            get: { Double(rotateSliderValue) },
            set: { newValue in rotateSliderValue = Int(newValue) }
        ), in: 0...360, step: 1)
        .accentColor(.gray)
        .padding(.horizontal)
        .onChange(of: rotateSliderValue) { newValue in
            editImageViewModel.rotateSliderValue = newValue
        }
        .onAppear {
            editImageViewModel.rotateSliderValue = rotateSliderValue
        }
            
        Text("Angle: \(rotateSliderValue)°")
            .foregroundColor(.gray)
            .font(Font.system(size: 18).weight(.light))
            .padding()
        
        Button(action:{
            // Resize UI button
            rotateAction?()
        }) {
            Text("Rotate")
                .foregroundColor(.white)
                .font(Font.system(size: 18).weight(.medium))
                .frame(width: 160, height: 55)
                .background(Color.blue)
                .cornerRadius(10)
        }
        Spacer()
    }
}

struct ResizeUI: View {
    @ObservedObject var editImageViewModel: EditImageViewModel
    @State private var resizeSliderValue: Double = 1.0
    var resizeAction: (() -> Void)?
    
    var body: some View {
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

struct FiltersUI: View {
    @ObservedObject var editImageViewModel: EditImageViewModel
    @State private var mosaicSliderValue: Int = 3
    var negativeAction: (() -> Void)?
    var mosaicAction: (() -> Void)?
    var medianAction: (() -> Void)?
    var gaussianBlurAction: (() -> Void)?
    
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
                
                Spacer()
                
                Button(action:{
                    // Gaussian Blur
                    gaussianBlurAction?()
                }) {
                    BottomPanelButton(iconName: "laser.burst", text: "Gaussian blur", isActive: false)
                }
            }
            .padding(.horizontal, 30)
        
        Spacer()
        
        Slider(value: Binding<Double>(
            get: { Double(mosaicSliderValue) },
            set: { newValue in mosaicSliderValue = Int(newValue) }
        ), in: 3...15, step: 1)
        .accentColor(.gray)
        .padding(.horizontal)
        .onChange(of: mosaicSliderValue) { newValue in
            editImageViewModel.mosaicSliderValue = newValue
        }
        .onAppear {
            editImageViewModel.mosaicSliderValue = mosaicSliderValue
        }
            
        Text("Mosaic block size: \(mosaicSliderValue)px")
            .foregroundColor(.gray)
            .font(Font.system(size: 18).weight(.light))
            .padding()
        
        
    }
}

struct UnsharpMaskUI: View {
    @ObservedObject var editImageViewModel: EditImageViewModel
    @State private var thresholdSliderValue: Int = 20
    @State private var amountSliderValue: Int = 50
    @State private var radiusSliderValue: Int = 1
    var thresholdAction: (() -> Void)?
    var amountAction: (() -> Void)?
    var radiusAction: (() -> Void)?
    var startAction: (() -> Void)?
    
    var body: some View {
            HStack {
                Button(action:{
                    // Threshold select
                    thresholdAction?()
                }) {
                    BottomPanelButton(iconName: "minus.diamond", text: "Threshold", isActive: false)
                }
                
                Spacer()
                
                Button(action:{
                    // Amount select
                    amountAction?()
                }) {
                    BottomPanelButton(iconName: "mosaic", text: "Amount", isActive: false)
                }
                
                Spacer()
                
                Button(action:{
                    // Radius select
                    radiusAction?()
                }) {
                    BottomPanelButton(iconName: "divide.square", text: "Radius", isActive: false)
                }
                
                Spacer()
                
                Button(action:{
                    // Start button
                    startAction?()
                }) {
                    BottomPanelButton(iconName: "laser.burst", text: "Edit", isActive: false)
                }
            }
            .padding(.horizontal, 30)
        
        Spacer()
        
        Slider(value: Binding<Double>(
            get: { Double(thresholdSliderValue) },
            set: { newValue in thresholdSliderValue = Int(newValue) }
        ), in: 10...250, step: 10)
        .accentColor(.gray)
        .padding(.horizontal)
        .onChange(of: thresholdSliderValue) { newValue in
            editImageViewModel.thresholdSliderValue = newValue
        }
        .onAppear {
            editImageViewModel.thresholdSliderValue = thresholdSliderValue
        }
            
        Text("Threshold value: \(thresholdSliderValue)")
            .foregroundColor(.gray)
            .font(Font.system(size: 18).weight(.light))
            .padding()
        
        
    }
}

struct EditingView: View {
    @ObservedObject var editImageViewModel: EditImageViewModel
    
    @State private var isRotateActive = false
    @State private var isResizeActive = false
    @State private var isFiltersActive = false
    @State private var isMaskingActive = false
    
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
                
                if isMaskingActive {
                    
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
                            isMaskingActive = false
                            editImageViewModel.rotateImage()
                        }) {
                            BottomPanelButton(iconName: "arrow.uturn.left.square", text: "Rotate", isActive: isRotateActive)
                        }
                        
                        Button(action:{
                            // Filter
                            isFiltersActive = true
                            isResizeActive = false
                            isRotateActive = false
                            isMaskingActive = false
                        }) {
                            BottomPanelButton(iconName: "camera.filters", text: "Filter", isActive: isFiltersActive)
                        }
                        
                        Button(action:{
                            // Resize
                            isResizeActive = true
                            isFiltersActive = false
                            isRotateActive = false
                            isMaskingActive = false
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
                            isMaskingActive = true
                            isResizeActive = false
                            isFiltersActive = false
                            isRotateActive = false
                            editImageViewModel.applyUnsharpMask()
                            
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

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        EditingView(editImageViewModel: EditImageViewModel())
    }
}
