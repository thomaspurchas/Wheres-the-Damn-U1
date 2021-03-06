<!DOCTYPE HTML>
{{!"<html manifest='/static/bus.appcache'>" if APPCACHE else "<html>"}}
<head>
    <title>WTHTU1 - Where the Hell's the U1?</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-title" content="WTHTU1">
    <link rel="manifest" href="/static/android-manifest.json">
    <link rel="icon" type="image/png" href="/static/icon-32x32.png" />
    <link rel="apple-touch-icon" href="apple-touch-icon.png" />
    <link rel="apple-touch-icon" sizes="76x76" href="/static/icon-76x76.png" />
    <link rel="apple-touch-icon" sizes="120x120" href="/static/icon-120x120.png" />
    <link rel="apple-touch-icon" sizes="152x152" href="/static/icon-152x152.png" />
    <link rel="apple-touch-icon" sizes="180x180" href="/static/icon-180x180.png" />
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
    <script src="/static/geoPosition.js" type="text/javascript" charset="utf-8"></script>
    <script src="/static/modernizr.js" type="text/javascript"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.5.1/moment-with-langs.js"></script>
    <script src="https://use.typekit.net/xuz8lmw.js"></script>
    <script>try{Typekit.load({ async: true });}catch(e){}</script> 

    <link href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet">
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
    <style>
    html {
        height: 100%;
    }
    body {
        position: relative;
        padding: 5px;
        max-width: 520px;
        min-height: 100%;
        margin: auto;
        color: black;
    }
    body:after {
        content: '';
        z-index: -99;
        display: block;
        position: absolute;
        top: 0px;
        bottom: 0px;
        right: 0px;
        left: 0px;
        opacity: 0.05;
    }
    body h1:first-child {
        margin-top: 0px;
    }
    .btn:focus {
        outline: none;
    }
    .btn:active:focus {
        outline: none;
    }
    .btn:hover {
        background-color: white;
    }
    .btn-default:focus {
        background-color: white;
    }
    .update > *{
        display: inline-block;
        vertical-align: top;
    }
    #loc, #nearest {
        white-space: nowrap;
    }
    .grey {
        color: #b9b9b9;
    }
    .block {
        background: rgba(255,255,255,0.8);
        border-radius: 10px;
        padding: 10px 10px 5px 10px;
        margin-bottom: 10px;
        text-align: center;
    }
    p.update {
        margin-bottom: 0px;
    }
    #logo {
        display: block;
        width: 100%;
        margin: 15px auto 20px auto;
        max-width: 125px;
        font-family: "DomusTitling","jaf-domus-titling-web",sans-serif;
    }
    #updateError {
        display: none;
    }
    #offlineError {
        display: none;
    }
    #accuracyWarning {
        display: none;
    }
    #map-canvas {
        height: 183px;
        width: 100%;
        display: none;
        border-radius: 10px;
        margin-bottom: 10px;
    }
    #bus, #busDest {
        font-weight: bold;
    }
    #background {
        position: absolute;
        height: 100%;
        width: 100%;
        top: 0;
        left: 0;
        overflow: hidden;
        z-index: -99;
    }
    #background-map {
        height: 110%;
        width: 110%;
        margin: -5%;
        position: absolute;
        filter: blur(3px);
        -webkit-filter: blur(3px);
        -moz-filter: blur(3px);
        -o-filter: blur(3px);
        -ms-filter: blur(3px);
        background-color: #F4F5F5!important;
    }

    @media (min-width: 520px) {
        body {
            box-shadow: 0 0 20px 1px #505050;
            max-width: 510px;
        }
        #logo {
            max-width: 200px;
        }
    }

    .secondtime {display:none}
    </style>
</head>
<body>
<div id="background">
    <div id="background-map">
    </div>
</div>
% include('U1_day_logo.svg')

<div class="alert alert-danger" id="offlineError">
    <strong>Offline!</strong>
    There doesn't appear to be an internet connection so I can't get the latest
    bus data :(
</div>

<div class="block">
    <p>Your nearest stop is: <span id="nearest"></span></p>
</div>

<div class="block">
    <p>The next bus is <span id="bus">...</span><small class="grey" id="busTime"></small></br>going to <span id="busDest">...</span></p>

    <p class="secondtime">there is another bus <span id="altBus">...</span><small class="grey" id="altBusTime"></small> going to <span id="altBusDest">...</span></p>
</div>

<div id="map-canvas"></div>


<div class="alert alert-danger" id="updateError">
<strong>Oh snap!</strong> We couldn't get the latest bus data :(
<pre id="errorMessage"></pre>
</div>

<div class="alert alert-warning" id="accuracyWarning">
    <strong>Rubbish Location Data!</strong>
    The accuracy of the location data your device gave me is pretty crap,
    the bus stop picked is really just a guess I'm afraid :(
</div>

<p class="update">
    <button type="button" class="btn btn-default" id="updateButton" disabled>
        <i class="fa fa-compass fa-spin"></i>
        Getting Location
    </button>
    <small class="grey">Last Update:<br/><span id="lastUpdate">Never</span></small>
</p>

<script type="text/javascript">
    var nearestElmt = document.getElementById("nearest");
    var busElmt = document.getElementById("bus");
    var updateButton = $('#updateButton');
    var lastUpdate = null;
    var nextBus = null;
    var nextBusDest = null;
    var altBus = null;
    var altBusDest = null;
    var updateTimeout = null;
    var updateInterval = 20000; // Update the timers every 20 seconds
    var watch = null;
    var watchTimeout = null;
    var ipRequest = null;
    var map = null;
    var backgroundMap = null;
    var userCoords = null;
    var stopCoords = null;

    function setup() {
        $('#updateButton').click(function(event){
            if (navigator.onLine) {
                this.disabled = true;
                $(this).find('.fa-compass').addClass('fa-spin')
                $(this).contents().last()[0].textContent=' Getting Location';
                if(navigator.geolocation){
                    navigator.geolocation.clearWatch(watch);
                    watch = navigator.geolocation.watchPosition(success_callback,error_callback,{enableHighAccuracy:true});
                    watchTimeout = window.setTimeout(cancelGeoWatch, 15000);
                    ipRequest = $.getJSON("https://ip-dir.herokuapp.com") // Use the ip db, it should return faster and with a better result
                        .done(function(data) {
                            if (data.location) {
                                success_callback({coords:data.location});
                            }
                        });
                } else {
                    geoPosition.getCurrentPosition(
                                                success_callback,
                                                error_callback,
                                                {enableHighAccuracy:true}
                    );
                }
            }
        });

        $(window).on('online offline', function(event){
            if (event.type==="offline"){
                $('#offlineError').show();
                $('#updateButton').prop('disabled', true);
            }else{
                $('#offlineError').hide();
                $('#updateButton').prop('disabled', false);
            }
        });

        if (!navigator.onLine) {
            $(window).trigger('offline');
        }


        if(navigator.geolocation){
            $('#updateButton').click();
        }else if(geoPosition.init()){  // Geolocation Initialisation
            $('#updateButton').click();
        } else {
                // You cannot use Geolocation in this device
            // locElmt.innerHTML = "Damn, can't get your location. Sorry :(";
        }

        if (Modernizr.localstorage) {
            nextBus = moment(localStorage.getItem("nextBus"));
            nextBusDest = localStorage.getItem("nextBusDest");
            lastUpdate = moment(localStorage.getItem("lastUpate"));
            busStop = localStorage.getItem("busStop");
            if (busStop && nextBus.isAfter()) {
                nearestElmt.innerHTML = busStop;
            }
        }

        updateTimers(); // Get the ball rolling
    }

    function cancelGeoWatch() {
        navigator.geolocation.clearWatch(watch);
    }

    // p : geolocation object
    function success_callback(p) {
        // p.latitude : latitude value
        // p.longitude : longitude value

        coords = p.coords;
        if (coords.name) {
            // locElmt.innerHTML = coords.name +
            //     "<br/>Location Accuracy is " +
            //     Math.round(coords.accuracy) + "m";
        } else {
            // locElmt.innerHTML = Math.round(coords.latitude*10000)/10000 + ", " +
            //     Math.round(coords.longitude*10000)/10000 +
            //     "<br/>Location Accuracy is " +
            //     Math.round(coords.accuracy) + "m";
        }


        if (coords.accuracy > 65) {
            $('#accuracyWarning').show();
        }else{
            $('#accuracyWarning').hide();
            if(watch!=null){
                navigator.geolocation.clearWatch(watch);
                watch = null;
                window.clearTimeout(watchTimeout);
            }
            if(ipRequest!=null){
                ipRequest.abort();
                ipRequest = null;
            }
        }

        userCoords = coords;
        placeUserMarker(map);
        // placeUserMarker(backgroundMap);

        getBusData(coords);

    }

    function error_callback(p){
        // p.message : error message
        // locElmt.innerHTML = "Damn, can't get your location. Sorry :(";
        updateButton.prop('disabled', false);
        updateButton.find('.fa-compass').removeClass('fa-spin');
        updateButton.contents().last()[0].textContent=' Update Bus Info';
    }

    function getBusData(coords) {
        if (!coords) return;
        var update_moment = new moment();

        updateButton.contents().last()[0].textContent=' Getting Bus Info';
        $(updateButton).prop('disabled', true);

        $.getJSON("/nearest", {
            lat: coords.latitude,
            lon: coords.longitude
        })
          .done(function(data){
            $('#updateError').hide();
            lastUpdate = update_moment;
            updateTimers();

            if (Modernizr.localstorage) {
                localStorage.setItem("lastUpdate", lastUpdate);
            }

            nearestElmt.innerHTML = data.stop.name + " <small class='grey'>(" +
                Math.round(data.stop.distance) + "m)</small>";

            if (Modernizr.localstorage) {
                localStorage.setItem("busStop", nearestElmt.innerHTML);
            }

            stopCoords = data.stop.location;
            placeStopMarker(map);

            // Send some GA tracking stuff so I know the most popular bus stops
            ga('set', 'dimension1', data.stop.id + ' - ' + data.stop.name);
            ga('send', 'timing', 'Location', 'Got Stop Location', moment().diff(update_moment,'milliseconds'))

            if (data.next_bus != null){
                nextBus = moment(data.next_bus.time);
                nextBusDest = data.next_bus.destination;
                if (Modernizr.localstorage) {
                    localStorage.setItem("nextBus", nextBus);
                    localStorage.setItem("nextBusDest", nextBusDest);
                }
                updateTimers();
                $('.routeNumber').text(data.next_bus.route_number);
                $("#logo #route").text(data.next_bus.route_number);
            }else{
                busElmt.innerHTML = "Sorry, that data is not avaliable at the moment :(";
            }

            if (data.stop != null){
                $.getJSON("/stop/" + data.stop.id + "/next_departures")
                    .done(function(data) {
                        if (data.departures != null){
                            altBus = moment(data.departures[1].time);
                            altBusDest = data.departures[1].destination;
                            updateTimers();
                        }
                    });
            }

            updateButton.prop('disabled', false);
            updateButton.find('.fa-compass').removeClass('fa-spin');
            updateButton.contents().last()[0].textContent=' Update Bus Info';
          })
          .fail(function( jqxhr, textStatus, error ) {
            if (navigator.onLine) {
                updateButton.prop('disabled', false);
                updateButton.find('.fa-compass').removeClass('fa-spin');
                updateButton.contents().last()[0].textContent=' Update Bus Info';
                var err = textStatus + ", " + error;
                $('#errorMessage').text(err);
                $('#updateError').show();
            }
          });
    }

    function placeUserMarker(map) {
        if (map) {
            var coords = userCoords;

            if (map.get('userMarker')) { map.get('userMarker').setMap(null) }

            var googUserLatLon = new google.maps.LatLng(coords.latitude, coords.longitude);

            var userMarker = new google.maps.Marker({
                position: googUserLatLon,
                icon: {
                    url: '/static/user-marker.png',
                    anchor: new google.maps.Point(8, 8),
                    scaledSize: new google.maps.Size(16, 16),
                    size: new google.maps.Size(32, 32)
                }
            });

            userMarker.setMap(map);
            map.set('userMarker', userMarker)

            if (map.get('accuracyCircle')) { map.get('accuracyCircle').setMap(null) }

            var accuracyCircleOptions = {
                strokeColor: '#5191E7',
                strokeOpacity: 0.8,
                strokeWeight: 1,
                fillColor: '#5191E7',
                fillOpacity: 0.35,
                center: googUserLatLon,
                radius: coords.accuracy
            };

            accuracyCircle = new google.maps.Circle(accuracyCircleOptions);
            accuracyCircle.setMap(map);
            map.set('accuracyCircle', accuracyCircle);
        }
    }

    function placeStopMarker(map) {
        if (map) {

            var coords = stopCoords;

            var googBusLatLon = new google.maps.LatLng(coords.lat, coords.lon);
            var googUserLatLon = new google.maps.LatLng(userCoords.latitude, userCoords.longitude);

            if (map.get('busMarker')) {map.get('busMarker').setMap(null)}

            var busMarker = new google.maps.Marker({
                position: googBusLatLon,
                icon: {
                    url: '/static/bus-marker.png',
                    anchor: new google.maps.Point(16, 32),
                    scaledSize: new google.maps.Size(32, 32),
                    size: new google.maps.Size(64, 64)
                }
            });

            busMarker.setMap(map);
            map.set('busMarker', busMarker);

            var bounds = new google.maps.LatLngBounds(googBusLatLon);
            bounds = bounds.extend(googUserLatLon);
            map.fitBounds(bounds);
        }
    }

    function updateTimers() {
        if (lastUpdate) {
            $('#lastUpdate').text(lastUpdate.fromNow());
        }

        if (nextBus) {
            if (nextBus.isAfter(moment().subtract('s', 40))) {
                $('#bus').text(nextBus.fromNow());
                $('#busTime').text(nextBus.format(' (HH:mm)'));
                $('#busDest').text(nextBusDest);
                if (moment().add('m', 5).isAfter(nextBus)) {
                    // If bus is in 5 mins turn text red
                    $('#bus').addClass('text-danger');
                } else {
                    $('#bus').removeClass('text-danger');
                }
                if (moment().isAfter(nextBus)) {
                    $('#bus').text('now');
                }
            } else {
                $('#bus').text('...');
                $('#busTime').text('');
                $('#busDest').text('...');
                $('#bus').removeClass('text-danger');
                getBusData(userCoords);
                nextBus = null;
                nextBusDest = null;
            }
        }

        if (altBus) {
            if (altBus.isAfter(moment().subtract('s', 40))) {
                $('#altBus').text(altBus.fromNow());
                $('#altBusTime').text(altBus.format(' (HH:mm)'));
                $('#altBusDest').text(altBusDest);
            } else {
                $('#altBus').text('...');
                $('#altBusTime').text('');
                $('#altBusDest').text('...');
                altBus = null;
                altBusDest = null;
            }
        }

        clearTimeout(updateTimeout);
        var timeTillMin = 1100 - moment().milliseconds();
        updateTimeout = window.setTimeout(updateTimers, Math.min(updateInterval, timeTillMin));
    }

    function offsetMapCenter(map,latlng,offsetx,offsety) {

        // latlng is the apparent centre-point
        // offsetx is the distance you want that point to move to the right, in pixels
        // offsety is the distance you want that point to move upwards, in pixels
        // offset can be negative
        // offsetx and offsety are both optional

        var scale = Math.pow(2, map.getZoom());
        var nw = new google.maps.LatLng(
            map.getBounds().getNorthEast().lat(),
            map.getBounds().getSouthWest().lng()
        );

        var worldCoordinateCenter = map.getProjection().fromLatLngToPoint(latlng);
        var pixelOffset = new google.maps.Point((offsetx/scale) || 0,(offsety/scale) ||0)

        var worldCoordinateNewCenter = new google.maps.Point(
            worldCoordinateCenter.x - pixelOffset.x,
            worldCoordinateCenter.y + pixelOffset.y
        );

        var newCenter = map.getProjection().fromPointToLatLng(worldCoordinateNewCenter);

        map.panTo(newCenter);

    }

    function initializeMap() {
        var mapOptions = {
          center: new google.maps.LatLng(52.287373, -1.548609),
          zoom: 12,
          streetViewControl: false,
          disableDefaultUI: true,
          draggable: false,
          disableDoubleClickZoom: true
        };
        mapOptions["styles"] = dayStyle;
        map = new google.maps.Map(document.getElementById("map-canvas"),
            mapOptions);

        mapOptions["styles"] = dayBackgroundStyle;
        backgroundMap = new google.maps.Map(document.getElementById("background-map"),
            mapOptions);

        google.maps.event.addListener(map, 'center_changed', function() {
            // Set backgroundMap to match actual map
            offsetMapCenter(backgroundMap, map.getCenter(), 0, 180);
        });

        google.maps.event.addListener(map, 'zoom_changed', function() {
            // Set backgroundMap zoom to be further out than actual map
            var zoom = map.getZoom() - 1;
            if (zoom > 17) {
                zoom = 17;
            } else if (zoom < 1) {
                zoom = 1;
            }

            backgroundMap.setZoom(zoom);
            offsetMapCenter(backgroundMap, map.getCenter(), 0, 180);
        });

        if (userCoords) {
            placeUserMarker(map);
            // placeUserMarker(backgroundMap);
        }
        if (stopCoords) {
            placeStopMarker(map);
        }

        $('#map-canvas').show();
    }

    function loadMapsScript() {
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = '//maps.googleapis.com/maps/api/js?key=AIzaSyB8UbiD-uUDWxHJxR4fXgBbcBzgFFKUDCY&sensor=true&' +
          'callback=initializeMap';
        document.body.appendChild(script);
    }

    var AppCacheTimeout = -1;
    function AppCacheReady() {
        clearTimeout(AppCacheTimeout);
        window.applicationCache.removeEventListener('noupdate',
            arguments.callee, false);
        window.applicationCache.removeEventListener('cached',
            arguments.callee, false);

        $(setup);
        loadMapsScript();

        //Load the external api (dynamic script insertion),
        //  initalize the page, etc....
    }
    if (window.applicationCache && window.applicationCache.status != window.applicationCache.UNCACHED) {
        AppCacheTimeout = setTimeout(AppCacheReady, 2000);

        window.applicationCache.addEventListener('updateready', function () {
            window.applicationCache.swapCache();
            location.reload();
        }, false);
        window.applicationCache.addEventListener('obsolete',function () {
            window.location.reload(true);
        }, false);
        window.applicationCache.addEventListener('noupdate', AppCacheReady,
            false);
        window.applicationCache.addEventListener('cached', AppCacheReady,
            false);
        window.applicationCache.addEventListener('error', function() {
        // provide user feedback - your page is probably broken.
        }, false);
    } else {
        AppCacheReady();
    }

    var dayStyle = [{"featureType":"all","elementType":"all","stylers":[{"visibility":"on"}]},{"featureType":"all","elementType":"all","stylers":[{"visibility":"on"}]},{"featureType":"road","elementType":"all","stylers":[{"visibility":"on"},{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"all","stylers":[{"visibility":"on"},{"color":"#fee379"}]},{"featureType":"road.highway","elementType":"all","stylers":[{"visibility":"on"},{"color":"#fee379"}]},{"featureType":"landscape.man_made","elementType":"geometry.stroke","stylers":[{"visibility":"on"},{"invert_lightness":false},{"color":"#f3f4f4"},{"weight":0.28},{"lightness":-46}]},{"featureType":"landscape.man_made","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":"#f3f4f4"}]},{"featureType":"landscape.natural","elementType":"all","stylers":[{"visibility":"on"},{"color":"#f3f4f4"}]},{"featureType":"water","elementType":"all","stylers":[{"visibility":"on"},{"color":"#7fc8ed"}]},{"featureType":"road","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":"#90f069"}]},{"featureType":"all","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#f3f4f4"},{"weight":0.6},{"lightness":-25}]},{"featureType":"road","elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":"#000000"}]},{"featureType":"poi","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"poi.school","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":"#f3f4f4"},{"lightness":-3}]}];

    var dayBackgroundStyle = dayStyle.slice();
    // Turn off road labels
    dayBackgroundStyle.push({
        "featureType":"road",
        "elementType":"labels.text.stroke",
        "stylers":[
            {
            "visibility":"off"
            }
        ]});
</script>

<script type="text/javascript">
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-9039747-5', 'auto');
  ga('require', 'displayfeatures');
  ga('send', 'pageview');

</script>

</body>
</html>
