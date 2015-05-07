# �X�v���C�g�̏Փ˔��蓮��e�X�g
 
require 'dxruby' # ���C�u�����ǂݍ���
 
# ----------------------------------------

# �v���C���[�L����

class Player < Sprite # �X�v���C�g�N���X�p��
  attr_accessor :bx, :by, :shottimer, :hit_timer, :flush_image, :highspd, :lowspd, :spd
   # �N���X�����J�ϐ��B���W�A���ˊԊu�ϐ��A�����ꂽ���̒�~���ԕϐ��A�����ꂽ�C���[�W
 
  # ����������
  def initialize(x, y) # ���������̏����B�����͂��̃^�C�~���O�̓񎟌����W
    super # �X�v���C�g�N���X�̃C�j�V�����C�Y�����̌�ɁA�ȉ���ǋL
    self.bx = x # ���ݍ��W��ϐ��Ɋi�[
    self.by = y # ���ݍ��W��ϐ��Ɋi�[
    self.image = Image.load("jiki.png") # �C���[�W�ǂݍ���
    self.flush_image = Image.load("jiki_flush.png") # �����ꂽ�C���[�W�ǂݍ���
    self.shottimer = 0 # �������ˎ��@�e�̊Ԋu�ϐ��B�����l�͂O
    self.collision = [16, 16, 4] # �A�^���͈͂�ݒ�B�O�����Ȃ̂�
     # �v�f3�̔z���[x, y, r]�E�E�E���S(x, y)���甼�ar�̃T�C�Y�̉~�B8�h�b�g���A�A�A�ł�����
    self.hit_timer = 0 #  ��~���ԕϐ��B�����l�͂O
    self.highspd = 6 # ���@�̊�{���x
    self.lowspd = 1.5.to_f # ���@�̃V�t�g�����x
    self.spd = 6 # ���@�̌��݂̑��x
 
    # self.offset_sync = true # DXRuby�J���łł̂ݎg����v���p�e�B
  end # ������end
 
  def update # 1/60�b���̏���
    w, h = self.image.width, self.image.height # �摜�̑傫���擾�B���d���
    # shift����
    if Input.keyPush?(K_LSHIFT) # shift�����Ă���
      self.spd = self.lowspd # speed down
    else # shift�����ĂȂ�������
      self.spd = self.highspd # speed up
    end # shift����end
    
    # �}�E�X�J�[�\�����W�����@���W�ɂ���
    # ���L�[�{�[�h����ɕύX
    # self.bx = Input.mousePosX # ���@���W�̓}�E�X�J�[�\���Ƃ���
    # self.by = Input.mousePosY # ���@���W�̓}�E�X�J�[�\���Ƃ���
    self.bx += Input.x.to_f * self.spd.to_f # ���@���W�̓L�[����Ƃ���B5/7�ő��x������ϐ����B
    self.by += Input.y.to_f * self.spd.to_f # ���@���W�̓L�[����Ƃ���B5/7�ő��x������ϐ����B
 
    xmin, ymin = 0, 0 # ��ʍ���
    xmax, ymax = Window.width, Window.height # ��ʉE��
    self.bx = xmin if self.bx < xmin # ���ݍ��W�����[�˂��؂��Ă���߂�
    self.by = ymin if self.by < ymin # ��������˂��؂蔻��
    self.bx = xmax if self.bx > xmax # �E����
    self.by = ymax if self.by > ymax # ������
 
    # if self.shottimer % 10 == 0 # 10�̔{�����ɔ��˂Ƃ������Ƃ炵���B�l�܂�A3way��b��6���H
      # ���@�V���b�g�𔭎�
    #  [270, 30, 150].each do |i| # �p�x�Œ��3way�e
    #    spr = Shot.new(self.bx, self.by, 16, i + self.bx / 4)
         # �X�v���C�g�N���X�p����shot�C���X�^���X�쐬�B(x, y, spd, angle)�������ł��B
         # ����ς蔭�ˊp�x�͎����̉����œ����ݒ�݂������ˁB
    #    $shots.push(spr) # �O���[�o���ϐ��Ƃ��������@�e�̔z��ɂ��āA�쐬�����C���X�^���X���Ō���ɒǉ��B
    #  end # 3way�e�A�������U�A����
    #end # �������ˊ���
 
    # Z�L�[����
    if Input.key_push?(K_Z) # Z�Ŕ���
      spr = Shot.new(self.bx, self.by, 16, 270) # ���@�eobj�ɁA���݂̎������W�A�e���x�A�p�x�����Đ����B
      $shots.push(spr) # ���@�e�z��ɐ��������eobj��z��̍Ō�ɒǉ�
    end # �������U�A����

    self.shottimer += 1 # ������ɔ��ˊԊu�ϐ����J�E���g�A�b�v
    # self.angle += 8 #  # ������Ɏ��@�̊p�x���J�E���g�A�b�v�B���Ƒ��߁B1/60�b��8�Ƃ������ƂŁA�A
    # GW_v005�F��]�p�~
 
    if self.hit_timer > 0 # �����ꂽ����B�ϐ������Ȃ炱�����
      self.hit_timer -= 1 # �J�E���g�_�E��
      self.hit_timer = 0 if self.hit_timer <= 0 # �J�E���^���O�܂ŗ�����A�O��ݒ�
    else # �J�E���g�_�E���ς�ł���
      self.hit_timer = 0 # �O������������A�O��ݒ�B�ꉞ���ɂ͂Ȃ�Ȃ��͂������ǂ�
    end # �����ꂽ����end
 
    # ����W�{�I�t�Z�b�g�l��\�����W�Ƃ���B
    # DXRuby�J���łȂ�Aself.offset_sync = true �ōς�ł��܂��̂����ǁA
    # �J���ł� Ruby 1.8 �� 1.9 �ɑΉ����ĂȂ��̂Łc
    self.x = self.bx - w / 2 # �ǂ����I�t�Z�b�g�l�Ή��炵���B
    self.y = self.by - h / 2 # �\���ʒu�A���ׂ̍₩�ȋC�z��Ƃ������Ƃł���
  end # ����X�V����end
 
  # �G���G�Ɠ����������ɌĂ΂�鏈���B�܂��͔�e���̏����B
  def hit(o) # �������́A�U�����ꂽ���̎��̏����B
    self.hit_timer = 4 # �����ł͓��Ɏ������͂����A�����^�C�}�[��ݒ肷�邾���B
    $hitcount += 1 # ��e�J�E���^���J�E���g�A�b�v
    $lifecount -= 1 # ���C�t�J�E���^���J�E���g�_�E��
    if $lifecount == 0 # ���@���C�t���Ȃ��Ȃ�����
      $state = "gameover" # �Q�[���I�[�o�[�V�[���ցB
      $debugflg = false # spd�\�������܂�vanish, clean�����Ⴄ�ƁA�\�����������̂�nil�ɂȂ�Q�[�����������
      self.vanish # ���@�̏������ׁ̈Bclean�Ώۉ��B
    end # ���@���C�t�m�Fend
  end # ��e����end�B�����ł̃^�C�}�[�ݒ�ŁA���̏T�Ŕ�e�J�E���^�����Ȃ̂ŃJ�E���g�_�E���։��B
 
  def draw # �`�揈��
    super # �p�����X�v���C�g�N���X�̃��\�b�h�ɒǋL���܂��B�Ȃ̂ŁA�ʏ�̎��@�͂����ŕ`��ρB
    if self.hit_timer > 0 # ��e�J�E���^������Ă����ꍇ�͂������
#      Window.drawScale(self.x, self.y, self.flush_image, 3, 3)�����G�t�F�N�g���g��\�����Ă��݂����B
      Window.draw(self.x, self.y, self.flush_image) # ���x�グ�������̉摜�����̂܂ܕ\���B�킹������Ă邯�Ǖ��i�̂����̉��ɂ���͂��B
    end # ��e���̏����ρB�Ȃ̂ŁA�Ⴆ�΂����Ŕ����Ƃ��҂���[������Ƃ����ȁH
     # ���Ă��҂��������悤�Ƃ���ƁA���ʂ̕`��́A�A�܂��ǂ��̂��ȁH
  end # �`��end
end # ���@�N���Xend
 