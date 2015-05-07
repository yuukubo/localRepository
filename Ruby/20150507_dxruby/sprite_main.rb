# �X�v���C�g�̏Փ˔��蓮��e�X�g
 
require 'dxruby' # ���C�u�����ǂݍ���
require './sprite_jiki.rb' # ���@�N���X�ǂݍ���
require './sprite_jikibullet.rb' # ���@�e�N���X�ǂݍ���
require './sprite_enemy.rb' # �G�N���X�ǂݍ���
require './sprite_enemybullet.rb' # �G�e�N���X�ǂݍ���
 
font = Font.new(12) # �X�v���C�g���̕\���p�t�H���g
fontback = Image.new(192, 32, [100,100,100]) # �w�i�p

# �x�����W�A���ϊ�
def deg2rad(deg) # deg���ĉ����Ǝv������degrees�B�ʓx�@ �x���@�B���W�A�� = �x �~ �~���� �� 180 
  return deg * Math::PI / 180.0 # �܂��ɂ��̂܂܎��ɂ��Ă��邾���B�ǂ����Python�ɂ�Math.Radians�Ƃ�����炵�����ARuby�ɂ͂Ȃ��炵���̂ł��B
end # �ϊ����\�b�h���슮��

# z�L�[�̃I�[�g���s�[�g�ݒ�
Input.setKeyRepeat( K_Z, 10, 2 ) # ���@�e���˗p

# shift�L�[�̃I�[�g���s�[�g�ݒ�
Input.setKeyRepeat( K_LSHIFT, 1, 1 ) # ���@���x�����p

# ----------------------------------------

# ���C��

srand(0) # module function Kernel.#srand�B���񓯂������_���f�[�^�̘A���𐶐����邱�Ƃ��o����B
 # ����قȂ鐔�����o��悤�ɂ������Ȃ�����Asrand 0�Ƃ���΂悢
 # �ł�����ǂ��Ŏg���Ă�́H�H
def gameInit
  $players = [] # ���@�̔z��B�z��ȈӖ�������̂��s���B��e��͔z��̒ǉ��폜�Ƃ��Ă�̂��H
  $shots = [] # ���@�e�̔z��B
  $enemys = [] # �G�̔z��B
  $eshots = [] # �G�e�̔z��B�������ŁA�����珟��Ɏ�������\��B
  $hitcount = 0 # ��e�J�E���^�B�����l�͂O
  $lifecount = 4 # ���C�t�J�E���^�B�����l�͂P�O�O
  $enemylife = 10 # �G���C�t�J�E���^�B�����l�͂P�O
  $debugflg = false # debug�t���O�B�������㌩�������̐������������ꍇ�͌���ׂ̏���
  
  $players.push(Player.new(300, 300)) # ���[�v�O�̏��������A�g�b�v���x���̏����Ƃ��āA���@�̐����B
  2.times {|i| $enemys.push(Enemy.new(1))} # �������g�b�v���x���ŁA�G�̐����B�W�̂����݂����B
  # �����͊m���X�s�[�h�H���������A�X�s�[�h�̂悤�ł��B�����x���Ƃ��܂����B
end

gameInit # �Q�[���V�[���؂�ւ����ɕK�v�ȏ��������܂Ƃ߂����̂ɂ��Ď��s

in_pause = false # �|�[�Y��������A�����l�̓|�[�Y�Ȃ��B

$state = "gamestart" # �悸�Q�[���X�^�[�g�V�[���ւ��ē��B
 
 #####################################################################
 
Window.loop do # 1/60�̃��C�����[�v�J�n�B
  case $state
  when "game" # ������
  
  
  break if Input.keyPush?(K_ESCAPE) # esc�I������
 
  update_enable = false # �X�V�I���I�t�B���[�v�n�߂Ƀt���O�𗧂Ă�
  if in_pause # �I�u�W�F�N�g���u�[���l���Ƃ����������������\�Ȃ̂��B�^�̏ꍇ�Ƃ�������
    # �|�[�Y���B�O��̃��[�v�Ń|�[�Y���������ꍇ�͂�����ցB
 
    # N�L�[������1�t���[���i�߂�
    update_enable = true if Input.keyPush?(K_N) # ����������i�߂�悤�t���O��܂�B
 
    # P�L�[����������|�[�Y����
    in_pause = false if Input.keyPush?(K_P) # �X�V�ɐi�߂�悤�t���O��܂�B
  else # �ʏ�̃��[�v�͂�����B�U�̏ꍇ�Ƃ�������
    # �ʏ폈��
    in_pause = true if Input.keyPush?(K_P) # P�L�[����������|�[�Y�B���̃��[�v�ōX�V���~�܂�B
    update_enable = true unless in_pause # unless�ł��ˁBif�̋t�B�������U�ł���΂��̏����ցB
     # ����̓|�[�Y������Ȃ�������X�V��������B
  end # �|�[�Y����end�B����ƍX�V���肪���T���T���ĖZ�����ȁB�������x�͑��v�Ȃ̂��ȁH
 
  if update_enable # �X�V�I���Ȃ炱�����
    # �v���C���[�̒e�ƎG���G�̏Փ˔���
    Sprite.check($shots, $enemys) # ���@�e���G���������ꍇ�͂�����B
 
    # �G���G�ƃv���C���[�̏Փ˔���
    Sprite.check($enemys, $players) # �G�����@�ɏՓ˂����ꍇ�͂�����B
 
    # �G�e�ƃv���C���[�̏Փ˔���
    Sprite.check($eshots, $players) # �G�e�Ɏ��@�������ꂽ�ꍇ�͂�����B
 
    Sprite.update($players) # ���@���X�V
    Sprite.update($shots) # ���@�e���X�V
    Sprite.update($enemys) # �G���X�V
    Sprite.update($eshots) # �G�e���X�V
 
    Sprite.clean($shots) # ���@�e��|��
    Sprite.clean($enemys) # �G��|��
    Sprite.clean($eshots) # �G�e��|��
    Sprite.clean($players) # ���@��|��
  end # �X�V����end
 
  Sprite.draw($enemys) #�G�`�� 
  Sprite.draw($players) # ���@�`��B���̏��ԂɍS��͂���̂��낤���H
  Sprite.draw($shots) # ���@�e�`��
  Sprite.draw($eshots) # �G�e�`��
 
  # ����ɃX�v���C�g����\������ׂ̏����B���낻��\���֌W���N���X�ɂ܂Ƃ߂����B
  l = $players.length + $shots.length + $enemys.length + $eshots.length # ���݂̔z��v�f�����擾
  Window.drawFont(0, 0, "Sprs: " + ('[]' * l), font) # ��ʍ���[�ɃX�v���C�c�{[]��z��v�f�������\��
  Window.drawFont(0, 16, "PAUSE", font) if in_pause == 0 # �|�[�Y�����������ʍ��[�ォ�炿����Ƃ�����pause�ƕ\��
  # ���ꂤ�܂������Ă��Ȃ��H
  Window.drawFont(0, 32, "hit: " + $hitcount.to_s, font) # ��e�J�E���^
  Window.drawFont(0, 48, "life: " + $lifecount.to_s, font) # ���C�t�J�E���^
  Window.drawFont(0, 64, "enemy: " + $enemylife.to_s, font) # �G���C�t�J�E���^
  Window.drawFont(0, 80, "Sprs: " + l.to_s, font) # ��ʍ���[�ɔz��v�f���\��
  
  # debug # �������B�����w�ق����Ȃ�C������@�\�B

  # d����
  if $debugflg # 
    # �O��̃��[�v��d���������ꍇ�͂�����ցB
    Window.drawFont(0, 96, "jikispd: " + $players[0].spd.to_s, font) # 

    # d�L�[����������debug����
    $debugflg = false if Input.keyPush?(K_D) # �t���O��܂�B
  else # ���̃��[�v�ł�debug���[�h����Ȃ������炱����
    $debugflg = true if Input.keyPush?(K_D) # ���̃��[�v�̒���d����������t���O��܂�A���̃��[�v����ϐ��\��
  end # debug����end
  
 #####################################################################
  
  when "gameover" # �X�y�[�X���͑҂��B�ꉞ�Q�[���I�[�o�[��ʁB
    Window.draw(0, 72, fontback, 9) # 
    Window.drawFont(64, 80, "Game Over. Push Space", font, :color=>[255,255,255,255],:z=>10) # 
    $state = "gamestart" if Input.keyPush?(K_SPACE) # 
    gameInit # 

 #####################################################################
  
  when "enemydown" # �X�y�[�X���͑҂��B�ꉞ�G���f�B���O��ʁB
    Window.draw(40, 112, fontback, 9) # �����̔w�i�̎l�p
    Window.draw(40, 132, fontback, 9) # �����̔w�i�̎l�p
    Window.drawFont(64, 120, "Enemy down ! Congratulations !", font, :color=>[255,255,255,255],:z=>10) # 
    Window.drawFont(64, 140, "Push Space", font, :color=>[255,255,255,255],:z=>10) # 
    $state = "gamestart" if Input.keyPush?(K_SPACE) # 
    gameInit # 

 #####################################################################

  when "gamestart" # �X�y�[�X���͑҂��B�X�^�[�g��ʁB
    Window.draw(0, 92, fontback, 9) # �����̔w�i�̎l�p
    Window.drawFont(64, 100, "Let' Start. Push Space", font, :color=>[255,255,255,255],:z=>10) # �X�^�[�g�������b�Z�[�W
    $state = "game" if Input.keyPush?(K_SPACE) # �X�y�[�X�ŃQ�[���J�n

  end # �V�[���Ǘ�end�B������N���X���B
  
 #####################################################################
  
end # ���C�����[�vend
 