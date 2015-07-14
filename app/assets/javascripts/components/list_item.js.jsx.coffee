@ListItem = React.createClass
  propTypes:
    task: React.PropTypes.object.isRequired
    onToggle: React.PropTypes.func.isRequired
    onInsert: React.PropTypes.func.isRequired
    onRemove: React.PropTypes.func.isRequired
    onSave: React.PropTypes.func.isRequired
    onIndent: React.PropTypes.func.isRequired

  getInitialState: ->
    editing: !@props.task.name.length
    name: @props.task.name

  componentDidMount: ->
    @focusName()
  componentDidUpdate: ->
    @focusName()
  focusName: ->
    return if $(':not(a):focus').length
    name = React.findDOMNode(@refs.name)
    name?.focus()
    length = name?.value.length
    name?.setSelectionRange(length, length)
  componentWillReceiveProps: (nextProps) ->
    @setState(name: nextProps.task.name)
    @setState(editing: true) unless nextProps.task.name.length

  handleDoneChange: (e) ->
  handleDoneClick: ->
    @props.onToggle(@props.task)

  handleEditClick: (e) ->
    e.preventDefault()
    @setState(editing: true)
  handleInsertClick: (e) ->
    e.preventDefault()
    @props.onInsert(@props.task)
  handleRemoveClick: (e) ->
    e.preventDefault()
    @props.onRemove(@props.task)
  handleIndentClick: (e) ->
    e.preventDefault()
    @props.onIndent(@props.task, 1)
  handleOutdentClick: (e) ->
    e.preventDefault()
    @props.onIndent(@props.task, -1)

  handleSaveClick: (e) ->
    e.preventDefault()
    @setState(editing: false)
    @props.onSave(@props.task, @state.name)
  handleCancelClick: (e) ->
    e.preventDefault()
    @setState(editing: false, name: @props.task.name)

  handleNameChange: (e) ->
    @setState(name: e.target.value)

  render: ->
    spacer = [0...@props.task.level].map (i) ->
      `<td key={i} className="cell-checkbox"></td>`

    name = @state.name
    nameNode = if @state.editing
                name = Task.rawName(name)
                `<div>
                  <ul className="list-inline pull-right hover-item">
                    <li>
                      <a onClick={this.handleSaveClick}>
                        <span className="glyphicon glyphicon-ok"></span>
                      </a>
                    </li>
                    <li>
                      <a onClick={this.handleCancelClick}>
                        <span className="glyphicon glyphicon-remove"></span>
                      </a>
                    </li>
                  </ul>
                  <input className="form-control in-place" value={name} onChange={this.handleNameChange} ref="name" />
                </div>`
               else
                `<div>
                  <ul className="list-inline pull-right hover-item">
                    <li className={this.props.task.level == 0 ? 'hidden' : ''}>
                      <a href="#" onClick={this.handleOutdentClick}>
                        <span className="glyphicon glyphicon-chevron-left"></span>
                      </a>
                    </li>
                    <li>
                      <a href="#" onClick={this.handleIndentClick}>
                        <span className="glyphicon glyphicon-chevron-right"></span>
                      </a>
                    </li>
                    <li>
                      <a href="#" onClick={this.handleEditClick}>
                        <span className="glyphicon glyphicon-pencil"></span>
                      </a>
                    </li>
                    <li>
                      <a href="#" onClick={this.handleInsertClick}>
                        <span className="glyphicon glyphicon-plus"></span>
                      </a>
                    </li>
                    <li>
                      <a href="#" onClick={this.handleRemoveClick}>
                        <span className="glyphicon glyphicon-trash"></span>
                      </a>
                    </li>
                  </ul>
                  <span dangerouslySetInnerHTML={{ __html: name }} onClick={this.handleEditClick} className="pointer"></span>
                </div>`

    `<tr className="hover-container">
      {spacer}
      <td className="cell-checkbox" onClick={this.handleDoneClick}>
        <input type="checkbox" checked={this.props.task.done} onChange={this.handleDoneChange} />
      </td>
      <td colSpan={this.props.task.parser.maxLevel - this.props.task.level + 1}>
        {nameNode}
      </td>
    </tr>`

