# コメントの投稿
- 質問を投稿できるのは，その授業の受講者のみ
- 受講してない人には，投稿用のviewを表示しない

## ユーザのフロー
1. コメント一覧ページで，コメント(content)を入力して，投稿ボタンを押す

## アプリ側のロジック
`user.post_comment(lesson_id, content)`

0. userがlessonをsubscribeしていることをチェック
1. commentの作成
