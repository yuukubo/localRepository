# main
=begin

#### コメント場所 ####

モジュール分割テストの為、
一度全て書き直し
先ずはクラスの骨格、想定と、
司会進行の流れの確認

後は、そのうちだけど、
「ステージ」の概念の実装。
時間経過の扱い方と、
耐久という概念の実装とか。

=end

# 読み込み
require 'dxruby'
require 'win32ole'

######## 初期化、定義等 ########

# 画像読み込み
img_jiki = Image.load("jiki.png")
img_bullet = Image.load("bullet.png")
img_enemy = Image.load("enemy.png")

# 残機設定グローバル変数
$zanki = 4

# オブジェクト配列
# $obj = [Jiki,     # 自機
#        Enemy,   # 敵
#        JikiBullet, # 自機弾
#        EnemyBullet,    # 敵弾
# ]

# オブジェクト初期化
# $obj.each do |o|
#   o.initAll
# end

=begin

######################## クラス設定 ########################
# クラスは将来モジュールにする予定。長すぎる。

######## 自機クラス ########
# 自機の要素としては、残機やボム、スコアなど？
# →スコアは別クラスというか、実装はもっと後かな。

# 要素：座標、速度、

class Jiki

	attr_accessor :
	def initialize()
		
	end

end



######## 敵定義クラス ########
# 雑魚の定義クラスの想定

# 要素：座標、速度、挙動、

class Enemy

	attr_accessor :
	def initialize()
		
	end

end

######## 敵配列クラス ########
# インスタンス作成で数は好きに出来る想定

# 要素：数、画像、

class Enemies

	attr_accessor :
	def initialize()
		
	end

end



######## 弾定義クラス ########
# 敵も自機も共通利用の予定

# 要素：座標、速度、

class Bullet

	attr_accessor :
	def initialize()
		
	end

end



######## 弾配列クラス ########
# 敵も自機も共通利用の予定
# →そう考えた後でサンプル見たら分けてた。。

# 要素：数、色


class Bullets

	attr_accessor :
	def initialize()
		
	end

end



######## ポップアップクラス ########
# 始まりと終わりに使う想定。
# かなり先だろうけど、タイムイベントの実装でも使うかも

class Msgbox

	attr_accessor :
	def initialize()
		
	end

end

=end



######## メイン				########
# ウィンドウが閉じられたら自動的に終了する
# メインループ
Window.loop do

######## スタート確認	########

#    msg.check(startcheck)

######## 移動処理			########

#    $obj.each do |o|
#      o.moveAll
#    end

######## 当たり判定		########

# hit.check() # jiki enemy
# hit.check() # jiki enemy bullet
# hit.check() # jiki bullet enemy

######## 描画処理			########

#  $obj.each do |o|
#    o.drawAll
#  end

######## 中断判定			########

#  if Input.keyDown?(K_ESCAPE) == true then
#    msg.check(endcheck)
#  end

######## メイン終了		########

end

