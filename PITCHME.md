### Collection操作の罠
---
Profile
- Takuhiro Muta
- iOS Enginner@iRidge inc.
- Twitter/Qiita: @417_72ki
- GitHub: 417-72KI
---
本題
---
Objective-CからSwift  
JavaからKotlin(またはJava8)  
になるに従って  
コレクション操作が大幅に楽になりました
---
昔

Objective-C
```ObjC
NSArray *array = ...
NSArray *evenArray = [NSMutableArray new];
for (NSNumber *num in array) {
    if(num.integerValue % 2 == 0) {
        [evenArray addObject:num];
    }
}
```
Java(~7)
```Java
List<Integer> list = ...
List<Integer> evenList = new ArrayList<>();
for(int num: list) {
    if(num % 2 == 0) {
        evenList.add(num);
    }
}
```
---
今

Swift
```Swift
let list = [1,2,3,4,...]
let evenList = list.filter { $0 % 2 == 0 }
```
Kotlin
```Kotlin
val array = arrayOf(1,2,3,4,...)
val evenList = array.filter { it % 2 == 0 }.toTypedArray()
```
---
ちょっと複雑な例
---
```Swift
let range = 1...10
let newList = range.filter { $0 % 2 == 0 }
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
@[1](`Element`を`T`に変換した配列を返す)
@[2](条件に合致した`Element`のみを抽出した配列を返す)
---
どちらも配列を返している...
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
イメージ
```Java
List<Integer> l = new ArrayList<>();
for (int n: array) if (isOdd(n)) l.add(n); 

List<Integer> l2 = new ArrayList<>();
for (int n: l) l2.add(divide(n, 2)); 

List<Integer> l3 = new ArrayList<>();
for (int n: l2) l3.add(multiply(n, 5));

List<Integer> result = new ArrayList<>();
for (int n: l3) if (isMoreThan(n, 10)) result.add(n);
```
---
ループ回しすぎぃ！
---
これが要素数100万とかの配列になったら...
---
((((；ﾟДﾟ))))
---
そこで
---
Swift → LazyCollection  
Kotlin → Sequence
---
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
---
イメージ
```Java
List<Integer> result = new ArrayList<>();
for (int n: array) {
    if (!isOdd(n)) continue;
    int n2 = divide(n, 2);
    int n3 = multiply(n2, 5)
    if (isMoreThan(n3, 10)) result.add(n3);
}
```
1ループで回す感じに
---
ちなみにKotlinの場合は
- `array.asSequence()` をmapとかfilterとかの前に呼ぶだけ
---
どういう時に有効？
- 大きいデータから複数の条件に合致する数件だけを抽出する
- 逆に1つの条件で合致するデータの配列を作るなどの単純なものであれば今まで通りでも十分
---
まとめ
- コレクション操作の関数・メソッドを使う際は複雑になるようなら遅延評価の検討を！
---
