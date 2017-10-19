### Collection操作の罠
Swift & Kotlin 編
+++
突然ですが
+++
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
+++
これがJava8になって
```Java
List<Integer> list = ...
List<Integer> evenList = list.stream()
        .filter(num -> num % 2 == 0)
        .collect(Collectors.asList());
```
+++
超簡潔！
+++
分かりやすい！
+++
これがSwiftだと
```Swift
let list = [1,2,3,4,...]
let evenList = list.filter { $0 % 2 == 0 }
```
たったこれだけ
