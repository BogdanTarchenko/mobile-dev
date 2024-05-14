import SwiftUI

struct WelcomeView: View {
    var body: some View {
        FinalView()
    }
}

#Preview {
    WelcomeView()
}

struct FinalView: View {
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            CubesView()
                .offset(x:0, y: -95)
            bottomPanel()
        }
    }
    
    @ViewBuilder
    private func bottomPanel() -> some View{
        ZStack{
            VStack{
                Spacer()
                Text("Powered by HITs.")
                    .foregroundColor(.white)
                    .font(Font.system(size: 18).weight(.medium))
                NavigationLink(destination: EditingView(editImageViewModel: EditImageViewModel())) {
                    Text("Photo Editor")
                        .foregroundColor(.white)
                        .font(Font.system(size: 16).weight(.medium))
                        .frame(maxWidth: 500, maxHeight: 60)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                NavigationLink(destination: VectorView()) {
                    Text("Vector Editor")
                        .foregroundColor(.white)
                        .font(Font.system(size: 16).weight(.medium))
                        .frame(maxWidth: 500, maxHeight: 60)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                NavigationLink(destination: CubeView()) {
                    Text("3D Cube")
                        .foregroundColor(.white)
                        .font(Font.system(size: 16).weight(.medium))
                        .frame(maxWidth: 500, maxHeight: 60)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding([.bottom, .horizontal], 30)
        }
    }
}

struct CubesView:View {
    var body: some View {
        ZStack{
            ForEach(0 ..< 10){index in
                    CubeSetView()
                    .offset(x:100)
                    .rotationEffect(.degrees(Double(index) * 60 ))
                
            }
        }
    }
}

struct CubeSetView : View {
    @ObservedObject var viewModel = WelcomeViewModel()
    
    var body: some View {
        ZStack{
            ForEach(0..<viewModel.allCubes.count, id : \.self){index in
                cubeView(index:index)
                
            }
        }
        .onAppear(perform: viewModel.startRotation)
    }
    
    private func cubeView(index: Int) -> some View{
        let offset = viewModel.allIndicies[index]
        return viewModel.allCubes[index].view
            .offset(x: offset.0,y: offset.1)
            .zIndex(offset.2)
    }
}
