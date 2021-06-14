import Foundation

public typealias Supply = (weight: Int, value: Int)

public final class Knapsack {
    let maxWeight: Int
    let drinks: [Supply]
    let foods: [Supply]
    var maxKilometers: Int {
        findMaxKilometres()
    }
    
    init(_ maxWeight: Int, _ foods: [Supply], _ drinks: [Supply]) {
        self.maxWeight = maxWeight
        self.drinks = drinks
        self.foods = foods
    }
    
    func findMaxKilometres() -> Int {
        var dValue = [Int]()
        var dWeight = [Int]()
        
        for d in drinks{
            dValue.append(d.value)
            dWeight.append(d.weight)
        }
        
        var fValue = [Int]()
        var fWeight = [Int]()
        
        for f in foods{
            fValue.append(f.value)
            fWeight.append(f.weight)
        }
        
        let drinkArray = knapsack(p: maxWeight, w_i: dWeight, v_i: dValue)
        let foodArray = knapsack(p: maxWeight, w_i: fWeight, v_i: fValue)
        
        var result = 0
        for i in 0...maxWeight {
            let food = foodArray[foods.count][i]
            let drink = drinkArray[drinks.count][maxWeight - i]
            var temp = food
            if (drink < food) {
                temp = drink
            }
            
            if (temp > result) {
                result = temp
            }
        }
        
        return result
    }
    
    func knapsack(p: Int, w_i: [Int], v_i: [Int]) -> [[Int]] {
        let n = w_i.count
        var t = Array(repeating: Array(repeating: 0,count: p + 1), count: n + 1)
        
        for i in 0..<n {
            for j in 1...p {
                if(((j-w_i[i]>0 && t[i][j-w_i[i]]>0) || j - w_i[i] == 0) && t[i][j-w_i[i]]+v_i[i]>t[i][j]){
                    t[i+1][j] = t[i][j-w_i[i]]+v_i[i]
                }
                else {
                    t[i+1][j] = t[i][j]
                }
            }
        }
        
        for i in 1...p {
            if (t[n][i] < t[n][i - 1]) {
                t[n][i] = t[n][i - 1]
            }
        }
        
        return t
    }
}
