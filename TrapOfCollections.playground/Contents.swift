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
func test(_ max: Int) -> (TimeInterval, TimeInterval) {
    var start = Date()
    let list = 1...max
    let result1 = list.filter(isOdd())
        .map(divide(2))
        .map(multiply(5))
        .filter(isMoreThan(10))
        .prefix(5)
    let time1 = Date().timeIntervalSince(start)
    print(result1)
    print()
    start = Date()
    let result2 = list.lazy
        .filter(isOdd())
        .map(divide(2))
        .map(multiply(5))
        .filter(isMoreThan(10))
        .prefix(5)
        .reduce(into: [Int] ()) { (array: inout [Int], i: Int) in array.append(i) }
    let time2 = Date().timeIntervalSince(start)
    print(result2)
    print()
    return (time1, time2)
}

print()
let results = Array(1...2).map { _ in test(1000) }
let ave1 = results.map { $0.0 }.reduce(0) { $0 + $1 } / Double(results.count)
let ave2 = results.map { $0.1 }.reduce(0) { $0 + $1 } / Double(results.count)
print("before: \(ave1)")
print("after: \(ave2)")
