### Collection操作の罠
Swift & Kotlin 編
+++
突然ですが
+++
```Java
List<Integer> list = ...
List<Integer> evenList = new ArrayList<>();
for(int num: list) {
  if(num % 2 == 0) {
    evenList.add(num);
  }
}
```
+++
