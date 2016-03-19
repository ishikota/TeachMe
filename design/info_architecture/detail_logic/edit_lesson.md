# 授業の編集

## Adminユーザの編集フロー
1. adminユーザでログイン
2. 管理者画面に進む
3. 編集権限のある授業一覧から編集したい授業をクリック
4. タイトル,曜日,何限,タグ,受講者の追加ボタン,受講者の削除ボタンで編集
5. 編集の完了をクリック

## アプリ側の処理
編集する前に以下validationを行う
```
user.admin && lesson.editor.id == user.id
```

1. タイトル,曜日,何限,はそのまま更新
2. タグは更新ロジックに沿って更新
3. 受講者の追加は作成の時と同じ,削除はSubscriptionのRelationshipを消すだけ.

### タグ更新ロジック
```
old = クラスに紐づく全タグ
new = テキストフィールドのカンマ区切りワードを配列にパースしたもの
create_tags = new - old (Not in old but in new)
delete_tags = old - new (Not in new but in old)

for tag in create_tags
  Tag.new(content: tag)
end
for tag in delete_tags
  Tag.where(content: tag).destroy
end
```

