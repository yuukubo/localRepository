require 'dxruby'

x = 0      # �����x���W
y = 0      # �����y���W
tamax = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1] # ���܂�x���W�z��
tamay = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1] # ���܂�y���W�z��

# �摜�ǂݍ���
jiki = Image.load("jiki.png")
bullet = Image.load("bullet.png")

# ���C�����[�v
Window.loop do
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
  if y > 470 - jiki.width then
    y = 470 - jiki.width
  end

  # ����`��
  Window.draw(x, y, jiki)

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
end
