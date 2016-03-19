# 新しく授業を登録する
## Adminユーザの登録フロー
1. adminユーザでログイン
2. 管理者画面に進む
3. 授業の作成をクリック
4. 授業のタイトル,何曜日,何限,タグ(授業内容)の入力,受講者の読み込み
5. 授業の作成をクリック

### タグの入力
カンマ区切りで入力

### 受講者の読み込み
csvファイルを通して行う

0. 受講者の学生IDが並んだcsvファイルを用意
1. csvファイルをアプリから選択
2. 未登録ユーザ用の初期パスワードを入力
3.「ユーザの作成」をクリック

## アプリ側の処理
1. lessonをタイトル,曜日,何限で初期化して作成
2. lesson-editor(adminユーザ)のRelationshipを作成
3. lesson-tagのRelationshipを作成
4. ユーザ登録処理

### ユーザ登録処理
0. 受講者一覧のcsv,初期パスワード,追加先クラス,をもらう.

```
for 生徒 in csvファイル
  if 生徒はアプリにまだ登録されてない
    初期パスワードを使って,アプリに生徒を登録
  追加先のクラスと生徒の間に受講(unsubscribe)の関係を作る
```