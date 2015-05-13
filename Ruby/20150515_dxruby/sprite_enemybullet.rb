# スプライトの衝突判定動作テスト
 
require 'dxruby'
 
# ----------------------------------------

# 敵の弾。自機のコピペなのでコメント略。
# →すると、ほぼ一緒なら同じクラスでも？と思ったが、
# 今後どんどん変更される想定の為、別クラスで良いはず。

class EShot < Sprite
  attr_accessor :bx, :by, :dx, :dy
 
  def initialize(x, y, spd, angle)
    self.bx = x
    self.by = y
    self.image = Image.load("enemy_bullet.png")
    self.dx = spd * Math.cos(deg2rad(angle))
    self.dy = spd * Math.sin(deg2rad(angle))
    self.angle = angle
    self.collision = [0, 13, 31, 18]
    self.collision_enable = true
    self.collision_sync = true
  end
 
  def update
    w, h = self.image.width, self.image.height
    self.bx += self.dx
    self.by += self.dy
 
    # 画面外に出たら自分を消滅させる
    xmin = - w / 2
    ymin = - h / 2
    xmax = Window.width + w / 2
    ymax = Window.height + h / 2
    if self.x < xmin or self.x > xmax or self.y < ymin or self.y > ymax
      self.vanish
    end
 
    self.x = self.bx - w / 2
    self.y = self.by - h / 2
  end
 
  # 自機に当たった場合に呼ばれるメソッド
  def shot(d)
    self.vanish # 自分を消滅させる
  end
end
 