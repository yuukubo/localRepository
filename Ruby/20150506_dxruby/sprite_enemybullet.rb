# �X�v���C�g�̏Փ˔��蓮��e�X�g
 
require 'dxruby'
 
# ----------------------------------------

# �G�̒e

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
 
    # ��ʊO�ɏo���玩�������ł�����
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
 
  # ���@�ɓ��������ꍇ�ɌĂ΂�郁�\�b�h
  def shot(d)
    self.vanish # ���������ł�����
  end
end
 