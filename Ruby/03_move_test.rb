require 'dxruby'

x = 0
image = Image.load("ego.jpg")

Window.loop do
  x = x + Input.x
  Window.draw(x, 0, image)
end
