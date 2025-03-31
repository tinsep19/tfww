# tfww (Terraform Workspace Wrapper)

`tfww` は、Terraform の workspace 機能を簡単に扱うためのシェルスクリプトです。Terraform を規約に沿ったディレクトリ構成で使用できるようにラップし、ワークスペースの切り替えと適用をシンプルに行えます。

## 期待するディレクトリ構成

```
+ (project-root)
  + envs/${workspace}.tfvars
  + main.tf
  + some.auto.tfvars
```

Terraform の workspace 機能を使用していて、その環境差分が `tfvars` ファイルですべて表現できる場合に、`${workspace}.tfvars` ファイルを作成し、`envs` ディレクトリに配置します。

## 使い方

1. `tfww` スクリプトを使用して、Terraform のワークスペースを自動的に切り替え、適用を実行できます。

   ```sh
   tfww apply envs/${workspace}.tfvars
   ```

   これは、以下の2つのコマンドを自動で実行するのと同じです。

   ```sh
   terraform workspace select ${workspace}
   terraform apply -var-file=envs/${workspace}.tfvars
   ```

2. その他の Terraform コマンドも `tfww` 経由で実行できます。

   ```sh
   tfww plan envs/${workspace}.tfvars
   tfww destroy envs/${workspace}.tfvars
   ```

## インストール

1. [GitHub Releases](https://github.com/tinsep19/tfww/releases) から最新のバイナリをダウンロードします。

2. ダウンロードしたバイナリに実行権限を付与します。

   ```sh
   chmod +x tfww
   ```

3. パスの通ったディレクトリに配置することで、どこからでも使用できるようになります。

   ```sh
   mv tfww /usr/local/bin/
   ```

4. Bash 補完を有効にするには、以下のコマンドを実行します。

   ```sh
   eval "$(tfww completions)"
   ```

   シェルの起動時に自動で補完を有効にするには、`.bashrc` や `.bash_profile` に追記してください。

   ```sh
   echo 'eval "$(tfww completions)"' >> ~/.bashrc
   ```

## 貢献方法

バグ報告や機能追加の提案は Issue にて受け付けています。また、プルリクエストも歓迎します。

## ライセンス

このプロジェクトは MIT ライセンスのもとで公開されています。詳細は [LICENSE](./LICENSE) を参照してください。
