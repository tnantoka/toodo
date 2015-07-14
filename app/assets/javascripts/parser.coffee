class @Parser

  class PrivateParser
    constructor: (content) ->
      @parse(content)

    setContent: (content) ->
      @content = content
      @content += '\n' unless /\n$/.test(content)

    parse: (content, pad = true) ->
      @setContent(content)
      @maxLevel = 0
      @tasks = for line in @lines()
        task = new Task(line, @)
        continue unless task.valid
        @maxLevel = Math.max(@maxLevel, task.level)
        task
      @pad() if pad
      @

    lines: ->
      @content
        .replace(/\t/g, '  ')
        .replace(///^(#{Task.INDENT}#{Task.MARKER})///gim, '\t$1')
        .split('\t')

    insert: (task) ->
      index = @tasks.indexOf(task)
      newTask = new Task('- [ ] ', @)
      newTask.level = task?.level || 0
      @tasks.splice(index + 1, 0, newTask)

    remove: (task) ->
      index = @tasks.indexOf(task)
      @tasks.splice(index, 1)
      @pad()

    pad: ->
      @insert(null) unless @tasks.length

    join: ->
      @tasks
        .map (task) -> task.stringify()
        .join('')

  instance = null
  @get: ->
    instance ?= new PrivateParser


