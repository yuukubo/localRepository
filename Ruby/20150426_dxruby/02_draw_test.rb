require 'dxruby'

image = Image.load("ego.jpg")

Window.loop do
  Window.draw(0, 0, image)
end
