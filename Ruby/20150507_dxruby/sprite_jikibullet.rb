# �X�v���C�g�̏Փ˔��蓮��e�X�g
 
require 'dxruby' # ���C�u�����ǂݍ��݁B
  # %$LOAD_PATH���ʂ��Ă���׏�L�̋L�ڂœǂݍ��݂������o����B

# ----------------------------------------

# �v���C���[�̒e

class Shot < Sprite # �X�v���C�g�N���X�p��
  attr_accessor :bx, :by, :dx, :dy # �N���X�����J�ϐ��B�c���΂߂̏�񂩂�
 
  def initialize(x, y, spd, angle) # ���������̏���
    self.bx = x # �����̈ʒu��ϐ��ɃZ�b�g
    self.by = y # �c���̈ʒu��ϐ��ɃZ�b�g
    self.image = Image.load("jiki_bullet.png") # �C���[�W�ǂݍ���
    self.dx = spd * Math.cos(deg2rad(angle)) # ������]�B����Ȃ��B�΂߈ړ���
    self.dy = spd * Math.sin(deg2rad(angle)) # �c����]�B����Ȃ��B�΂߈ړ���
    self.angle = angle # �p�x
    self.collision = [0, 13, 31, 18] # �����蔻��i��`�j
    self.collision_enable = true # �����蔻��I���I�t�B�����l�I���B
    self.collision_sync = true # �����蔻��̉�]�I���I�t�B�����l�I���B
  end # ������end
 
  def update # �ꃋ�[�v���Ƃ̏���
    w, h = self.image.width, self.image.height # �摜�̑傫���擾
    self.bx += self.dx # �摜�ʒu�ɉ�]�␳�ǉ�
    self.by += self.dy # �摜�ʒu�ɉ�]�␳�ǉ�
 
    # ��ʊO�ɏo���玩�������ł�����
    xmin = - w / 2 # �摜�T�C�Y�̔����̕��̒l
    ymin = - h / 2 # �摜�T�C�Y�̔����̕��̒l
    xmax = Window.width + w / 2 # ���T�C�Y�̔�������A�摜�T�C�Y�̔���������
    ymax = Window.height + h / 2 # ���T�C�Y�̔�������A�摜�T�C�Y�̔���������
    if self.x < xmin or self.x > xmax or self.y < ymin or self.y > ymax
    	# ��ʓ�����B���݂̏c�����ꂼ�ꂪ�A�摜�T�C�Y����菬�����A�܂��͉�ʒ[���傫���B�Ƃ�������
      self.vanish # ��ʊO�Ɣ��肳�ꂽ�I�u�W�F�N�g�͏���
    end # ��ʓ�����end
 
    self.x = self.bx - w / 2 # �␳�ς̌��݂̉����ʒu�ɁA�摜���T�C�Y������č��W�ɍŏI�ݒ�
    self.y = self.by - h / 2 # �␳�ς̌��݂̏c���ʒu�ɁA�摜���T�C�Y������č��W�ɍŏI�ݒ�
  end
 
  # �G�ɓ��������ꍇ�ɌĂ΂�郁�\�b�h
  def shot(d) # ���p������shot�����p������hit�̏��ŏ����������́B
    self.vanish # ���������ł�����B�e�͏Փ˂Ɠ����ɏ��ł��邾���B
  end # �Փ�end
end # �N���Xend
 