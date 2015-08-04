@ListEditor = React.createClass
  propTypes:
    initialContent: React.PropTypes.string
    initialTitle: React.PropTypes.string.isRequired
    listId: React.PropTypes.string
    infoContent: React.PropTypes.string.isRequired
    gistId: React.PropTypes.string
    username: React.PropTypes.string

  getDefaultProps: ->
    initialContent: ''

  getInitialState: ->
    content: @props.initialContent
    title: @props.initialTitle
    editing: false
    loading: false
    markdown: false
    editingContent: @props.initialContent

  componentDidMount: ->
    autosize(React.findDOMNode(@refs.content))
  componentDidUpdate: ->
    @focusTitle()
    @focusContent()
  focusTitle: ->
    title = React.findDOMNode(@refs.title)
    title?.focus()
    length = title?.value.length
    title?.setSelectionRange(length, length)
  focusContent: ->
    content = React.findDOMNode(@refs.content)
    content?.focus()

    evt = document.createEvent('Event')
    evt.initEvent('autosize:update', true, false)
    content.dispatchEvent(evt)

  handleToggleItem: (task) ->
    @updateTask(task, 'done', !task.done)
  updateTask: (task, attr, value) ->
    task[attr] = value
    @updateContent()

  updateContent: (parser) ->
    content = Parser.get().join()
    @setState
      content: content
    @save(content: content)
  handleInsertItem: (task) ->
    Parser.get().insert(task)
    @updateContent()
  handleRemoveItem: (task) ->
    Parser.get().remove(task)
    @updateContent()
  handleIndentItem: (task, level) ->
    task.level += level
    @updateContent()
  handleSaveItem: (task, name) ->
    @updateTask(task, 'name', name)

  handleContentChange: (e) ->
    @setState
      editingContent: e.target.value

  handleEditTitleClick: ->
    @setState(editing: true)
  handleCancelTitleClick: ->
    @setState(editing: false, title: @props.initialTitle)
  handleSaveTitleClick: ->
    @setState(loading: true)
    @save(title: @state.title)

  handleToggleMarkdown: ->
    @setState(markdown: !@state.markdown, editingContent: @state.content)
  handleCancelContentClick: ->
    @setState(markdown: false, content: @state.content)
  handleSaveContentClick: ->
    @setState(content: @state.editingContent)
    @save(content: @state.editingContent)

  save: (attr) ->
    params = list: attr
    path = '/lists'

    if @props.listId
      params._method = 'patch'
      path += "/#{@props.listId}"

    $.ajax
      method: 'POST'
      dataType: 'json'
      url: path
      data: params
      success: ->
      error: (jqXHR, textStatus, errorThrown) ->
        console.error(jqXHR, textStatus, errorThrown)
        errors = jqXHR.responseJSON
        alert(errors.join('\n'))
      complete: =>
        @setState(loading: false, editing: false, markdown: false)

  handleTitleChange: (e) ->
    @setState(title: e.target.value)

  render: ->
    parser = Parser.get().parse(@state.content)
    props =
      onToggle: @handleToggleItem
      onInsert: @handleInsertItem
      onRemove: @handleRemoveItem
      onIndent: @handleIndentItem
      onSave: @handleSaveItem

    itemNodes = parser.tasks.map (task, i) ->
      `<ListItem {...props} task={task} key={i} />`

    completed = parser.tasks.filter (t) -> t.done

    gistNode = if @props.gistId
                url = "https://gist.github.com/#{@props.username}/#{@props.gistId}"
                `<small>
                  <a href={url} target="_blank"><i className="fa fa-github fa-fw"></i></a>
                </small>`
               else
                ''

    header = `<h1>
               {this.state.title}
               &nbsp;
               <small>{completed.length} / {parser.tasks.length}</small>
               {gistNode}
             </h1>`

    titleNode = if @state.loading
                  `<div>
                    <div className="pull-right">
                      <i className="fa fa-spinner fa-fw fa-pulse fa-lg"></i>
                    </div>
                    {header}
                  </div>`
                else if @state.editing
                  `<div className="row">
                    <form onSubmit={this.handleSaveTitleClick}>
                      <div className="col-sm-8">
                        <input className="form-control input" value={this.state.title} onChange={this.handleTitleChange} ref="title" />
                      </div>
                      <div className="col-sm-4 text-right">
                        <div className="btn-group btn-group">
                          <button type="button" className="btn btn-primary" onClick={this.handleSaveTitleClick}>
                            {I18n.t('js.save')}
                          </button>
                          <button type="button" className="btn btn-default" onClick={this.handleCancelTitleClick}>
                            {I18n.t('js.cancel')}
                          </button>
                        </div>
                      </div>
                    </form>
                  </div>`
                else
                  `<div>
                    <div className="pull-right">
                      <button type="button" className="btn btn-default" onClick={this.handleEditTitleClick}>
                        {I18n.t('js.edit')}
                      </button>
                    </div>
                    {header}
                  </div>`

    `<div className={this.state.markdown ? 'markdown' : ''}>
      <ToggleMenu listMenu={true} onToggleMarkdown={this.handleToggleMarkdown} />
      <div className="row">
        <div className="col-sm-12">
          <div className="page-header">
            {titleNode}
          </div>
        </div>
        <div className="col-sm-8 html">
          <table className="table table-hover table-condensed table-clean">
            <tbody>
              {itemNodes}
            </tbody>
          </table>
        </div>
        <div className="col-sm-8 source">
          <p>
            <textarea className="form-control" value={this.state.editingContent} onChange={this.handleContentChange} ref="content" />
          </p>
          <div className="btn-group btn-group">
            <button type="button" className="btn btn-primary" onClick={this.handleSaveContentClick}>
              {I18n.t('js.save')}
            </button>
            <button type="button" className="btn btn-default" onClick={this.handleCancelContentClick}>
              {I18n.t('js.cancel')}
            </button>
          </div>
        </div>
        <div className="col-sm-4 info">
          <ul className="list-group" dangerouslySetInnerHTML={{ __html: this.props.infoContent }} />
        </div>
      </div>
    </div>`

