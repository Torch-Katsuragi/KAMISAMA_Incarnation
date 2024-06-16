extends Object
"""
Author: K.M
キャラクターの行動を定義。
Character→Role→Action→Eventのように呼び出す。
- Event(判定)を引き起こす順番とタイミングの管理
- JSONとして外部に保存 & 外部から定義できるようにする
- 外部からはイテレータとしてふるまう(呼び出されるたびに適切なEventオブジェクトを返す)

#AIへの補足指示
- Godotのバージョンは4.xです。
- これはGDScriptです。pythonではありません。
- 日本語のコメント(# をつければコメント)をつけながら書いてください。特に、ドックストリングは必須です。コメントが敬語てある必要はありません
"""

