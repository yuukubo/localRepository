require 'dxruby'
require 'win32ole'

=begin
これからやりたいこと
・モジュール分割
・敵の出現数ランダマイズ
・敵が弾を撃つ
・自機が複数弾を撃つ
・敵が自機狙いを撃つ
・敵がN way弾を撃つ
・ショット軌道の多彩化
・

14_ver18
・取り合えず一部だけクラス利用テスト
・vimで自動整形テスト

=end

######## 定義等 ########

x = 320    # さるのx座標
y = 400    # さるのy座標
tamax = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1] # たまのx座標配列
tamay = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1] # たまのy座標配列
tekitamax = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1] # たまのx座標配列
tekitamay = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1] # たまのy座標配列
tekix = [rand(470) + 1, rand(470) + 1, rand(470) + 1]  # てきのx座標配列
tekiy = [rand(200) + 1, rand(200) + 1, rand(200) + 1]  # てきのy座標配列
tekid = [rand(6) + 1, rand(6) + 1, rand(6) + 1]   # てきの移動量配列
flg_wellcome = 1

# 画像読み込み
jiki = Image.load("jiki.png")
bullet = Image.load("bullet.png")
teki = Image.load("teki.png")
tekibullet = Image.load("tekibullet.png")

class Jiki
	#	def initialize(jikix, jikiy, img_jiki)
	#		@jikix = jikix
	#		@jikiy = jikiy
	#		@img_jiki = img_jiki
	#	end

	def Jiki.moveJiki(jikix, jikiy, imgjiki)
		# さる描画
		#		Window.draw(@jikix, @jikiy, @img_jiki)
		Window.draw(jikix, jikiy, imgjiki)
	end
end

#	obj_jiki = Jiki.new
#	Jiki.moveJiki



######## メイン ########

# メインループ
Window.loop do

	# welcome messeage

	if flg_wellcome == 1 then
		def startmsg(msg, title)
			wsh = WIN32OLE.new('WScript.Shell')
			wsh.Popup(msg, 0, title, 4 + 64 + 0x40000)
		end
		y_n = startmsg("are you ready?", "STG test start!")

		def rtn(msg2, title2)
			wsh2 = WIN32OLE.new('WScript.Shell')
			wsh2.Popup(msg2, 0, title2, 0 + 64 + 0x40000)
		end
		case y_n # YES->6, NO->7
		when 6
			rtn("here we go!", "start!")
			flg_wellcome = 0
		when 7
			rtn("you enter No!!", "No!No!No!")
			break
		end # case yes_no
	end

	######## 自機処理 ########

	# さるの移動
	x = x + Input.x * 8
	y = y + Input.y * 8

	# 左にはみ出したチェック
	if x < 0 then
		x = 0
	end

	# 右にはみ出したチェック
	if x > 639 - jiki.width then
		x = 639 - jiki.width
	end

	# 上にはみ出したチェック
	if y < 0 then
		y = 0
	end

	# 下にはみ出したチェック
	if y > 479 - jiki.height then
		y = 479 - jiki.height
	end

	Jiki.moveJiki(x, y, jiki)

	######## 自機弾処理 ########

	# Zキーで弾発射
	if Input.keyPush?(K_Z) == true then
		for i in 0..9 do # iを0から9まで変えながらループ
			if tamay[i] < 0 then
				tamax[i] = x
				tamay[i] = y
				break # 弾を飛ばしたらループを中断する
			end
		end
	end

	# 弾が画面内にある場合、弾の移動と描画
	for i in 0..9 do # iを0から9まで変えながらループ
		if tamay[i] >= 0 then
			tamay[i] = tamay[i] - 8
			Window.draw(tamax[i], tamay[i], bullet)
		end
	end

	######## 敵処理 ########

	# 左にはみ出したチェック
	for i in 0..2 do # iを0から2まで変えながらループ
		if tekix[i] < 0 then
			tekix[i] = rand(470) + 1
		end
	end

	# 右にはみ出したチェック
	for i in 0..2 do # iを0から2まで変えながらループ
		if tekix[i] > 639 - teki.width then
			tekix[i] = rand(470) + 1
		end
	end

	# 上にはみ出したチェック
	for i in 0..2 do # iを0から2まで変えながらループ
		if tekiy[i] < 0 then
			tekiy[i] = rand(200) + 1
		end
	end

	# 下にはみ出したチェック
	for i in 0..2 do # iを0から2まで変えながらループ
		if tekiy[i] > 479 - teki.height then
			tekiy[i] = rand(200) + 1
		end
	end

	# てきの移動とチェック
	for i in 0..2 do # iを0から2まで変えながらループ
		#	  tekix[i] = tekix[i] + tekid[i]
		#		if tekix[i] < 10 or tekix[i] > 639 - teki.width - 10 then
		#			tekid[i] = -tekid[i]
		#			tekiy[i] = tekiy[i] + 10
		#		end

		ra = rand(100)
		case ra
		when 0..10 # homing case
			if x < tekix[i]
				tekix[i] = tekix[i] + tekid[i] * -1
			else
				tekix[i] = tekix[i] + tekid[i]
			end
			if y < tekiy[i]
				tekiy[i] = tekiy[i] + tekid[i] * -1
			else
				tekiy[i] = tekiy[i] + tekid[i]
			end
		when 12..99 # down case
			tekiy[i] = tekiy[i] + 1
		else # warp case :ver14 debuged ver18 update
			tekix[i], tekiy[i] = tekiy[i], tekix[i]
			# work = tekix[i]
			# tekix[i] = tekiy[i]
			# tekiy[i] = work
		end


		# てき描画
		Window.draw(tekix[i], tekiy[i], teki)
	end

	######## 敵弾処理 ########

	for i in 0..2 do # iを0から2まで変えながらループ
		if tekitamay[i] < 0 then
			tekitamax[i] = tekix[i]
			tekitamay[i] = tekiy[i]
			break # 弾を飛ばしたらループを中断する
		end
	end

	# 弾が画面内にある場合、弾の移動と描画
	for i in 0..2 do # iを0から9まで変えながらループ
		if tekitamay[i] >= 0 then
			tekitamay[i] = tekitamay[i] + 4
			Window.draw(tekitamax[i], tekitamay[i], tekibullet)
		end
	end

	######## 当たり判定処理 ########

	# 自機弾と敵の当たり判定と処理
	for i in 0..9 do # iを0から9まで変えながらループ
		for k in 0..2 do # kを0から2まで変えながらループ
			if tamay[i] >= 0 and
				tamax[i] - (tekix[k] + teki.width - 10) < 0 and tamay[i] - (tekiy[k] + teki.height - 10) < 0 and
				tekix[k] - (tamax[i] + bullet.width - 5) < 0 and tekiy[k] - (tamay[i] + bullet.height - 5) < 0 then
				tekix[k] = rand(470) + 1  # てきのx座標
				tekiy[k] = rand(200) + 1  # てきのy座標
				tekid[k] = rand(5) + 1   # てきの移動量
				tamax[i] = -1
				tamay[i] = -1
			end
		end
	end

	# 敵弾と自機の当たり判定と処理
#	for i in 0..9 do # iを0から9まで変えながらループ
#		if tekitamay[i] <= 480 and
#			tekitamax[i] - (x + jiki.width - 10) < 0 and tekitamay[i] - (y + jiki.height - 10) < 0 and
#			x - (tekitamax[i] + tekibullet.width - 5) < 0 and y - (tekitamay[i] + tekibullet.height - 5) < 0 then
#			x = 320    # さるのx座標
#			y = 400    # さるのy座標
#			tekitamax[i] = -1
#			tekitamay[i] = -1
#			end
#		end
#	end

	# 自機と敵の当たり判定と処理
	for i in 0..2 do # iを0から2まで変えながらループ
		if tekiy[i] <= 480 and
			tekix[i] - (x + jiki.width - 15) < 0 and tekiy[i] - (y + jiki.height - 25) < 0 and
			x - (tekix[i] + teki.width - 15) < 0 and y - (tekiy[i] + teki.height - 25) < 0 then
			x = 320    # さるのx座標
			y = 400    # さるのy座標
		end
	end

	# エスケープキーで終了判定
	if Input.keyDown?(K_ESCAPE) == true then
		def show(msg, title)
			wsh = WIN32OLE.new('WScript.Shell')
			wsh.Popup(msg, 0, title, 4 + 64 + 0x40000)
		end
		yes_no = show("want you quit?", "escape event")

		def ret(msg2, title2)
			wsh2 = WIN32OLE.new('WScript.Shell')
			wsh2.Popup(msg2, 0, title2, 0 + 64 + 0x40000)
		end
		case yes_no # YES->6, NO->7
		when 6
			ret("see you!", "game over")
			break
		when 7
			ret("you enter No!!", "No!No!No!")
		end # case yes_no
	end

	######## メイン終了 ########

end
