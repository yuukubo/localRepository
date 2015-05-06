# �X�v���C�g�̏Փ˔��蓮��e�X�g
 
require 'dxruby' # ���C�u�����ǂݍ���
 
# ----------------------------------------

# �G���G

class Enemy < Sprite # �X�v���C�g�N���X�p��
  attr_accessor :bx, :by, :dir, :dx, :dy, :shottimer # �N���X�����J�ϐ��B���W�A�H�A�p�x�H
  attr_accessor :hit_timer, :spd, :org_image, :flush_image # ���̕�������
 
  def initialize(spd) # �����������B�����͑��x���ȁH
    self.org_image = Image.load("enemy.png") # �C���[�W�ǂݍ��݁B
    self.image = self.org_image # �I���W�i���ƁA���ʂɎg���̂Ƃŕϐ������Ă܂��ˁB�B�B�Ȃ񂾂낤�H
    self.flush_image = Image.load("enemy_flush.png") # ��e���̃C���[�W�ǂݍ���
 
    # DXRuby�J���łł̂ݗ��p�\�B�t���b�V���摜������
    # self.flush_image = self.org_image.flush(C_WHITE)
    # ����͕֗��ł��˂��B�B�܂��摜���炢�p�ӂ�����Ęb���������ǁB
    self.spd = spd # �����̑��x���󂯎��B
    self.collision = [0, 0, 31, 31] # �G�̓����蔻��B��`�B���Ă����ł����ˁB
    self.init # init���\�b�h���s�B���g�͉��L�̒ʂ�B
  end # �C�j�V�����C�Yend
 
  # �������̏���������
  def init # ��������ʓr�L�ڂ��Ă��܂��ˁB�B�B���̕�������
    self.bx = rand(Window.width) # ��ʂ̂ǂ����������_���擾���č��W�ɐݒ�
    self.by = rand(Window.height / 2) #��ʂ̂ǂ����������_���擾���č��W�ɐݒ聨�㔼���ɕύX
    self.collision_enable = false # �Փ˔���́A�����̓I�t�B�t�F�[�h�C���ł��ˁB
    self.collision_sync = false # �Փ˔���̊p�x�������������̓I�t�B
    self.shottimer = 0 # �������˓G�e�̊Ԋu�ϐ��B�����l�͂O
    self.hit_timer = 0 # ��e�J�E���g�͏����O
    self.alpha = 0 # �t�F�[�h�C���p�B�A���t�@�l�͏����O
    # �G�e�֌W
    @baseAngle = 90 # �J�����̈׌Œ肾���A���������@�_���ɂ���Ηǂ�
    @wayNum = 5 # way��
    @changeAngle = 30 # �Ԋu�p�x
    # n way�p�ӁB�[�̊p�x���v�Z
    @firstAngle = @baseAngle + (@wayNum - 1) / 2 * @changeAngle
    @angleArr = [] # �p�x�z��p��
    # �p�x�z�񁁂Tway���A�[�̊p�x�ɊԊu�p�x��ݐς����Ă����B
    @wayNum.times {|i| @angleArr.push(@firstAngle - @changeAngle * i)}
  end # �ʋL�ڂ̏���������end
 
  # �X�V����
  def update # 1/60�b���̍X�V����
    w, h = self.image.width, self.image.height # �C���[�W�T�C�Y�擾
 
    if self.alpha < 255 # ���S�ɏo�����Ă邩����B�����������炱�����
      # �o����
      self.collision_enable = false # �܂�������Ȃ���ƁA�O�̈׃t���O�Đݒ�
      self.alpha += 5 # �����x������
      if self.alpha >= 255 # �s�����ɂȂ�����
        self.alpha = 255 # �A���t�@�l���Œ肷��
 
        # �v���C���[��_�������x�����߂�
        ply = $players[0] # �O���[�o���ϐ��̎��@�I�u�W�F�N�g���R�s�[�擾
        self.dir = Math.atan2(ply.by - self.by, ply.bx - self.bx) # http://aidiary.hatenablog.com/entry/20081025/1275748064
        self.dx = spd * Math.cos(self.dir) # �����ɔ��ɕ�����₷�������̎O�s�ɂ��Ẳ��������܂����B
        self.dy = spd * Math.sin(self.dir) # �v����Ɋp�x���߂Ď΂߈ړ��̑��x�v�Z���Ă�Ƃ������Ƃł��B
      end # �o��������o�������������ړ��n�߂̃I���G���e�[�V��������end
    else # ���S�o���ς������炱�����
      # �ړ���
 
      if self.hit_timer > 0 # ��e���Ă��炱�����
        # �e���������Ă���Ȃ��莞�ԃt���b�V��������
        self.hit_timer -= 1 # ��e�J�E���^���J�E���g�_�E��
        self.collision_enable = false # ��e���Ă��炻��ȏ��e���Ȃ��悤�ɔ���I�t�B
 
        # �t���b�V�����Ԃ��I�������Ĕ���
        self.init if self.hit_timer <= 0 # �J�E���g���������珉�����ցB
        # �����I�������͏������ł��A���[�v�̓r��������ꂽ��������������Ƃ������ƂˁB
        # ����ŕ������񂾁B�Ȃ�قǁB
      else # ��e���Ă��Ȃ��Ȃ炱�����
        # �e�͓������ĂȂ�
        self.hit_timer = 0 # �O�̈ה�e���ĂȂ���ݒ�
        self.collision_enable = true # ��e���ĂȂ��̂Ŕ���I������ݒ�
 
        # �ړ�
        self.bx += self.dx # �΂ߕ␳�ς̒l���ړ������
        self.by += self.dy # �΂ߕ␳�ς̒l���ړ������
 
        # ��ʊO�ɏo����Ĕ���
        xmin = - w / 2 # �摜�̔����̕��̒l�B�܂���ʓ�����Ɏg����
        ymin = - h / 2 # �摜�̔����̕��̒l�B�܂���ʓ�����Ɏg����
        xmax = Window.width + w / 2 # ��ʒ[����摜������������B
        ymax = Window.height + h / 2 # ��ʒ[����摜������������B
        if self.x < xmin or self.x > xmax or self.y < ymin or self.y > ymax
         # �\�����W���摜�̔�������ʏo�ĂȂ����A�㉺���E�Ŕ���
          self.init # ��ʂ���o�Ă��珉�����̓r��������s�B
           # �A�A�A�A�����A����������vahish�����ĂȂ��ȁA�A�Ǝv���Ă��񂾂���
           # �s�����ɂ��ďꏊ�ړ����čēx����āA�Ƃ������ƂŁA�I�u�W�F�N�g�͍ė��p���ۂ��I�H
        end # ��ʓ�����end
      end # ��e�L������end
    end # �o���󋵔���end
 
     # �G�V���b�g������
    if self.shottimer % 100 <= 80 # 100�T�̂����A20�T�͋x��ŗ~�����Ƃ����Ӗ�
      if self.shottimer % 10 == 0 # 10�̔{�����ɔ��˂Ƃ������Ƃ炵���B�l�܂�A3way��b��6���H
        # �G�V���b�g�𔭎�      
        @angleArr.each do |i| # �p�x�Œ��3way�e��6way�ɑ���
          spr = EShot.new(self.bx, self.by, 4, i) # v004�F���x�ύX�B������ϐ��ɂ������������e���オ��ˁB
           # �X�v���C�g�N���X�p����shot�C���X�^���X�쐬�B(x, y, spd, angle)�������ł��B
           # ����ς蔭�ˊp�x�͎����̉����œ����ݒ�݂������ˁB
          $eshots.push(spr) # �O���[�o���ϐ��Ƃ��������@�e�̔z��ɂ��āA�쐬�����C���X�^���X���Ō���ɒǉ��B
        end # 3way�e�A�������U�A����
      end # �����e�X�gend
    end # �������ˊ���
 
    self.shottimer += 1 # ������ɔ��ˊԊu�ϐ����J�E���g�A�b�v
    
    self.image = (self.hit_timer <= 0)? self.org_image : self.flush_image
     # �����A�ȗ��`�ł̔��菈���B��e���Ă����e�C���[�W�B
     # ���ĂȂ�������ʏ�C���[�W��ϐ��Ɋi�[�B���̏����ł��ꂪ�`�悳����ł��ˁB
 
    self.x = self.bx - w / 2 # �\���ʒu�̃I�t�Z�b�g�Ή�
    self.y = self.by - h / 2 # �\���ʒu�̃I�t�Z�b�g�Ή�
  end # �X�V����end�B���̒i�K�ł́A�e�I�u�W�F�N�g�̒l�̕ω��݂̂ŁA�ڂł͌����Ȃ��B�`�悳��Ďn�߂Ă��̍X�V���m�o�o����B
 
  # �v���C���[�̒e�Ɠ����������ɌĂ΂�郁�\�b�h
  def hit(o) # ��e�����B�������A�������͏������A�^�C�}�[�̃Z�b�g�̂݁B
    self.hit_timer = 4 # ��e��Ԃ̎��Ԑݒ�B4�t���[���̍d���ƂȂ�B
    $enemylife -= 1 # �G���C�t�J�E���^���J�E���g�_�E��
    $state = "enemydown" if $enemylife == 0
  end # 
 
  # �v���C���[�Ɠ����������ɌĂ΂�郁�\�b�h
  def shot(d) # �G���炷��ΓG�@���Ẵ��\�b�h�B
  end # �܂����̒�`�Ȃ��ł���B�����B�܂��G�e���������ĂȂ��̂ł��ˁB
  # ������������̃��\�b�h������Ȃ̂��ȂƂ������Ƃ��׋��ɂȂ�_�ł��ˁB
end # �G�N���Xend

 