class @Task
  @MARKER = '(?:\\-|\\*|\\d\\.)'
  @COMPLETED = 'x'
  @STATE = "\\[[#{@COMPLETED}\\s]\\]"
  @INDENT = '^\\s*'
  @SEPARATOR = '\\s+'
  @BODY = '[\\s\\S]*'

  @rawName: (name) ->
    name.replace(/\s*<br>\s*/g, ' ').replace(/\n$/, '').replace(/\n/g, ' ')

  constructor: (@source, @parser) ->
    @parse()

  parse: ->
    matches = ///
      (#{Task.INDENT})#{Task.MARKER}#{Task.SEPARATOR}
      (#{Task.STATE})#{Task.SEPARATOR}
      (#{Task.BODY})
      ///i.exec(@source)
    @valid = !!matches
    return unless @valid

    @level = Math.floor(matches[1].length / 2)
    @done = ///#{Task.COMPLETED}///i.test(matches[2])
    @name = matches[3].replace(/  \n/g, '<br>')

  stringify: ->
    s = "#{Array(@level + 1).join('  ')}- [#{if @done then 'x' else ' '}] #{@name.replace(/<br>/gim, '  \n')}"
    s += '\n' unless /\n$/.test(s)
    s

