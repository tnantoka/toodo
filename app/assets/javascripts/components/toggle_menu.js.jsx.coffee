@ToggleMenu = React.createClass
  propTypes:
    listMenu: React.PropTypes.bool
    onToggleMarkdown: React.PropTypes.func

  handleMenuClick: ->
    $('#wrapper').toggleClass('toggled')
  handleSettingsClick: ->
    $('#wrapper').toggleClass('settings')
  handleMarkdownClick: ->
    @props.onToggleMarkdown()
  render: ->
    listMenu = if @props.listMenu
      [
        `<button type="button" className="btn btn-default" onClick={this.handleSettingsClick} key="settings">
          <span className="glyphicon glyphicon-cog"></span>
        </button>`,
        `<button type="button" className="btn btn-default" onClick={this.handleMarkdownClick} key="markdown">
          <span className="octicon octicon-markdown"></span>
        </button>`
      ]
    else
      ''

    `<div className="btn-group l-toggle-menu">
      <button type="button" className="btn btn-default" onClick={this.handleMenuClick}>
        <span className="glyphicon glyphicon-menu-hamburger"></span>
      </button>
      {listMenu}
    </div>`
