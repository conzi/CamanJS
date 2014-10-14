module.exports = (Caman) ->
  Caman.Renderer.register 'brightness', (adjust) ->
    adjust = Math.floor 255 * (adjust / 100)

    new Caman.Filter ->
      @r += adjust
      @g += adjust
      @b += adjust

  Caman.Renderer.register 'fillColor', (args...) ->
    if args.length is 1
      color = Caman.Color.hexToRGB args[0]
    else
      color = args

    new Caman.Filter ->
      @r = color[0]
      @g = color[1]
      @b = color[2]
      @a = 255

  Caman.Renderer.register 'saturation', (adjust) ->
    adjust *= -0.01
    new Caman.Filter ->
      max = Math.max @r, @g, @b
      @r += (max - @r) * adjust if @r isnt max
      @g += (max - @g) * adjust if @g isnt max
      @b += (max - @b) * adjust if @b isnt max

  Caman.Renderer.register 'vibrance', (adjust) ->
    adjust *= -1
    new Caman.Filter ->
      max = Math.max @r, @g, @b
      avg = (@r + @g + @b) / 3
      amt = ((Math.abs(max - avg) * 2 / 255) * adjust) / 100

      @r += (max - @r) * amt if @r isnt max
      @g += (max - @g) * amt if @g isnt max
      @b += (max - @b) * amt if @b isnt max

  Caman.Renderer.register 'greyscale', (adjust) ->
    new Caman.Filter ->
      @r = @g = @b = Caman.Calculate.luminance(@r, @g, @b)

  Caman.Renderer.register 'contrast', (adjust) ->
    adjust = Math.pow (adjust + 100) / 100, 2
    new Caman.Filter ->
      @r = ((((@r / 255) - 0.5) * adjust) + 0.5) * 255
      @g = ((((@g / 255) - 0.5) * adjust) + 0.5) * 255
      @b = ((((@b / 255) - 0.5) * adjust) + 0.5) * 255

  Caman.Renderer.register 'hue', (adjust) ->
    new Caman.Filter ->
      [h, s, v] = Caman.Color.rgbToHSV @r, @g, @b
      h = (((h * 100) + Math.abs(adjust)) % 100) / 100
      [@r, @g, @b] = Caman.Color.hsvToRGB(h, s, v)
