# 質問の投稿
- 質問を投稿できるのは，その授業の受講者のみ．
  - 1年生の授業に3年生がコメントみたいに，外部の人が解決するのでなく，生徒同士で助け合って欲しい
- 受講してない人には，投稿ボタンを表示しない

## 投稿フロー
1. 授業ページで，タイトル，タグ1つ(その他含めて必須にする=絞り込みのため),詳細を入力
2. 投稿ボタンをクリック

## アプリ側のロジック
`user.post_question(lesson_id, title, tag, description)を呼ぶ`

0. userがlessonをsubscribeしていることをチェック
1. questionの作成
2. tag-questionのRelationship作成
