# スプライトの衝突判定動作テスト
 
require 'dxruby' # ライブラリ読み込み
 
# ----------------------------------------

# プレイヤーキャラ

class Player < Sprite # スプライトクラス継承
  attr_accessor :bx, :by, :shottimer, :hit_timer, :flush_image, :highspd, :lowspd, :spd
   # クラス内公開変数。座標、発射間隔変数、撃たれた時の停止時間変数、撃たれたイメージ
 
  # 初期化処理
  def initialize(x, y) # 初期化時の処理。引数はそのタイミングの二次元座標
    super # スプライトクラスのイニシャライズ処理の後に、以下を追記
    self.bx = x # 現在座標を変数に格納
    self.by = y # 現在座標を変数に格納
    self.image = Image.load("jiki.png") # イメージ読み込み
    self.flush_image = Image.load("jiki_flush.png") # 撃たれたイメージ読み込み
    self.shottimer = 0 # 自動発射自機弾の間隔変数。初期値は０
    self.collision = [16, 16, 4] # アタリ範囲を設定。三引数なので
     # 要素3つの配列で[x, y, r]・・・中心(x, y)から半径rのサイズの円。8ドットか、、、でかいな
    self.hit_timer = 0 #  停止時間変数。初期値は０
    self.highspd = 6 # 自機の基本速度
    self.lowspd = 1.5.to_f # 自機のシフト時速度
    self.spd = 6 # 自機の現在の速度
 
    # self.offset_sync = true # DXRuby開発版でのみ使えるプロパティ
  end # 初期化end
 
  def update # 1/60秒毎の処理
    w, h = self.image.width, self.image.height # 画像の大きさ取得。多重代入
    # shift判定
    if Input.keyPush?(K_LSHIFT) # shift押してたら
      self.spd = self.lowspd # speed down
    else # shift押してなかったら
      self.spd = self.highspd # speed up
    end # shift判定end
    
    # マウスカーソル座標を自機座標にする
    # →キーボード操作に変更
    # self.bx = Input.mousePosX # 自機座標はマウスカーソルとする
    # self.by = Input.mousePosY # 自機座標はマウスカーソルとする
    self.bx += Input.x.to_f * self.spd.to_f # 自機座標はキー操作とする。5/7で速度部分を変数化。
    self.by += Input.y.to_f * self.spd.to_f # 自機座標はキー操作とする。5/7で速度部分を変数化。
 
    xmin, ymin = 0, 0 # 画面左上
    xmax, ymax = Window.width, Window.height # 画面右下
    self.bx = xmin if self.bx < xmin # 現在座標が左端突っ切ってたら戻す
    self.by = ymin if self.by < ymin # 同じく上突っ切り判定
    self.bx = xmax if self.bx > xmax # 右判定
    self.by = ymax if self.by > ymax # 下判定
 
    # if self.shottimer % 10 == 0 # 10の倍数毎に発射ということらしい。詰まり、3wayを秒間6発？
      # 自機ショットを発射
    #  [270, 30, 150].each do |i| # 角度固定の3way弾
    #    spr = Shot.new(self.bx, self.by, 16, i + self.bx / 4)
         # スプライトクラス継承のshotインスタンス作成。(x, y, spd, angle)だそうです。
         # やっぱり発射角度は自分の横軸で動く設定みたいだね。
    #    $shots.push(spr) # グローバル変数というか自機弾の配列について、作成したインスタンスを最後尾に追加。
    #  end # 3way弾、自発装填、完了
    #end # 自動発射完了
 
    # Zキー判定
    if Input.key_push?(K_Z) # Zで発射
      spr = Shot.new(self.bx, self.by, 16, 270) # 自機弾objに、現在の時期座標、弾速度、角度を入れて生成。
      $shots.push(spr) # 自機弾配列に生成した弾objを配列の最後に追加
    end # 自発装填、完了

    self.shottimer += 1 # 一周毎に発射間隔変数をカウントアップ
    # self.angle += 8 #  # 一周毎に自機の角度をカウントアップ。割と早め。1/60秒で8ということで、、
    # GW_v005：回転廃止
 
    if self.hit_timer > 0 # 撃たれた判定。変数が正ならこちらへ
      self.hit_timer -= 1 # カウントダウン
      self.hit_timer = 0 if self.hit_timer <= 0 # カウンタが０まで来たら、０を設定
    else # カウントダウン済んでたら
      self.hit_timer = 0 # ０か負だったら、０を設定。一応負にはならないはずだけどね
    end # 撃たれた判定end
 
    # 基準座標＋オフセット値を表示座標とする。
    # DXRuby開発版なら、self.offset_sync = true で済んでしまうのだけど、
    # 開発版は Ruby 1.8 や 1.9 に対応してないので…
    self.x = self.bx - w / 2 # どうやらオフセット値対応らしい。
    self.y = self.by - h / 2 # 表示位置、匠の細やかな気配りということですね
  end # 周回更新処理end
 
  # 雑魚敵と当たった時に呼ばれる処理。または被弾時の処理。
  def hit(o) # こっちは、攻撃された側の時の処理。
    self.hit_timer = 4 # ここでは特に実処理はせず、ただタイマーを設定するだけ。
    $hitcount += 1 # 被弾カウンタをカウントアップ
    $lifecount -= 1 # ライフカウンタをカウントダウン
    if $lifecount == 0 # 自機ライフがなくなったら
      $state = "gameover" # ゲームオーバーシーンへ。
      $debugflg = false # spd表示したままvanish, cleanしちゃうと、表示したいものがnilになりゲームが落ちる為
      self.vanish # 自機の初期化の為。clean対象化。
    end # 自機ライフ確認end
  end # 被弾処理end。ここでのタイマー設定で、次の週で被弾カウンタが正なのでカウントダウンへ回る。
 
  def draw # 描画処理
    super # 継承元スプライトクラスのメソッドに追記します。なので、通常の自機はここで描画済。
    if self.hit_timer > 0 # 被弾カウンタが回っていた場合はこちらへ
#      Window.drawScale(self.x, self.y, self.flush_image, 3, 3)爆発エフェクトを拡大表示してたみたい。
      Window.draw(self.x, self.y, self.flush_image) # 明度上げただけの画像をそのまま表示。被せちゃってるけど普段のもその下にいるはず。
    end # 被弾時の処理済。なので、例えばここで爆発とかぴちゅーん入れるとかかな？
     # ってかぴちゅりを入れようとすると、普通の描画は、、まあ良いのかな？
  end # 描画end
end # 自機クラスend
 