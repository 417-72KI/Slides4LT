### `Kotlin` のスコープ関数が素晴らしい件について

---

こういうことで悩んだ経験ありませんか？

---

```Java
class Hoge {
    // ※面倒なのでカプセル化は省略してます
    public int a;
    public int b;
}

Hoge h1 = new Hoge();
h1.a = 1;
h1.b = 2;
Hoge h2 = new Hoge();
h1.a = 3;
h1.b = 4;
```
@[1-5](クラス定義)
@[7-9](1個目のオブジェクトを生成して値を設定)
@[10-12](2個目のオブジェクトを生成して値を...)
@[11-12](...ん？)

---

違うオブジェクトに代入しとるやないかーい

---

そもそも `h1` とか `h2` とかｗｗｗｗｗ

---

けど変数名考えるのめんどくさいｗｗｗｗｗ

---

そこで

---

スコープ関数

---

### そもそも `Kotlin` って？

- JetBrains社が発表したJVMで動くプログラミング言語
- 2017年にAndroid公式言語として採用

---

### スコープ関数とは
- `Kotlin` の標準ライブラリにある5つの関数
    - let
    - with
    - run
    - apply
    - also

---

let

```Kotlin
public inline fun <T, R> T.let(block: (T) -> R): R = block(this)
```

with

```Kotlin
public inline fun <T, R> with(receiver: T, block: T.() -> R): R = receiver.block()
```

---

apply

```Kotlin
public inline fun <T> T.apply(block: T.() -> Unit): T { block(); return this }
```

run

```Kotlin
public inline fun <T, R> T.run(block: T.() -> R): R = block()
```

---

also

```Kotlin
public inline fun <T> T.also(block: (T) -> Unit): T { block(this); return this }
```

---

どうやって使うの？
