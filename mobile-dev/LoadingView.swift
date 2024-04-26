import SwiftUI

struct LoadingView: View {
    var selectedImageData: Data?
    var body: some View {
        NavigationView {
            VStack {
                
                // Верхняя панель кнопок
                HStack {
                    NavigationLink(destination: Gallery()){
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .font(Font.system(size: 16).weight(.medium))
                            .frame(width: 40, height: 40)
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
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .padding()
                }
                else {
                    Text("No image selected")
                        .frame(maxWidth: 350, maxHeight: 450)
                        .foregroundColor(.white)
                }
                Spacer()
                Spacer()
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
    //                    Spacer()
    //                    Image(systemName: "circle.circle")
    //                        .font(.system(size: 32))
    //                        .foregroundColor(.white)
    //                        .padding()
    //                    Text("Wait for it...")
    //                        .foregroundColor(.gray)
    //                    Text("We are saving your photo")
    //                        .foregroundColor(.gray)
    //                    Spacer()
                        Spacer()
                        //1) Повороты изображения.
                        Button(action:{
                            // тут должно быть действие
                        }) {
                            VStack{
                                Image(systemName: "arrow.uturn.left.square")
                                    .font(.system(size: 25))
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 16).weight(.medium))
                                    .frame(width: 30, height: 30)
                                Text("Turn")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 17).weight(.light))
                            }
                        }
                        
                        Spacer()
                        //2) Цветокоррекция и цветовые фильтры.
                        Button(action:{
                            // тут должно быть действие
                        }) {
                            VStack{
                                Image(systemName: "camera.filters")
                                    .font(.system(size: 25))
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 16).weight(.medium))
                                    .frame(width: 30, height: 30)
                                Text("Filter")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 17).weight(.light))
                                
                            }
                        }
                        Spacer()
                        //3) Масштабирование изображения.
                        Button(action:{
                            // тут должно быть действие
                        }) {
                            VStack{
                                Image(systemName: "square.resize.up")
                                    .font(.system(size: 25))
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 16).weight(.medium))
                                    .frame(width: 30, height: 30)
                                Text("Rezise")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 17).weight(.light))
                                
                            }
                        }
                        Spacer()
                        //4) Распознавание лиц/людей на изображении .
                        Button(action:{
                            // тут должно быть действие
                        }) {
                            VStack{
                                Image(systemName: "faceid")
                                    .font(.system(size: 25))
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 16).weight(.medium))
                                    .frame(width: 30, height: 30)
                                Text("Face AI")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 17).weight(.light))
                                
                            }
                        }
                        Spacer()
                        //5) Векторный редактор с рисованием ломаных линий и превращением их в сплайны.
                        Button(action:{
                            // тут должно быть действие
                        }) {
                            VStack{
                                Image(systemName: "pencil.and.outline")
                                    .font(.system(size: 25))
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 16).weight(.medium))
                                    .frame(width: 30, height: 30)
                                Text("Vector")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 17).weight(.light))
                                
                            }
                        }
                        Spacer()
                        //6) Ретуширование.
                        Button(action:{
                            // тут должно быть действие
                        }) {
                            VStack{
                                Image(systemName: "wand.and.stars.inverse")
                                    .font(.system(size: 25))
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 16).weight(.medium))
                                    .frame(width: 30, height: 30)
                                Text("Retouch")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 17).weight(.light))
                                
                            }
                        }
                        Spacer()
                        //7) Нерезкое маскирование.
                        Button(action:{
                            // тут должно быть действие
                        }) {
                            VStack{
                                Image(systemName: "theatermasks")
                                    .font(.system(size: 25))
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 16).weight(.medium))
                                    .frame(width: 30, height: 30)
                                Text("Masking")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 17).weight(.light))
                                
                            }
                        }
                        
                        Spacer()
                        //8) Нерезкое маскирование.
                        Button(action:{
                            // тут должно быть действие
                        }) {
                            VStack{
                                Image(systemName: "slider.vertical.3")
                                    .font(.system(size: 25))
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 16).weight(.medium))
                                    .frame(width: 30, height: 30)
                                Text("Affine")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 17).weight(.light))
                                
                            }
                        }
                        Spacer()
                        //9) 3D Кубик.
                        Button(action:{
                            // тут должно быть действие
                        }) {
                            VStack{
                                Image(systemName: "cube.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 16).weight(.medium))
                                    .frame(width: 30, height: 30)
                                Text("3D Cube")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 17).weight(.light))
                                
                            }
                        }
                        Spacer()
                    }
                   
                }
                Spacer()
                
                
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
        LoadingView(selectedImageData: nil)
    }
}
