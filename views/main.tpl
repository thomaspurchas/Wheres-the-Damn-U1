<!DOCTYPE HTML>
<html>
<head>
    <title>Hey There!</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
    <script src="/static/geoPosition.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>

<p>Your location is: <span id="loc">...</span></p>

<p>Your nearest U1 bus stop is: <span id="nearest">...</span></p>

<script type="text/javascript">
    var locElmt = document.getElementById("loc");
    var nearestElmt = document.getElementById("nearest");
    if(geoPosition.init()){  // Geolocation Initialisation
        geoPosition.getCurrentPosition(success_callback,error_callback,{enableHighAccuracy:true});
    } else {
            // You cannot use Geolocation in this device
        locElmt.innerHTML = "Damn, can't get you location. Sorry :(";
    }

    // p : geolocation object
    function success_callback(p){
        // p.latitude : latitude value
        // p.longitude : longitude value
        console.log(p);
        coords = p.coords;
        locElmt.innerHTML = coords.latitude + ", " + coords.longitude;

        $.getJSON("/nearest", {
            lat: coords.latitude,
            lon: coords.longitude
        })
          .done(function(data){
            nearestElmt.innerHTML = data.name;
          });
    }

    function error_callback(p){
        // p.message : error message
        locElmt.innerHTML = "Damn, can't get you location. Sorry :(";
    }
</script>

</body>
</html>
<html>
