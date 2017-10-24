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
        .collect(Collectors.asList());
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
@[7-8](50より大きくなった値を新しいリストに追加する)


