<!DOCTYPE HTML>
<html>
<head>
    <title>WTHTU1</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
    <script src="/static/geoPosition.js" type="text/javascript" charset="utf-8"></script>

    <link href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet">
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
    <style>
    body {
        padding: 5px;
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
    #lastUpdate {
        color: #b9b9b9;
    }
    </style>
</head>
<body>

<h1>Where the hell's the U1?</h1>

<p>Your location is: <span id="loc">...</span></p>

<p>Your nearest U1 bus stop is: <span id="nearest">...</span></p>

<p>and the next bus is: <span id="bus">...</span></p>

<p>
    <button type="button" class="btn btn-default" id="updateButton" disabled>
        <i class="fa fa-compass fa-spin"></i>
        Getting Location
    </button>
    <small id="lastUpdate">Last Update: Never</small>
</p>

<script type="text/javascript">
    var locElmt = document.getElementById("loc");
    var nearestElmt = document.getElementById("nearest");
    var busElmt = document.getElementById("bus");
    var updateElmt = document.getElementById("lastUpdate");
    if(geoPosition.init()){  // Geolocation Initialisation
        geoPosition.getCurrentPosition(success_callback,error_callback,{enableHighAccuracy:true});
    } else {
            // You cannot use Geolocation in this device
        locElmt.innerHTML = "Damn, can't get your location. Sorry :(";
    }

    // p : geolocation object
    function success_callback(p) {
        // p.latitude : latitude value
        // p.longitude : longitude value
        var updateButton = $('#updateButton');
        updateButton.contents().last()[0].textContent=' Getting Bus Stop';

        coords = p.coords;
        locElmt.innerHTML = coords.latitude + ", " + coords.longitude;

        var currentdate = new Date();
        var update_datetime = "Last Update: "
                + currentdate.getHours() + ":"
                + currentdate.getMinutes() + ":"
                + currentdate.getSeconds();

        $.getJSON("/nearest", {
            lat: coords.latitude,
            lon: coords.longitude
        })
          .done(function(data){
            lastUpdate.innerHTML = update_datetime;

            nearestElmt.innerHTML = data.stop.name + ", ~" +
                Math.round(data.stop.distance) + "m away";

            if (data.next_bus != null){
                busElmt.innerHTML = data.next_bus.time;
            }else{
                busElmt.innerHTML = "Sorry, that data is not avaliable at the moment :(";
            }

            updateButton.prop('disabled', false);
            updateButton.find('.fa-compass').removeClass('fa-spin');
            updateButton.contents().last()[0].textContent=' Update Location';
          });
    }

    function error_callback(p){
        // p.message : error message
        locElmt.innerHTML = "Damn, can't get your location. Sorry :(";
    }

    $('#updateButton').click(function(event){
        geoPosition.getCurrentPosition(
                                    success_callback,
                                    error_callback,
                                    {enableHighAccuracy:true}
        );
        this.disabled = true;
        $(this).find('.fa-compass').addClass('fa-spin')
        $(this).contents().last()[0].textContent=' Getting Location';
    });
</script>

</body>
</html>
<html>
