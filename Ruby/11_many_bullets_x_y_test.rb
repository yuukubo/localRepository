require 'dxruby'

x = 0      # さるのx座標
y = 0      # さるのy座標
tamax = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1] # たまのx座標配列
tamay = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1] # たまのy座標配列

# 画像読み込み
jiki = Image.load("jiki.png")
bullet = Image.load("bullet.png")

# メインループ
Window.loop do
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
  if y > 470 - jiki.width then
    y = 470 - jiki.width
  end

  # さる描画
  Window.draw(x, y, jiki)

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
end
