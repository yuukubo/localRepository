# スプライトの衝突判定動作テスト
 
require 'dxruby' # ライブラリ読み込み
 
# ----------------------------------------

# 雑魚敵

class Enemy < Sprite # スプライトクラス継承
  attr_accessor :bx, :by, :dir, :dx, :dy, :shottimer # クラス内公開変数。座標、？、角度？
  attr_accessor :hit_timer, :spd, :org_image, :flush_image # 何故分けたし
 
  def initialize(spd) # 初期化処理。引数は速度かな？
    self.org_image = Image.load("enemy.png") # イメージ読み込み。
    self.image = self.org_image # オリジナルと、普通に使うのとで変数分けてますね。。。なんだろう？
    self.flush_image = Image.load("enemy_flush.png") # 被弾時のイメージ読み込み
 
    # DXRuby開発版でのみ利用可能。フラッシュ画像を作れる
    # self.flush_image = self.org_image.flush(C_WHITE)
    # これは便利ですねえ。。まあ画像くらい用意しろって話かもだけど。
    self.spd = spd # 引数の速度を受け取り。
    self.collision = [0, 0, 31, 31] # 敵の当たり判定。矩形。ってか超でかいね。
    self.init # initメソッド実行。中身は下記の通り。
  end # イニシャライズend
 
  # 発生時の初期化処理
  def init # 初期化を別途記載していますね。。。何故分けたし
    self.bx = rand(Window.width) # 画面のどこかをランダム取得して座標に設定
    self.by = rand(Window.height / 2) #画面のどこかをランダム取得して座標に設定→上半分に変更
    self.collision_enable = false # 衝突判定は、初期はオフ。フェードインですね。
    self.collision_sync = false # 衝突判定の角度同期等も初期はオフ。
    self.shottimer = 0 # 自動発射敵弾の間隔変数。初期値は０
    self.hit_timer = 0 # 被弾カウントは初期０
    self.alpha = 0 # フェードイン用。アルファ値は初期０
    # 敵弾関係
    @baseAngle = 90 # 開発中の為固定だが、ここを自機狙いにすれば良い
    @wayNum = 5 # way数
    @changeAngle = 30 # 間隔角度
    # n way用意。端の角度を計算
    @firstAngle = @baseAngle + (@wayNum - 1) / 2 * @changeAngle
    @angleArr = [] # 角度配列用意
    # 角度配列＝５way分、端の角度に間隔角度を累積させていく。
    @wayNum.times {|i| @angleArr.push(@firstAngle - @changeAngle * i)}
  end # 別記載の初期化処理end
 
  # 更新処理
  def update # 1/60秒毎の更新処理
    w, h = self.image.width, self.image.height # イメージサイズ取得
 
    if self.alpha < 255 # 完全に出現してるか判定。透明だったらこちらへ
      # 出現中
      self.collision_enable = false # まだ当たらないよと、念の為フラグ再設定
      self.alpha += 5 # 透明度下げる
      if self.alpha >= 255 # 不透明になったら
        self.alpha = 255 # アルファ値を固定する
 
        # プレイヤーを狙った速度を決める
        ply = $players[0] # グローバル変数の自機オブジェクトをコピー取得
        self.dir = Math.atan2(ply.by - self.by, ply.bx - self.bx) # http://aidiary.hatenablog.com/entry/20081025/1275748064
        self.dx = spd * Math.cos(self.dir) # ここに非常に分かりやすくここの三行についての解説がありました。
        self.dy = spd * Math.sin(self.dir) # 要するに角度求めて斜め移動の速度計算してるということです。
      end # 出現中から出現を完了させ移動始めのオリエンテーション処理end
    else # 完全出現済だったらこちらへ
      # 移動中
 
      if self.hit_timer > 0 # 被弾してたらこちらへ
        # 弾が当たっているなら一定時間フラッシュさせる
        self.hit_timer -= 1 # 被弾カウンタをカウントダウン
        self.collision_enable = false # 被弾してたらそれ以上被弾しないように判定オフ。
 
        # フラッシュ時間が終わったら再発生
        self.init if self.hit_timer <= 0 # カウント完了したら初期化へ。
        # ああ！初期化は初期化でも、ループの途中から入れたい初期化もあるということね。
        # それで分けたんだ。なるほど。
      else # 被弾していないならこちらへ
        # 弾は当たってない
        self.hit_timer = 0 # 念の為被弾してないよ設定
        self.collision_enable = true # 被弾してないので判定オンだよ設定
 
        # 移動
        self.bx += self.dx # 斜め補正済の値を移動するよ
        self.by += self.dy # 斜め補正済の値を移動するよ
 
        # 画面外に出たら再発生
        xmin = - w / 2 # 画像の半分の負の値。また画面内判定に使うよ
        ymin = - h / 2 # 画像の半分の負の値。また画面内判定に使うよ
        xmax = Window.width + w / 2 # 画面端から画像半だけ引くよ。
        ymax = Window.height + h / 2 # 画面端から画像半だけ引くよ。
        if self.x < xmin or self.x > xmax or self.y < ymin or self.y > ymax
         # 表示座標が画像の半分より画面出てないか、上下左右で判定
          self.init # 画面から出てたら初期化の途中から実行。
           # 、、、、おお、そういえばvahishをしてないな、、と思ってたんだけど
           # 不透明にして場所移動して再度現れて、ということで、オブジェクトは再利用っぽい！？
        end # 画面内判定end
      end # 被弾有無判定end
    end # 出現状況判定end
 
     # 敵ショットを実装
    if self.shottimer % 100 <= 80 # 100週のうち、20週は休んで欲しいという意味
      if self.shottimer % 10 == 0 # 10の倍数毎に発射ということらしい。詰まり、3wayを秒間6発？
        # 敵ショットを発射      
        @angleArr.each do |i| # 角度固定の3way弾→6wayに増量
          spr = EShot.new(self.bx, self.by, 4, i) # v004：速度変更。これも変数にした方がメンテ性上がるね。
           # スプライトクラス継承のshotインスタンス作成。(x, y, spd, angle)だそうです。
           # やっぱり発射角度は自分の横軸で動く設定みたいだね。
          $eshots.push(spr) # グローバル変数というか自機弾の配列について、作成したインスタンスを最後尾に追加。
        end # 3way弾、自発装填、完了
      end # 調整テストend
    end # 自動発射完了
 
    self.shottimer += 1 # 一周毎に発射間隔変数をカウントアップ
    
    self.image = (self.hit_timer <= 0)? self.org_image : self.flush_image
     # おお、省略形での判定処理。被弾してたら被弾イメージ。
     # してなかったら通常イメージを変数に格納。次の処理でそれが描画される訳ですね。
 
    self.x = self.bx - w / 2 # 表示位置のオフセット対応
    self.y = self.by - h / 2 # 表示位置のオフセット対応
  end # 更新処理end。この段階では、各オブジェクトの値の変化のみで、目では見えない。描画されて始めてこの更新が知覚出来る。
 
  # プレイヤーの弾と当たった時に呼ばれるメソッド
  def hit(o) # 被弾処理。ここも、実処理は書かず、タイマーのセットのみ。
    self.hit_timer = 4 # 被弾状態の時間設定。4フレームの硬直となる。
    $enemylife -= 1 # 敵ライフカウンタをカウントダウン
    $state = "enemydown" if $enemylife == 0
  end # 
 
  # プレイヤーと当たった時に呼ばれるメソッド
  def shot(d) # 敵からすれば敵機撃墜のメソッド。
  end # まさかの定義なしである。そう。まだ敵弾を実装してないのですね。
  # こういうからのメソッドもありなのだなということが勉強になる点ですね。
end # 敵クラスend

 