# Movable Type JSON Comma plugin

Add `mt:JSONComma` function tag for Movable Type.

JSON データをテンプレートで作るときに、面倒くさいカンマ（`,`）の処理をほんのちょっとだけ楽にする Movable Type プラグイン。

## インストール
下記のような配置になるように、`JsonComma` ディレクトリ以下を Movable Type のインストールディレクトリに設置してください。

```
$MT_DIR/
 └ plugins/
    └ JsonComma/
       ├ config.yaml
       └ lib/
          └ MT/
            └ Plugin/
              └ JsonComma.pm
```

## 追加されるファンクションタグ

```
<$mt:JsonComma$>
```

## 使い方

例えば、`<mt:Entries>` や `<mt:Categories>`、`<mt:Pages>` などのブロックタグで JSON を作るとき、下記のようにループの最後だけカンマが出力されないようにする必要があります。

```json
<mt:Entries>
  {
    "title": "<$mt:EntryTitle encode_json="1"$>",
    "author": "<$mt:EntryAuthor encode_json="1"$>"
  }<mt:Unless name="__last__">,</mt:Unless>
</mt:Entries>
```

`<$mt:JsonComma$>` ファンクションタグを使用することで下記のように書けます。

```json
<mt:Entries>
  {
    "title": "<$mt:EntryTitle encode_json="1"$>",
    "author": "<$mt:EntryAuthor encode_json="1"$>"
  }<$mt:JsonComma$>
</mt:Entries>
```

また、`<mt:TopLevelCategories>` （`<mt:SubCategories top="1">` も同じ）に関しては、`__last__` などの予約変数が取得できない（なんで？）ため、下記のように `<mt:SubCatIsLast>` タグなどを使う必要があります。

```json
<mt:TopLevelCategories>
<mt:SetVar name="comma" value=",">
<mt:SubCatIsLast><mt:SetVar name="comma" value=""></mt:SubCatIsLast>
  {
    "label": "<$mt:CategoryLabel encode_json="1"$>",
    "path": "<$mt:CategoryBasename encode_json="1"$>",
    "link": "<$mt:CategoryArchiveLink encode_json="1"$>",
  }<$mt:Var name="comma"$>
</mt:TopLevelCategories>
```

`<$mt:JsonComma$>` ファンクションタグを使用することで下記のようにシンプルに書けます。

```json
<mt:TopLevelCategories>
  {
    "label": "<$mt:CategoryLabel encode_json="1"$>",
    "path": "<$mt:CategoryBasename encode_json="1"$>",
    "link": "<$mt:CategoryArchiveLink encode_json="1"$>",
  }<$mt:JsonComma$>
</mt:TopLevelCategories>
```

下記のように、`<mt:TopLevelCategories>` （`<mt:SubCategories top="1">` も同じ）内で、`<mt:Entries>` をネストして使用した場合でも `<$mt:JsonComma$>` ファンクションタグが動作するようにはしています。

```json
<mt:SubCategories top="1">
  {
    "label": "<$mt:CategoryLabel encode_json="1"$>",
    "path": "<$mt:CategoryBasename encode_json="1"$>",
    "link": "<$mt:CategoryArchiveLink encode_json="1"$>",
    "entry": [
    <mt:Entries lastn="0">
      {
        "title": "<$mt:EntryTitle encode_json="1"$>",
        "author": "<$mt:EntryAuthor encode_json="1"$>"
      }<$mt:JsonComma$>
    </mt:Entries>
    ]
  }<$mt:JsonComma$>
</mt:SubCategories>
```

## 注意点

`<mt:Entries>` と `<mt:EntryCategories>` を下記のようにネストしているときに、ネストされた `<mt:EntryCategories>` 内で `<$mt:JsonComma$>` を使うとうまく行かない（`<mt:Entries>` の最後のループ内は、`<mt:EntryCategories>` 内にカンマが全く出力されない）です。

原因はわかってるんですが、直すの面倒くさいのと、下記の例の様に `glue=","` を使用すれば解決するので、もしうまく行かなかった場合は参考にしてください。

```json
<mt:Entries>
  {
    "title": "<$mt:EntryTitle encode_json="1"$>",
    "author": "<$mt:EntryAuthor encode_json="1"$>"
    "category": [
      <mt:EntryCategories glue=",">
      {
        "label": "<$mt:CategoryLabel encode_json="1"$>",
        "path": "<$mt:CategoryBasename encode_json="1"$>",
        "link": "<$mt:CategoryArchiveLink encode_json="1"$>",
      }
      </mt:EntryCategories>
    ]
  }<$mt:JsonComma$>
</mt:Entries>
```

その他、すべてのブロックタグの入れ子の組み合わせで試していないので、うまくいったりいかなかったりする場合があると思います。そういう時は別の方法を考えてください。
