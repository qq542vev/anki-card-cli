<!-- Document: README.md

「暗記カード生成器CLI」の日本語マニュアル。

Metadata:

	id - 883bde28-39ee-41e1-a590-856098045489
	author - <qq542vev at https://purl.org/meta/me/>
	version - 0.2.0
	created - 2020-09-04
	modified - 2025-11-12
	copyright - Copyright (C) 2025-2025 qq542vev. Some rights reserved.
	license - <AGPL-3.0-only at https://www.gnu.org/licenses/agpl-3.0.txt>
	conforms-to - <https://spec.commonmark.org/current/>

See Also:

	* <Project homepage at https://github.com/qq542vev/anki-card-cli>
	* <Bug report at https://github.com/qq542vev/anki-card-cli/issues>
-->

# 暗記カード生成器CLI

CSVから暗記カード用のHTML / PDFを生成するNode.js CLIツールです。内部的にはheadless Chromiumを起動し、[暗記カード生成器](https://purl.org/meta/anki-card/)を読み込んでレンダリングした結果を出力します。

## 概要

このツールは次の機能を提供します。

 * PDF / HTMLを生成する。
 * 入力対応した暗記カード生成器のURLを出力する。
   * そのURLをWebブラウザーで開く。
 * 複数CSVを連結するユーティリティ関数を備え、標準入力や複数ファイルを扱える。
 * Puppeteerの起動オプションやページの余白・用紙サイズ・ヘッダー / フッターなど細かいPDF設定に対応。
 * 出力をファイルに保存または標準出力に流すことが可能。
 * 内部でエラー分類を行い、sysexitsに対応した終了コードを返します。

## 動作環境

 * Node.js(LTS推奨, Node.js>=18推奨)が利用可能であること。
 * `npm`または`npx`が利用可能であること。

puppeteerによりChromiumが自動的にダウンロードされます。既存のChromium / Google Chromeを使う場合は`--chrome-path`でパスを指定してください。

## インストール

グローバルにインストールする場合:

```sh
npm install -g anki-card
```

ローカルにインストールしてnpxで実行する場合:

```sh
npm install anki-card
npx anki-card --help
```

開発用にソースをチェックアウトして使う場合は依存をインストールしてください:

```sh
npm ci
node index.js --help
```

## 使い方

```sh
Usage: anki-card [options] [csvfile...]
```

## CLIオプション

以下はオプションの説明です。全てのオプションは任意のオプションです。オプションは[POSIX形式とGNU形式](https://www.pearsonhighered.com/assets/samplechapter/0/1/3/1/0131429647.pdf)の両方に対応しています。

 * カードテーブルオプション
   * `-b, --border <border>`: テーブルの内側・外側のボーダー幅。カンマ区切りで最大2つの正の実数を指定します。実数の後ろには任意で単位をつけることが可能です。既定の単位は`mm`です。既定値は`0.3mm,0mm`です。
   * `-c, --css <css>`: カードテーブルに追加適用するCSSを指定します。既定値は空文字列です。
   * `-f, --font-size <font-size>`: カードの表面・裏面のフォントサイズ。カンマ区切りで最大2つの正の実数を指定します。実数の後ろには任意で単位をつけることが可能です。既定の単位は`pt`です。既定値は`22pt,18pt`です。
   * `-m, --matrix <matrix>`: カードテーブルの行数・列数。カンマ区切りで最大2つの正の整数を指定します。既定値は`6,4`です。
   * `-r, --rev <rev>`: 裏面ページの反転方向。次の値が指定可能です。既定値は`horizontal`です。
     * `horizontal`:  水平方向に反転。
     * `vertical`: 垂直方向に反転。
     * `both`: 対角線上に反転。
     * `none`: 反転なし。
   * `-s, --size <size>`: カードテーブルの横幅・縦幅。寸法名またはカンマ区切りで最大2つの正の実数を指定します。実数の後ろには任意で単位をつけることが可能です。既定の単位は`mm`です。既定値は`297mm,210mm`です。
   * `-u, --url <url>`: 処理対象のURL。`http://`, `https://`, `file://`, `data:`などが指定可能です。値が絶対URLではない場合、ローカルのファイルパスと解釈され、File URLに変換されます。既定値は暗記カード生成器内の`index.html`のFile URLです。
   * `--html` / `--no-html`: CSV内のHTMLの有効 / 無効を切り替え。
 * PDFオプション
   * `-F, --format <format>`: PDFページの横幅・縦幅。寸法名またはカンマ区切りで最大2つの正の実数を指定します。実数の後ろには任意で単位をつけることが可能です。既定の単位は`mm`です。既定値は`297mm,210mm`です。
   * `-M, --margin <margin>`: ページのマージン。カンマ区切りで最大4つの非負実数を指定します。数値の順番はCSSの[`margin`](https://developer.mozilla.org/ja/docs/Web/CSS/margin#%E6%A7%8B%E6%88%90%E8%A6%81%E7%B4%A0%E3%81%AE%E3%83%97%E3%83%AD%E3%83%91%E3%83%86%E3%82%A3)の指定と同じです。実数の後ろには任意で単位をつけることが可能です。既定単位は`mm`です。既定値は`0mm`です。
   * `-S, --scale <scale>`: 出力内容の縮尺。2以下の正の実数を指定します。既定値は`1`です。
   * `-T, --title <title>`: PDF / HTMLのタイトル。タイトルを変更したい場合に指定します。
   * `--header <template>` / `--footer <template>`: ヘッダ / フッタのテンプレート(HTML文字列)。既定値は`<div></div>`です。
 * ブラウザーオプション
   * `-p, --chrome-path <path>`: Chromium / Google Chromeの実行ファイルパス。既定値はPuppeteerによってインストールされたChromiumのパスです。
   * `-a, --chrome-arg <arg>`: Chromium / Google Chromeのコマンドライン引数(複数回指定可)。
   * `-t, --timeout <msec>`: ブラウザーの起動やページ読み込み等におけるタイムアウト(ミリ秒)。 非負整数を指定します。既定値は`60000`です。
 * 出力オプション
   * `--action <mode>`: 動作モード。次の値が指定可能です。既定値は`pdf`です。
     * `url`: 暗記カード生成器のURLを出力します。
     * `browser`: URLをWebブラウザーで開きます。
     * `html`: HTMLを出力します。
     * `pdf`: PDFを出力します。
   * `-o, --output <output>`: 出力ファイル名。`-`を指定すると標準出力に書き出します。既定値は`-`です。
 * 情報オプション
   * `-h, --help`: ヘルプメッセージを出力して終了します。
   * `-V, --version`: バージョン情報を出力して終了します。

寸法名はISO AからISO C列などが指定可能です。寸法名の後ろに`:L`をつけて横向きの寸法も指定可能です。

単位には`mm`, `cm`, `m`, `pc`, `pt`, `in`, `ft`, `px`が指定可能です。

## CSV

CSVを読み込んで、カードテーブルを生成します。コマンドライン引数では任意の数のCSVファイルを指定できます。CSVファイルの指定がない場合は標準入力から読み込みます。読み込んだCSVファイルは連結して処理されます。`-`を指定することで標準入力から読み込みます。

CSVの形式については[暗記カード生成のREADME.md](https://github.com/qq542vev/anki-card/blob/master/README.md)を参照してください。

## 終了ステータス

正常に終了した場合は`0`を、異常終了の場合はエラーメッセージを標準エラー出力に書き出すとともに、`0`以外の値を返します。終了ステータスの値は[sysexits](https://man.freebsd.org/cgi/man.cgi?sysexits)に対応しています。

## 使用例

ヘルプを表示:

```sh
anki-card --help
# または
npx anki-card --help
```

標準的なPDF出力の例:

```sh
npx anki-card -o cards.pdf cards.csv
```

HTML出力(生成されたHTMLを標準出力に吐く):

```sh
npx anki-card --action html -o - >out.html
```

ブラウザーで開く(標準入力から読み込む):

```sh
npx anki-card --action browser <cards.csv
```

複数CSVを連結して処理(標準入力とファイルから読み込む例):

```sh
cat b.csv | npx anki-card --action pdf -o cards.pdf a.csv - c.csv
```

A4横でPDFを出力:

```sh
npx anki-card --format A4:L -o cards.pdf cards.csv
```

マージンを指定してPDF出力:

```sh
npx anki-card -M 10mm,20mm,15mm,20mm -o cards.pdf cards.csv
```

ヘッダー / フッターを付与してPDF出力:

```sh
npx anki-card --header '<div style="font-size:10px">Header</div>' --footer '<div style="font-size:10px">Page <span class="pageNumber"></span>/<span class="totalPages"></span></div>' -o cards.pdf cards.csv
```

Docker/CI環境での利用(サンドボックス回避例):

```sh
npx anki-card --chrome-arg '--no-sandbox' --chrome-arg '--disable-setuid-sandbox' -o cards.pdf
```

## プログラムAPI(ライブラリ利用)

このモジュールはCLIだけでなくプログラムからも利用できます。`require('anki-card')`で主要関数を取得できます。

```js
const { generatePDF, generateHTML, concat } = require('anki-card');

(async () => {
  // CSVファイルを連結
  const csv = await concat(['a.csv', 'b.csv']); // '-'を含めるとstdinを読み込む
  // HTML取得
  const html = await generateHTML('file:///path/to/file.html#', {/* browserOpts */}, {/* gotoOpts */});
  // PDF取得 (Buffer)
  const pdfBuffer = await generatePDF('file:///path/to/file.html#', {/* browserOpts */}, {/* gotoOpts */}, {/* pdfOptions */});
  // Bufferをファイルへ保存
  require('fs').writeFileSync('out.pdf', pdfBuffer);
 })();
```

`generatePDF`はPuppeteerを用いてブラウザーを起動し、結果をBufferで返します。`generateHTML`はページコンテンツを文字列で返します。

詳細な仕様は[ドキュメント](https://qq542vev.github.io/anki-card-cli/modules.html)を参照してください。

## トラブルシューティング

 * Chromium起動に失敗する: `--chrome-path`でシステムのGoogle Chromeを指定するか、`--chrome-arg '--no-sandbox' --chrome-arg '--disable-setuid-sandbox'`を試してください。
 * PDFが白紙、あるいは要素が欠ける: `--timeout`を延ばしてページが完全に読み込まれるようにする、あるいは`--scale`や`--format`を調整してください。
 * 出力先に書き込めない(Permissions): 書き込み権限を確認するか、出力を`-`にして標準出力へ流し、別プロセスで受け取ることを検討してください。
 * 標準出力でバイナリを扱う際の注意: ターミナルやパイプでバイナリを扱う場合は適切にリダイレクトしてください。例: `npx anki-card --action pdf -o - > cards.pdf`。
