### PITCHMEチートシート

---
\-\-\-でページ切り替え(横)
\+\+\+でページ切り替え(縦)
---
### 画像
&lt;img src="assets/img/map.jpg"&gt;
+++
<img src="assets/img/map.jpg">
---
### 箇条書き
- 通常のMarkdownと同じ
- 但し |
- 末尾に \| を付けると |
- 1行ずつアニメーションに |
---
### コードブロック
```Swift
print("@[1]でここがハイライト")
print("@[2-4]でここから")
print()
print("ここまでハイライトされる")
print("@[]の右にハイライト行の解説を書ける")
```
@[1](こんな)
@[2-4](感じ)
---
### 設定ファイル
PITCHME.yamlで設定
+++
### theme
- black
- moon
- night
- beige
- sky
- white
+++
### transition
- convex
- concave
- default
- fade
- none
- slide
- zoom
+++
### slide-number
- trueで右下に出る
+++
### footnote
- 何か書くと左下に出る
+++
### autoslide
- 単位: ms
- 設定すると自動でスライドが流れるようになる
