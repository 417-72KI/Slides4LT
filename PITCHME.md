### Collection操作の罠
---
TODO: 自己紹介
---
本題
---
Swift
```Swift
let list = [1,2,3,4,...]
let evenList = list.filter { $0 % 2 == 0 }
```
@[2](偶数を抽出する)
Kotlin
```Kotlin
val array = arrayOf(1,2,3,4,...)
val evenList = array.filter { it % 2 == 0 }.toTypedArray()
```
@[2](偶数を抽出する)
---
ちょっと複雑な例
---
```Swift
let range = 1...10
let newList = list.filter { $0 % 2 == 0 }
                .map { $0 / 2 }
                .map { $0 * 5 }
                .filter { $0 > 10 }
```
@[2](偶数を抽出して)
@[3](2で割って)
@[4](5をかけて)
@[5](10より大きくなった値を抽出する)
---
`map` と `filter` の定義
```Swift
public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]
public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element]
```
@[1-2](配列を返している)
---
分かりやすいように画面出力してみましょう
```Swift
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
```
@[1-6](かけ算)
@[7-12](割り算)
@[13-18](偶数か判定)
@[19-24](iより大きいか判定)
@[26](偶数を抽出して)
@[27](2で割って)
@[28](5をかけて)
@[29](10より大きくなった値を抽出)
---
実行結果
```
1 odd? false
2 odd? true
3 odd? false
4 odd? true
5 odd? false
6 odd? true
7 odd? false
8 odd? true
9 odd? false
10 odd? true
2 / 2 = 1
4 / 2 = 2
6 / 2 = 3
8 / 2 = 4
10 / 2 = 5
1 * 5 = 5
2 * 5 = 10
3 * 5 = 15
4 * 5 = 20
5 * 5 = 25
5 > 10 : false
10 > 10 : false
15 > 10 : true
20 > 10 : true
25 > 10 : true
```
@[1-10](filter(isOdd()): 10回)
@[11-15](map(divide(2)): 5回)
@[16-20](map(multiply(5)): 5回)
@[21-25](filter(isMoreThan(10)): 5回)
---
25回もループ回してんじゃん！( ﾟдﾟ)Σ

※ここでは省略しますがKotlinのArray.filterやList.map等も同じような挙動になります
---
これが要素数100万とかの配列になったら...

((((；ﾟДﾟ))))

[参考](https://qiita.com/RyotaMurohoshi/items/94c60704b21863eb8dd5)
---
そこで
---
Swift → LazyCollection

Kotlin → Sequence

どちらも遅延評価で実行してくれる
---
さっきの例
```Swift
var list = 1...10
let newList = list.filter(isOdd())
    .map(divide(2))
    .map(multiply(5))
    .filter(isMoreThan(10))
```
これを
---
こうじゃ
```Swift
var list = 1...10
let newList = list.lazy
    .filter(isOdd())
    .map(divide(2))
    .map(multiply(5))
    .filter(isMoreThan(10))
    .reduce(into: [Int] ()) { (array: inout [Int], i: Int) in array.append(i) }
```
---
実行結果
```
1 odd? false
2 odd? true
2 / 2 = 1
1 * 5 = 5
5 > 10 : false
3 odd? false
4 odd? true
4 / 2 = 2
2 * 5 = 10
10 > 10 : false
5 odd? false
6 odd? true
6 / 2 = 3
3 * 5 = 15
15 > 10 : true
7 odd? false
8 odd? true
8 / 2 = 4
4 * 5 = 20
20 > 10 : true
9 odd? false
10 odd? true
10 / 2 = 5
5 * 5 = 25
25 > 10 : true
```
forループでcontinueとかやってる時と同じような感じになる!
---
ちなみにKotlinの場合は
- `array.asSequence()` をmapとかfilterとかの前に呼ぶだけ
---
どういう時に有効？
- 大きいデータから複数の条件に合致する数件だけを抽出する
- 逆に1つの条件で合致するデータの配列を作るなどの単純なものであれば今まで通りでも十分
---
最後に
- コレクション操作の関数・メソッドを使う際は複雑になるようなら遅延評価の検討を
- SwiftのLazyCollectionは型推論と相性が悪い(
---
参考
- https://qiita.com/masakihori/items/f73e05907c302ece5d23
