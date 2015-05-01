class Elections

    constructor: ->
        # Load charts library
        google.load 'visualization', '1.0', 'packages': ['corechart']
        # Load Map
        google.maps.event.addDomListener window, 'load', @.initialize

    initialize: =>
        @.loadMap()
        @loadStates()
        @renderStates()
        @bindEvents()

    loadMap: ->
        @.center = new google.maps.LatLng -40.3863590950962, -63.831314974999984
        mapOptions =
            zoom: 4,
            center: @.center
        @.map = new google.maps.Map document.getElementById('map'), mapOptions
        # Responsive map
        google.maps.event.addDomListener window, "resize", =>
           center = @.map.getCenter()
           google.maps.event.trigger @.map, "resize"
           @.map.setCenter center

    loadStates: ->
        @.states =
            buenosAires:
                name: 'Buenos Aires'
                kmlURL: 'https://dl.dropboxusercontent.com/u/14133267/Elecciones2015/BuenosAires.kml'
                values: [['PRO', 47.3], ['ECO', 22.3], ['FPV', 18.7], ['IZQ', 2.3], ['Otros', 9.4]]
                colors: ['#FEDB04', '#7CC374', '#1796D7', '#FFAD5C', '#E0EBEB']
            neuquen:
                name: 'Neuquen'
                kmlURL: 'https://dl.dropboxusercontent.com/u/14133267/Elecciones2015/Neuquen.kml'
                values: [['MPN', 37.86], ['FPV', 28.87], ['PRO', 19.45], ['Otros', 33.3]]
                colors: ['#7CC374', '#1796D7', '#FEDB04', '#E0EBEB']

    renderStates: ->
        for state, values of @.states
            @.renderState state, values

    renderState: (state, values) ->
        @.states[state].kml = new google.maps.KmlLayer
            url: values.kmlURL + '?' + Math.random()
            preserveViewport: true
        @.states[state].kml.setMap @.map

    bindEvents: ->
        for state, values of @.states
            @.bindEvent state, values

    bindEvent: (state, values) ->
        google.maps.event.addListener @.states[state].kml, 'click', (event) =>
            @.renderChart @.states[state].values, @.states[state].name, @.states[state].colors
            event.featureData.infoWindowHtml = $('#chart_div').html()

    renderChart: (rows, title, colors) =>
        data = new google.visualization.DataTable()
        data.addColumn 'string', 'Topping'
        data.addColumn 'number', 'Slices'
        data.addRows rows
        # Set chart options
        options =
            title: 'Resultados ' + title
            width: 350,
            height: 350
            colors: colors
        # Instantiate and draw our chart, passing in some options.
        chart = new google.visualization.PieChart document.getElementById 'chart_div'
        chart.draw data, options

# Start the page
window.elections = new Elections()
