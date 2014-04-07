<!DOCTYPE HTML>
<html manifest="/static/bus.appcache">
<head>
    <title>WTHTU1</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
    <meta name="mobile-web-app-capable" content="yes">
    <link rel="icon" sizes="120x120" href="apple-touch-icon.png">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
    <script src="/static/geoPosition.js" type="text/javascript" charset="utf-8"></script>
    <script src="/static/modernizr.js" type="text/javascript"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.5.1/moment-with-langs.js"></script>

    <link href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet">
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
    <style>
    body {
        padding: 5px;
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
    #loc, #nearest {
        white-space: nowrap;
    }
    .grey {
        color: #b9b9b9;
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
        height: 200px;
        max-width: 500px;
        width: 100%;
        display: none;
    }
    #bus {
        font-weight: bold;
    }
    </style>
</head>
<body>

<h1>Where the hell's the <span class="routeNumber">U1</span>?</h1>

<div class="alert alert-danger" id="offlineError">
    <strong>Offline!</strong>
    There doesn't appear to be an internet connection so I can't get the latest
    bus data :(
</div>

<p>Your location is: <span id="loc">...</span></p>

<p>Your nearest <span class="routeNumber">U1</span> bus stop is: <span id="nearest">...</span></p>

<p>and the next bus is <span id="bus">...</span></p>

<p>
    <div id="map-canvas"></div>
</p>

<div class="alert alert-danger" id="updateError">
<strong>Oh snap!</strong> We couldn't get the latest bus data :(
<pre id="errorMessage"></pre>
</div>

<div class="alert alert-warning" id="accuracyWarning">
    <strong>Rubbish Location Data!</strong>
    The accuracy of the location data your device gave me is pretty crap,
    the bus stop picked is really just a guess I'm afraid :(
</div>

<p>
    <button type="button" class="btn btn-default" id="updateButton" disabled>
        <i class="fa fa-compass fa-spin"></i>
        Getting Location
    </button>
    <small class="grey">Last Update: <span id="lastUpdate">Never<span></small>
</p>

<script type="text/javascript">
    var locElmt = document.getElementById("loc");
    var nearestElmt = document.getElementById("nearest");
    var busElmt = document.getElementById("bus");
    var updateButton = $('#updateButton');
    var lastUpdate = null;
    var nextBus = null;
    var updateTimeout = null;
    var updateInterval = 45000; // Update the timers every 45 seconds (this is the smallest human interval for moment)
    var watch = null;
    var userMarker = null;
    var busMarker = null;
    var accuracyCircle = null;
    var map = null;
    var userCoords = null;
    var stopCoords = null;

    function setup() {
        $('#updateButton').click(function(event){
            if (navigator.onLine) {
                this.disabled = true;
                $(this).find('.fa-compass').addClass('fa-spin')
                $(this).contents().last()[0].textContent=' Getting Location';
                if(navigator.geolocation){
                    watch = navigator.geolocation.watchPosition(success_callback,error_callback,{enableHighAccuracy:true});
                }else{
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
            watch = navigator.geolocation.watchPosition(success_callback,error_callback,{enableHighAccuracy:true});
            $('#updateButton').prop('disabled', true);
        }else if(geoPosition.init()){  // Geolocation Initialisation
            geoPosition.getCurrentPosition(success_callback,error_callback,{enableHighAccuracy:true, maximumAge:1000});
        } else {
                // You cannot use Geolocation in this device
            locElmt.innerHTML = "Damn, can't get your location. Sorry :(";
        }

        if (Modernizr.localstorage) {
            nextBus = moment(localStorage.getItem("nextBus"));
            lastUpdate = moment(localStorage.getItem("lastUpate"));
            busStop = localStorage.getItem("busStop");
            if (busStop && nextBus.isAfter()) {
                nearestElmt.innerHTML = busStop;
            }
        }

        updateTimers(); // Get the ball rolling
    }

    // p : geolocation object
    function success_callback(p) {
        // p.latitude : latitude value
        // p.longitude : longitude value
        updateButton.contents().last()[0].textContent=' Getting Bus Info';

        coords = p.coords;
        locElmt.innerHTML = Math.round(coords.latitude*10000)/10000 + ", " +
            Math.round(coords.longitude*10000)/10000 +
            "<br/>Location Accuracy is " +
            Math.round(coords.accuracy) + "m";;

        if (coords.accuracy >= 300) {
            if (watch==null) return;
            $('#accuracyWarning').show();
        }else{
            $('#accuracyWarning').hide();
            if(watch!=null){
                navigator.geolocation.clearWatch(watch);
                watch = null;
            }
        }

        userCoords = coords;
        placeUserMarker();

        var update_moment = new moment();

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

            nearestElmt.innerHTML = data.stop.name + ", ~" +
                Math.round(data.stop.distance) + "m away";

            if (Modernizr.localstorage) {
                localStorage.setItem("busStop", nearestElmt.innerHTML);
            }

            stopCoords = data.stop.location;
            placeStopMarker();

            if (data.next_bus != null){
                nextBus = moment(data.next_bus.time);
                if (Modernizr.localstorage) {
                    localStorage.setItem("nextBus", nextBus);
                }
                updateTimers();
                $('.routeNumber').text(data.next_bus.route_number);
            }else{
                busElmt.innerHTML = "Sorry, that data is not avaliable at the moment :(";
            }

            updateButton.prop('disabled', false);
            updateButton.find('.fa-compass').removeClass('fa-spin');
            updateButton.contents().last()[0].textContent=' Update Bus Info';
          })
          .fail(function( jqxhr, textStatus, error ) {
            updateButton.prop('disabled', false);
            updateButton.find('.fa-compass').removeClass('fa-spin');
            updateButton.contents().last()[0].textContent=' Update Bus Info';
            var err = textStatus + ", " + error;
            $('#errorMessage').text(err);
            $('#updateError').show();
          });
    }

    function error_callback(p){
        // p.message : error message
        locElmt.innerHTML = "Damn, can't get your location. Sorry :(";
        updateButton.prop('disabled', false);
        updateButton.find('.fa-compass').removeClass('fa-spin');
        updateButton.contents().last()[0].textContent=' Update Bus Info';
    }

    function placeUserMarker() {
        if (map) {
            var coords = userCoords;

            if (userMarker) { userMarker.setMap(null) }

            var googUserLatLon = new google.maps.LatLng(coords.latitude, coords.longitude);

            userMarker = new google.maps.Marker({
                position: googUserLatLon,
                icon: {
                    url: '/static/user-marker.png',
                    anchor: new google.maps.Point(8, 8),
                    scaledSize: new google.maps.Size(16, 16),
                    size: new google.maps.Size(32, 32)
                }
            });

            userMarker.setMap(map);

            if (accuracyCircle) { accuracyCircle.setMap(null) }

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
        }
    }

    function placeStopMarker() {
        if (map) {

            var coords = stopCoords;

            var googBusLatLon = new google.maps.LatLng(coords.lat, coords.lon);
            var googUserLatLon = new google.maps.LatLng(userCoords.latitude, userCoords.longitude);

            if (busMarker) {busMarker.setMap(null)}

            busMarker = new google.maps.Marker({
                position: googBusLatLon,
                icon: {
                    url: '/static/bus-marker.png',
                    anchor: new google.maps.Point(16, 32),
                    scaledSize: new google.maps.Size(32, 32),
                    size: new google.maps.Size(64, 64)
                }
            });

            busMarker.setMap(map);

            var bounds = new google.maps.LatLngBounds(googBusLatLon, googUserLatLon);
            map.fitBounds(bounds);
        }
    }

    function updateTimers() {
        console.log("Update timers");
        if (lastUpdate) {
            $('#lastUpdate').text(lastUpdate.fromNow());
        }

        if (nextBus) {
            if (nextBus.isAfter()) {
                $('#bus').text(nextBus.fromNow());
                if (moment().add('m', 5).isAfter(nextBus)) {
                    // If bus is in 5 mins turn text red
                    $('#bus').addClass('text-danger');
                } else {
                    $('#bus').removeClass('text-danger');
                }
            } else {
                $('#bus').text('...');
                // $('#updateButton').click();
            }
        }

        clearTimeout(updateTimeout);
        updateTimeout = window.setTimeout(updateTimers, updateInterval);
    }

    function initializeMap() {
        var mapOptions = {
          center: new google.maps.LatLng(52.287373, -1.548609),
          zoom: 12,
          streetViewControl: false
        };
        map = new google.maps.Map(document.getElementById("map-canvas"),
            mapOptions);

        if (userCoords) {
            placeUserMarker();
        }
        if (stopCoords) {
            placeStopMarker();
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
</script>

</body>
</html>
<html>
