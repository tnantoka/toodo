@Dashboard = React.createClass
  getInitialState: ->
    lists = []

    for list in @props.lists
      parser = Parser.get().parse(list.content, false)
      tasks =  parser.tasks.filter (t) -> t.valid
      lists.push
        title: list.title
        tasks: tasks
        href: "/lists/#{list.slug}"

    lists: lists

  componentDidMount: ->
    self = @
    options =
      dataType: 'script'
      cache: true,
      url: 'https://www.google.com/jsapi'
    $.ajax(options).done ->
      google.load 'visualization', '1.0',
        packages:["corechart"]
        callback: ->
          self.setState(chart: true)

  componentDidUpdate: ->
    @drawCharts() if @state.chart

  drawCharts: ->
    listsData = new google.visualization.DataTable()
    listsData.addColumn('string')
    listsData.addColumn('number')

    tasksData = new google.visualization.DataTable()
    tasksData.addColumn('string')
    tasksData.addColumn('number')

    listsDone = 0
    listsRemaining = 0

    tasksDone = 0
    tasksRemaining = 0

    for list in @state.lists
      remainings = list.tasks.filter (t) -> !t.done

      if remainings.length
        listsRemaining += 1
      else
        listsDone += 1

      tasksRemaining += remainings.length
      tasksDone += list.tasks.length - remainings.length

    listsData.addRows([
      [I18n.t('js.completed_lists'), listsDone],
      [I18n.t('js.remaining_lists'), listsRemaining],
    ])

    tasksData.addRows([
      [I18n.t('js.completed_tasks'), tasksDone],
      [I18n.t('js.remaining_tasks'), tasksRemaining],
    ])

    colors = ['#3366cc', '#dc3912', '#ff9900', '#109618', '#990099', '#0099c6', '#dd4477', '#66aa00', '#b82e2e', '#316395', '#994499', '#22aa99', '#aaaa11', '#6633cc', '#e67300', '#8b0707', '#651067', '#329262', '#5574a6', '#3b3eac', '#b77322', '#16d620', '#b91383', '#f4359e', '#9c5935', '#a9c413', '#2a778d', '#668d1c', '#bea413', '#0c5922', '#743411']

    options =
      legend: 'none'
      pieHole: 0.4
      pieSliceText: 'value'
      backgroundColor:
        strokeWidth: 2
        stroke: '#ddd'
        fill: '#f9f9f9'
      chartArea:
        width: '100%'
        height: '80%'
      fontSize: 14

    options.colors = [colors[9], colors[6]]
    lists = React.findDOMNode(@refs.lists)
    chart = new google.visualization.PieChart(lists)
    chart.draw(listsData, options)

    options.colors = [colors[17], colors[10]]
    tasks = React.findDOMNode(@refs.tasks)
    chart = new google.visualization.PieChart(tasks)
    chart.draw(tasksData, options)

  render: ->
    todoNodes = @state.lists.map (list, i) ->
      tasks = list.tasks.filter (t) -> !t.done
      return null unless tasks.length
      taskNodes = tasks.map (task, j) ->
        `<li key={j}>
          {new Array(task.level + 1).join('\u00a0\u00a0')}{task.name}
        </li>`

      `<tr key={i}>
        <td>
          <ul className="list-unstyled">{taskNodes}</ul>
        </td>
        <td><a href={list.href}>{list.title}</a></td>
      </tr>`

    `<div>
      <div className="row">
        <div className="col-sm-6">
          <div ref="lists" />
        </div>
        <div className="col-sm-6">
          <div ref="tasks" />
        </div>
      </div>
      <h4>{I18n.t('js.todo')}</h4>
      <table className="table table-bordered table-striped">
        <tbody>
          {todoNodes}
        </tbody>
      </table>
    </div>`
