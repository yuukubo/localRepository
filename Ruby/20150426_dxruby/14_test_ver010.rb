require 'dxruby'
require 'win32ole'

# ���낻��N���X������������

######## ��`�� ########

x = 320    # �����x���W
y = 400    # �����y���W
tamax = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1] # ���܂�x���W�z��
tamay = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1] # ���܂�y���W�z��
tekix = [rand(470) + 1, rand(470) + 1, rand(470) + 1]  # �Ă���x���W�z��
tekiy = [rand(200) + 1, rand(200) + 1, rand(200) + 1]  # �Ă���y���W�z��
tekid = [rand(6) + 1, rand(6) + 1, rand(6) + 1]   # �Ă��̈ړ��ʔz��

# �摜�ǂݍ���
jiki = Image.load("jiki.png")
bullet = Image.load("bullet.png")
teki = Image.load("teki.png")

######## ���C�� ########

# ���C�����[�v
Window.loop do

######## ���@���� ########

  # ����̈ړ�
  x = x + Input.x * 8
  y = y + Input.y * 8

  # ���ɂ͂ݏo�����`�F�b�N
  if x < 0 then
    x = 0
  end

  # �E�ɂ͂ݏo�����`�F�b�N
  if x > 639 - jiki.width then
    x = 639 - jiki.width
  end

  # ��ɂ͂ݏo�����`�F�b�N
  if y < 0 then
    y = 0
  end

  # ���ɂ͂ݏo�����`�F�b�N
  if y > 479 - jiki.height then
    y = 479 - jiki.height
  end

  # ����`��
  Window.draw(x, y, jiki)

######## ���@�e���� ########

  # Z�L�[�Œe����
  if Input.keyPush?(K_Z) == true then
    for i in 0..9 do # i��0����9�܂ŕς��Ȃ��烋�[�v
      if tamay[i] < 0 then
        tamax[i] = x
        tamay[i] = y
        break # �e���΂����烋�[�v�𒆒f����
      end
    end
  end

  # �e����ʓ��ɂ���ꍇ�A�e�̈ړ��ƕ`��
  for i in 0..9 do # i��0����9�܂ŕς��Ȃ��烋�[�v
    if tamay[i] >= 0 then
      tamay[i] = tamay[i] - 8
      Window.draw(tamax[i], tamay[i], bullet)
    end
  end

######## �G���� ########

  # ���ɂ͂ݏo�����`�F�b�N
  for i in 0..2 do # i��0����2�܂ŕς��Ȃ��烋�[�v
	  if tekix[i] < 0 then
	    tekix[i] = rand(470) + 1
	  end
  end

  # �E�ɂ͂ݏo�����`�F�b�N
  for i in 0..2 do # i��0����2�܂ŕς��Ȃ��烋�[�v
	  if tekix[i] > 639 - teki.width then
	    tekix[i] = rand(470) + 1
	  end
  end

  # ��ɂ͂ݏo�����`�F�b�N
  for i in 0..2 do # i��0����2�܂ŕς��Ȃ��烋�[�v
	  if tekiy[i] < 0 then
  	  tekiy[i] = rand(200) + 1
	  end
  end

  # ���ɂ͂ݏo�����`�F�b�N
  for i in 0..2 do # i��0����2�܂ŕς��Ȃ��烋�[�v
	  if tekiy[i] > 479 - teki.height then
	    tekiy[i] = rand(200) + 1
	  end
  end

  # �Ă��̈ړ��ƃ`�F�b�N
  for i in 0..2 do # i��0����2�܂ŕς��Ȃ��烋�[�v
#	  tekix[i] = tekix[i] + tekid[i]
#		if tekix[i] < 10 or tekix[i] > 639 - teki.width - 10 then
#			tekid[i] = -tekid[i]
#			tekiy[i] = tekiy[i] + 10
#		end
		tekix[i] = tekix[i] + tekid[i] * (-1 * (-1 + (rand(2) * 2)))
		tekiy[i] = tekiy[i] + tekid[i]
  # �Ă��`��
	  Window.draw(tekix[i], tekiy[i], teki)
  end

######## �����蔻�菈�� ########

  # ���܂ƂĂ��̓����蔻��Ə���
  for i in 0..9 do # i��0����9�܂ŕς��Ȃ��烋�[�v
	  for k in 0..2 do # k��0����2�܂ŕς��Ȃ��烋�[�v
		  if tamay[i] >= 0 and
		     tamax[i] - (tekix[k] + teki.width - 10) < 0 and tamay[i] - (tekiy[k] + teki.height - 10) < 0 and
		     tekix[k] - (tamax[i] + bullet.width - 5) < 0 and tekiy[k] - (tamay[i] + bullet.height - 5) < 0 then
				tekix[k] = rand(470) + 1  # �Ă���x���W
				tekiy[k] = rand(200) + 1  # �Ă���y���W
				tekid[k] = rand(6) + 1   # �Ă��̈ړ���
			  tamax[i] = -1
			  tamay[i] = -1
			end
	  end
  end

  # ���@�ƓG�̓����蔻��Ə���
  for i in 0..2 do # i��0����2�܂ŕς��Ȃ��烋�[�v
	  if tekiy[i] <= 480 and
	    tekix[i] - (x + jiki.width - 15) < 0 and tekiy[i] - (y + jiki.height - 25) < 0 and
	    x - (tekix[i] + teki.width - 15) < 0 and y - (tekiy[i] + teki.height - 25) < 0 then
			x = 320    # �����x���W
			y = 400    # �����y���W
		end
  end

  # �G�X�P�[�v�L�[�ŏI������
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

######## ���C���I�� ########

end
