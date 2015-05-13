# スプライトの衝突判定動作テスト
 
require 'dxruby' # ライブラリ読み込み
require './sprite_jiki.rb' # 自機クラス読み込み
require './sprite_jikibullet.rb' # 自機弾クラス読み込み
require './sprite_enemy.rb' # 敵クラス読み込み
require './sprite_enemybullet.rb' # 敵弾クラス読み込み
 
font = Font.new(12) # スプライト数の表示用フォント
fontback = Image.new(192, 32, [100,100,100]) # 背景用

bg = Image.load("img1.jpg") # 背景イメージ読み込み

bgm1 = Sound.new("stg1.mid")# BGM読み込み

# 度→ラジアン変換
def deg2rad(deg) # degって何かと思ったらdegrees。弧度法 度数法。ラジアン = 度 × 円周率 ÷ 180 
  return deg * Math::PI / 180.0 # まさにそのまま式にしているだけ。どうやらPythonにはMath.Radiansとかあるらしいが、Rubyにはないらしいのです。
end # 変換メソッド自作完了

# zキーのオートリピート設定
Input.setKeyRepeat( K_Z, 10, 2 ) # 自機弾発射用

# shiftキーのオートリピート設定
Input.setKeyRepeat( K_LSHIFT, 1, 1 ) # 自機速度調整用

# ----------------------------------------

# メイン

srand(0) # module function Kernel.#srand。毎回同じランダムデータの連続を生成することが出来る。
 # 毎回異なる数字が出るようにしたくなったら、srand 0とすればよい
 # でもこれどこで使ってるの？？
def gameInit
  $players = [] # 自機の配列。配列な意味があるのか不明。被弾後は配列の追加削除としてるのか？
  $shots = [] # 自機弾の配列。
  $enemys = [] # 敵の配列。
  $eshots = [] # 敵弾の配列。未実装で、今から勝手に実装する予定。
  $hitcount = 0 # 被弾カウンタ。初期値は０
  $lifecount = 4 # ライフカウンタ。初期値は１００
  $enemylife = 10 # 敵ライフカウンタ。初期値は１０
  $debugflg = false # debugフラグ。何か今後見たい裏の数字があった場合は見る為の処理
  
  $players.push(Player.new(300, 300)) # ループ外の初期処理、トップレベルの処理として、自機の生成。
  2.times {|i| $enemys.push(Enemy.new(1))} # 同じくトップレベルで、敵の生成。８体だけみたい。
  # 引数は確かスピード？そうそう、スピードのようです。→速度落としました。
end

gameInit # ゲームシーン切り替え毎に必要な初期化をまとめたものについて実行

in_pause = false # ポーズ中か判定、初期値はポーズなし。

$state = "gamestart" # 先ずゲームスタートシーンへご案内。

#def bgmmgr
#  bgm1.start = 5000 # BGM開始
#  bgm1.setVolume 255
  bgm1.play
#end

 #####################################################################
 
Window.loop do # 1/60のメインループ開始。
  case $state
  when "game" # ゲーム中だったらこちら
  
  break if Input.keyPush?(K_ESCAPE) # esc終了判定
  
  Window.draw(0, 0, bg, -1)
  
  update_enable = false # 更新オンオフ。ループ始めにフラグを立てる
  if in_pause # オブジェクトがブール値だとこういう書き方も可能なのか。真の場合ということ
    # ポーズ中。前回のループでポーズを押した場合はこちらへ。
 
    # Nキー押しで1フレーム進める
    update_enable = true if Input.keyPush?(K_N) # 一周分だけ進めるようフラグを折る。
 
    # Pキーを押したらポーズ解除
    in_pause = false if Input.keyPush?(K_P) # 更新に進めるようフラグを折る。
  else # 通常のループはこちら。偽の場合ということ
    # 通常処理
    in_pause = true if Input.keyPush?(K_P) # Pキーを押したらポーズ。次のループで更新が止まる。
    update_enable = true unless in_pause # unlessですね。ifの逆。条件が偽であればその処理へ。
     # 今回はポーズ中じゃなかったら更新を許可する。
  end # ポーズ判定end。すると更新判定が毎週毎週って忙しいな。処理速度は大丈夫なのかな？
 
  if update_enable # 更新オンならこちらへ
    # プレイヤーの弾と雑魚敵の衝突判定
    Sprite.check($shots, $enemys) # 自機弾が敵を撃った場合はこちら。
 
    # 雑魚敵とプレイヤーの衝突判定
    Sprite.check($enemys, $players) # 敵が自機に衝突した場合はこちら。
 
    # 敵弾とプレイヤーの衝突判定
    Sprite.check($eshots, $players) # 敵弾に自機が撃たれた場合はこちら。
 
    Sprite.update($players) # 自機を更新
    Sprite.update($shots) # 自機弾を更新
    Sprite.update($enemys) # 敵を更新
    Sprite.update($eshots) # 敵弾を更新
 
    Sprite.clean($shots) # 自機弾を掃除
    Sprite.clean($enemys) # 敵を掃除
    Sprite.clean($eshots) # 敵弾を掃除
    Sprite.clean($players) # 自機を掃除
  end # 更新処理end
 
  Sprite.draw($enemys) #敵描画 
  Sprite.draw($players) # 自機描画。この順番に拘りはあるのだろうか？
  Sprite.draw($shots) # 自機弾描画
  Sprite.draw($eshots) # 敵弾描画
 
  # 左上にスプライト数を表示する為の処理。そろそろ表示関係もクラスにまとめたい。
  l = $players.length + $shots.length + $enemys.length + $eshots.length # 現在の配列要素数を取得
  Window.drawFont(0, 0, "Sprs: " + ('[]' * l), font) # 画面左上端にスプライツ＋[]を配列要素数だけ表示
  Window.drawFont(0, 16, "PAUSE", font) if in_pause == 0 # ポーズ中だったら画面左端上からちょっとしたにpauseと表示
  # これうまく働いていない？
  Window.drawFont(0, 32, "hit: " + $hitcount.to_s, font) # 被弾カウンタ
  Window.drawFont(0, 48, "life: " + $lifecount.to_s, font) # ライフカウンタ
  Window.drawFont(0, 64, "enemy: " + $enemylife.to_s, font) # 敵ライフカウンタ
  Window.drawFont(0, 80, "Sprs: " + l.to_s, font) # 画面左上端に配列要素数表示
  
  # debug # 仮実装。今後一層ほしくなる気がする機能。

  # d判定
  if $debugflg # 
    # 前回のループでdを押した場合はこちらへ。
    Window.drawFont(0, 96, "jikispd: " + $players[0].spd.to_s, font) # 

    # dキーを押したらdebug解除
    $debugflg = false if Input.keyPush?(K_D) # フラグを折る。
  else # このループではdebugモードじゃなかったらこちら
    $debugflg = true if Input.keyPush?(K_D) # このループの中でdを押したらフラグを折り、次のループから変数表示
  end # debug処理end
  
 #####################################################################
  
  when "gameover" # スペース入力待ち。一応ゲームオーバー画面。
    Window.draw(0, 72, fontback, 9) # 
    Window.drawFont(64, 80, "Game Over. Push Space", font, :color=>[255,255,255,255],:z=>10) # 
    $state = "gamestart" if Input.keyPush?(K_SPACE) # 
    gameInit # 

 #####################################################################
  
  when "enemydown" # スペース入力待ち。一応エンディング画面。
    Window.draw(40, 112, fontback, 9) # 文字の背景の四角
    Window.draw(40, 132, fontback, 9) # 文字の背景の四角
    Window.drawFont(64, 120, "Enemy down ! Congratulations !", font, :color=>[255,255,255,255],:z=>10) # 
    Window.drawFont(64, 140, "Push Space", font, :color=>[255,255,255,255],:z=>10) # 
    $state = "gamestart" if Input.keyPush?(K_SPACE) # 
    gameInit # 

 #####################################################################

  when "gamestart" # スペース入力待ち。スタート画面。
    Window.draw(0, 92, fontback, 9) # 文字の背景の四角
    Window.drawFont(64, 100, "Let' Start. Push Space", font, :color=>[255,255,255,255],:z=>10) # スタート促すメッセージ
    $state = "game" if Input.keyPush?(K_SPACE) # スペースでゲーム開始
  end # シーン管理end。いずれクラス化。
  
 #####################################################################
  
end # メインループend
 