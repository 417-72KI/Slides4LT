import Foundation

func multiply(_ i: Int) -> (Int) -> Int {
    return {
        print($0, "*" , i, "=", $0 * i)
        return $0 * i
    }
}
func divide(_ i: Int) -> (Int) -> Int {
    return {
        print($0, "/" , i, "=", $0 / i)
        return $0 / i
    }
}
func isOdd() -> (Int) -> Bool {
    return {
        print($0, "odd?" , $0 % 2 == 0)
        return $0 % 2 == 0
    }
}
func isMoreThan(_ i: Int) -> (Int) -> Bool {
    return {
        print($0, ">", i, ":", $0 > i)
        return $0 > i
    }
}
var list = 1...10
let newList = list.filter(isOdd())
    .map(divide(2))
    .map(multiply(5))
    .filter(isMoreThan(10))
print()
let newList2 = list.lazy
    .filter(isOdd())
    .map(divide(2))
    .map(multiply(5))
    .filter(isMoreThan(10))
    .reduce(into: [Int] ()) { (array: inout [Int], i: Int) in array.append(i) }
