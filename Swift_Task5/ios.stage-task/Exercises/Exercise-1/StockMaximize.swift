import Foundation

class StockMaximize {

    func countProfit(prices: [Int]) -> Int {
        var profit:Int = 0
        var maximum:Int
        let count = prices.count
        if(count > 0){
            for _ in 0...count-1{
                maximum = prices[count-1]
                profit = 0
                
                if(count > 1){
                    for k in (0...count-2).reversed() {
                        maximum = max(maximum, prices[k+1])
                        
                        if(prices[k] < maximum){
                            profit+=(maximum - prices[k])
                        }
                    }
                }
            }
        }
        
        return profit
    }
}
