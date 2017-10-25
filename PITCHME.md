### Collection操作の罠
Swift & Kotlin 編
---
突然ですが
---
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
何やってるかは分かりますよね？
---
これがJava8になって
```Java
List<Integer> list = ...
List<Integer> evenList = list.stream()
        .filter(num -> num % 2 == 0)
        .collect(Collectors.toList());
```
---
超簡潔！
分かりやすい！
---
これがSwiftだと
```Swift
let list = [1,2,3,4,...]
let evenList = list.filter { $0 % 2 == 0 }
```
たったこれだけ
---
さらにKotlin
```Kotlin
val array = arrayOf(1,2,3,4,...)
val evenList = array.filter { it % 2 == 0 }.toTypedArray()
```
Swiftに近いですね
---
もうちょっと複雑な例
---
```Java
List<Integer> list = ...
List<Integer> newList = new ArrayList<>();
for(int num: list) {
    if (num % 2 == 0) {
        int num2 = num / 2;
        int num3 = num2 * 5;
        if (num3 > 50) {
            newList.add(num3);
        }
    }
}
```
@[4](偶数を抽出して)
@[5](2で割って)
@[6](5をかけて)
@[7-9](50より大きくなった値を新しいリストに追加する)
---
Java8で書くと
```Java
List<Integer> list = ...
List<Integer> newList = list.stream()
    .filter(i -> i % 2 == 0)
    .map(i -> i / 2)
    .map(i -> i * 5)
    .filter(i -> i > 50)
    .collect(Collectors.toList());
```
@[3](偶数を抽出して)
@[4](2で割って)
@[5](5をかけて)
@[6](50より大きくなった値で)
@[7](リストを生成する)
@[3-6](中間操作)
@[7](終端操作)
---
Java8のStreamAPIでは
- 中間操作のメソッドで返されるオブジェクトは全てStreamクラスのオブジェクト |
- 終端操作が呼ばれるまで中間操作は実行されない |
- この時、ループ回数は従来のfor文で書いた時と同じlist.size()回になります |
- この仕組みを"遅延評価"とか"遅延実行"と言います |
---
ではこれを踏まえてSwiftのコードを見てみましょう
---
```Swift
let range = 1...100
let newList = list.filter { $0 % 2 == 0 }
                .map { $0 / 2 }
                .map { $0 * 5 }
                .filter { $0 > 50 }
```
Javaの時と何が違うでしょうか？
---
Array.mapの定義
```Swift
public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]
```
@[1](配列を返してる)
---
分かりやすいように画面出力してみましょう
```Swift
func divide(_ i: Int) -> (Int) -> Int {
    return {
        print($0, "/" , i, "=", $0 / i)
        return $0 / i
    }
}
func multiply(_ i: Int) -> (Int) -> Int {
    return {
        print($0, "*" , i, "=", $0 * i)
        return $0 * i
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
@[1](偶数を抽出して)
@[2](2で割って)
@[3](5をかけて)
@[4](50より大きくなった値を抽出)
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
@[1-10](filter(isOdd()))
@[11-15](map(divide(2)))
@[16-20](map(multiply(5)))
@[21-25](filter(isMoreThan(10)))
