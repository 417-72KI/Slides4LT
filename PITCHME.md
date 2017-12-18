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
/**
 * Calls the specified function [block] with `this` value as its argument and returns its result.
 */
public inline fun <T, R> T.let(block: (T) -> R): R = block(this)
```

with

```Kotlin
/**
 * Calls the specified function [block] with the given [receiver] as its receiver and returns its result.
 */
public inline fun <T, R> with(receiver: T, block: T.() -> R): R = receiver.block()
```

---

apply

```Kotlin
/**
 * Calls the specified function [block] with `this` value as its receiver and returns `this` value.
 */
public inline fun <T> T.apply(block: T.() -> Unit): T { block(); return this }
```

run

```Kotlin
/**
 * Calls the specified function [block] with `this` value as its receiver and returns its result.
 */
public inline fun <T, R> T.run(block: T.() -> R): R = block()
```

---

also

```Kotlin
/**
 * Calls the specified function [block] with `this` value as its argument and returns `this` value.
 */
public inline fun <T> T.also(block: (T) -> Unit): T { block(this); return this }
```

---

どうやって使うの？

---

例えばさっきのこれ

```Java
class Hoge {
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

---

正しくはこう

```Java
class Hoge {
    public int a;
    public int b;
}

Hoge h1 = new Hoge();
h1.a = 1;
h1.b = 2;
Hoge h2 = new Hoge();
h2.a = 3;
h2.b = 4;
```

---

これをKotlinで書くと

```Kotlin
class Hoge {
    var a: Int = 0
    var b: Int = 0
}

val h1 = Hoge()
h1.a = 1
h1.b = 2
val h2 = Hoge()
h2.a = 3
h2.b = 4
```

これを

---

こうじゃ

```Kotlin
class Hoge {
    var a: Int = 0
    var b: Int = 0
}

val h1 = Hoge().apply {
    a = 1
    b = 2
}
val h2 = Hoge().also {
    it.a = 3
    it.b = 4
}
```
@[6-9](初期化されたオブジェクト自体がレシーバになる)
@[10-13](初期化されたオブジェクトが引数として渡される(渡されたオブジェクトは `it` で呼べる))

---

更に

```Kotlin
val h1 = Hoge().apply {
    a = 1
    b = 2
}
doSomethingWith(h1)
```

これが

---

こうじゃ

```Kotlin
Hoge().apply {
    a = 1
    b = 2
}.let {
    doSomethingWith(h1)
}
```
@[1-6](生成されたオブジェクトが変数に格納されないのでこの後使われることを想定しなくて良い)
@[1](オブジェクトを生成して)
@[2-3](プロパティ設定して)
@[4-6](ここで使う！)

---

つまり

---

オブジェクトに対して使用するスコープを限定できる！

---

だから  
「スコープ」関数

---

メリット
- どのオブジェクトに対する操作なのかが分かりやすくなる
- 操作対象のオブジェクトをミスる確率が格段に減る
- 変数名で消耗しなくなる←

---

デメリット

---

・・・

---

あれ、思いつかない←

---

強いて言うなら

---

Kotlinの言語仕様をそこそこ深く理解する必要がある  
(プログラミング初心者には向かない)

---

※注意

---

各関数で出来ることは同じですが、  
当然その使い道・役回りは違います。

(今回は時間無くなりそうなので省略しますが、  
[ここ](https://speakerdeck.com/ntaro/detakurasufalsehua-sukopuguan-shu-falsehua-number-rkt)とか参考にするといいかも)

---

まとめ

---

スコープ関数を活用して皆もKotlinマスターになろう！

<span style="font-size: 80%;">(´-`).｡oO(他の言語でもこういうの用意してくれないかなぁ</span>

---
