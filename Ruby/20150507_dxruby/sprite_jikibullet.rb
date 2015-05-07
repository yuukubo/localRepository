# スプライトの衝突判定動作テスト
 
require 'dxruby' # ライブラリ読み込み。
  # %$LOAD_PATHが通っている為上記の記載で読み込みが完了出来る。

# ----------------------------------------

# プレイヤーの弾

class Shot < Sprite # スプライトクラス継承
  attr_accessor :bx, :by, :dx, :dy # クラス内公開変数。縦横斜めの情報かな
 
  def initialize(x, y, spd, angle) # 初期化時の処理
    self.bx = x # 横軸の位置を変数にセット
    self.by = y # 縦軸の位置を変数にセット
    self.image = Image.load("jiki_bullet.png") # イメージ読み込み
    self.dx = spd * Math.cos(deg2rad(angle)) # 横軸回転。じゃない。斜め移動量
    self.dy = spd * Math.sin(deg2rad(angle)) # 縦軸回転。じゃない。斜め移動量
    self.angle = angle # 角度
    self.collision = [0, 13, 31, 18] # 当たり判定（矩形）
    self.collision_enable = true # 当たり判定オンオフ。初期値オン。
    self.collision_sync = true # 当たり判定の回転オンオフ。初期値オン。
  end # 初期化end
 
  def update # 一ループごとの処理
    w, h = self.image.width, self.image.height # 画像の大きさ取得
    self.bx += self.dx # 画像位置に回転補正追加
    self.by += self.dy # 画像位置に回転補正追加
 
    # 画面外に出たら自分を消滅させる
    xmin = - w / 2 # 画像サイズの半分の負の値
    ymin = - h / 2 # 画像サイズの半分の負の値
    xmax = Window.width + w / 2 # 窓サイズの半分から、画像サイズの半分を引く
    ymax = Window.height + h / 2 # 窓サイズの半分から、画像サイズの半分を引く
    if self.x < xmin or self.x > xmax or self.y < ymin or self.y > ymax
    	# 画面内判定。現在の縦横ぞれぞれが、画像サイズ半より小さい、または画面端より大きい。という判定
      self.vanish # 画面外と判定されたオブジェクトは消滅
    end # 画面内判定end
 
    self.x = self.bx - w / 2 # 補正済の現在の横軸位置に、画像半サイズを削って座標に最終設定
    self.y = self.by - h / 2 # 補正済の現在の縦軸位置に、画像半サイズを削って座標に最終設定
  end
 
  # 敵に当たった場合に呼ばれるメソッド
  def shot(d) # 第一パラメのshot→第二パラメのhitの順で処理されるもの。
    self.vanish # 自分を消滅させる。弾は衝突と同時に消滅するだけ。
  end # 衝突end
end # クラスend
 