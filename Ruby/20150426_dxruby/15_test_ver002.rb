# main
=begin

#### �R�����g�ꏊ ####

���W���[�������e�X�g�ׁ̈A
��x�S�ď�������
�悸�̓N���X�̍��i�A�z��ƁA
�i��i�s�̗���̊m�F

��́A���̂��������ǁA
�u�X�e�[�W�v�̊T�O�̎����B
���Ԍo�߂̈������ƁA
�ϋv�Ƃ����T�O�̎����Ƃ��B

=end

# �ǂݍ���
require 'dxruby'
require 'win32ole'

######## �������A��`�� ########

# �摜�ǂݍ���
img_jiki = Image.load("jiki.png")
img_bullet = Image.load("bullet.png")
img_enemy = Image.load("enemy.png")

# �c�@�ݒ�O���[�o���ϐ�
$zanki = 4

# �I�u�W�F�N�g�z��
# $obj = [Jiki,     # ���@
#        Enemy,   # �G
#        JikiBullet, # ���@�e
#        EnemyBullet,    # �G�e
# ]

# �I�u�W�F�N�g������
# $obj.each do |o|
#   o.initAll
# end

=begin

######################## �N���X�ݒ� ########################
# �N���X�͏������W���[���ɂ���\��B��������B

######## ���@�N���X ########
# ���@�̗v�f�Ƃ��ẮA�c�@��{���A�X�R�A�ȂǁH
# ���X�R�A�͕ʃN���X�Ƃ������A�����͂����ƌォ�ȁB

# �v�f�F���W�A���x�A

class Jiki

	attr_accessor :
	def initialize()
		
	end

end



######## �G��`�N���X ########
# �G���̒�`�N���X�̑z��

# �v�f�F���W�A���x�A�����A

class Enemy

	attr_accessor :
	def initialize()
		
	end

end

######## �G�z��N���X ########
# �C���X�^���X�쐬�Ő��͍D���ɏo����z��

# �v�f�F���A�摜�A

class Enemies

	attr_accessor :
	def initialize()
		
	end

end



######## �e��`�N���X ########
# �G�����@�����ʗ��p�̗\��

# �v�f�F���W�A���x�A

class Bullet

	attr_accessor :
	def initialize()
		
	end

end



######## �e�z��N���X ########
# �G�����@�����ʗ��p�̗\��
# �������l������ŃT���v�������番���Ă��B�B

# �v�f�F���A�F


class Bullets

	attr_accessor :
	def initialize()
		
	end

end



######## �|�b�v�A�b�v�N���X ########
# �n�܂�ƏI���Ɏg���z��B
# ���Ȃ�悾�낤���ǁA�^�C���C�x���g�̎����ł��g������

class Msgbox

	attr_accessor :
	def initialize()
		
	end

end

=end



######## ���C��				########
# �E�B���h�E������ꂽ�玩���I�ɏI������
# ���C�����[�v
Window.loop do

######## �X�^�[�g�m�F	########

#    msg.check(startcheck)

######## �ړ�����			########

#    $obj.each do |o|
#      o.moveAll
#    end

######## �����蔻��		########

# hit.check() # jiki enemy
# hit.check() # jiki enemy bullet
# hit.check() # jiki bullet enemy

######## �`�揈��			########

#  $obj.each do |o|
#    o.drawAll
#  end

######## ���f����			########

#  if Input.keyDown?(K_ESCAPE) == true then
#    msg.check(endcheck)
#  end

######## ���C���I��		########

end

