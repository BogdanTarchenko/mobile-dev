import SwiftUI
// Анимация загрузки (дизайн) с ролика на ютубе

class CubesViewModel: ObservableObject{
    @Published var allCubes = AllCubes.allCases
    @Published var allIndicies: [(CGFloat,CGFloat,Double,Bool)] = [
        (-80, 40, 5, true),
        (-40, 20, 3, false),
        (0, 0, 1, false),
        (40, 20, 2, true),
        (0, 40, 4, false),
        (-40, 60, 6, false)
    ]
    @Published var currentIndex : Int = 4
    
    func startRotation(){
        withAnimation{
            rotate()
        }
    }
    
    private func rotate(){
        let clearPosition = allIndicies[5]
        
        allIndicies[5] = allIndicies[currentIndex]
        allIndicies[currentIndex] = clearPosition
        
        currentIndex = currentIndex - 1
        
        if currentIndex == -1 {
            currentIndex = 4
        }
        
        if allIndicies[currentIndex].3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                withAnimation{
                    self.rotate()
                }
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                withAnimation{
                    self.rotate()
                }
            }
        }
    }
}
