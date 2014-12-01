<!DOCTYPE html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title></title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <asset:stylesheet href="application.css"/>
        <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,700italic,400,300,700' rel='stylesheet' type='text/css'>
        <asset:javascript src="geolocator/geolocator.js"/>
        <script type="text/javascript">
            //The callback function executed when the location is fetched successfully.
            function onGeoSuccess(location) {
                console.log(location);
                //puede venir de dos partes, de ip o de html5, se revisa el objeto ipGeoSource ¿, si es nulo es de html5, si no, se toma data, ahi esta la ip, y los datos de ubicación quese pueden comparar
                //con los obtenidos por html5 y asegurar así la ubicaciín de la persona
            }

            function onIpSuccess(location) {
                console.log(location);
                //puede venir de dos partes, de ip o de html5, se revisa el objeto ipGeoSource ¿, si es nulo es de html5, si no, se toma data, ahi esta la ip, y los datos de ubicación quese pueden comparar
                //con los obtenidos por html5 y asegurar así la ubicaciín de la persona
            }
            //The callback function executed when the location could not be fetched.
            function onGeoError(message) {
                console.log(message);
            }

            window.onload = function() {
                //geolocator.locateByIP(onGeoSuccess, onGeoError, 2, 'map-canvas');
                var html5Options = { enableHighAccuracy: true, timeout: 3000, maximumAge: 0 };
                geolocator.locate(onGeoSuccess, onGeoError, 1, html5Options, 'map-canvas');

            }
        </script>
    </head>
    <body>
        <header>
            <section>
                <div class="rapper-1"></div>
                <div class="rapper-2"></div>
                <figure id="logo">
                    <asset:image src="nickyjam.png"/>
                </figure>
                <figure id="slogan">
                    <asset:image src="improjam.png"/>
                <figure>
                
            </section>
        </header>
        <section>
            <div class="home_description">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer rutrum justo ac commodo volutpat. Vestibulum egestas, erat non iaculis ultricies, odio ipsum pellentesque risus, nec rhoncus purus erat a tortor. Sed a ipsum imperdiet, dignissim odio ut, lacinia ex. Proin a vestibulum ligula, eget bibendum tellus.
                <button type="button" id="login">ENTRAR AHORA</button>
                <sec:ifNotGranted roles="ROLE_USER">
                    <facebookAuth:connect />
                </sec:ifNotGranted>
                <sec:ifAllGranted roles="ROLE_USER">
                    Welcome <sec:username/>! (<g:link uri="/j_spring_security_logout">Logout</g:link>)
                </sec:ifAllGranted>
                <ul id="alert_login">
                    <li class="twitter">
                        <button type="button"><i class="icon-twitter"></i> Tweet to @NickyJam</button>
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer rutrum justo ac commodo volutpat. Vestibulum egestas, erat non iaculis ultricies, odio ipsum pellentesque risus
                    </li>
                    <li class="facebook">
                        <button type="button"><i class="icon-facebook"></i> Me Gusta Nicky Jam</button> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer rutrum justo ac commodo volutpat. Vestibulum egestas, erat non iaculis ultricies, odio ipsum pellentesque risus
                    </li>
                    <li class="instagram">
                        <button type="button"><i class="icon-instagram"></i> Instagram @NickyJam</button> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer rutrum justo ac commodo volutpat. Vestibulum egestas, erat non iaculis ultricies, odio ipsum pellentesque risus</li>
                    <li class="youtube">
                        <button type="button"><i class="icon-youtube"></i> Youtube @NickyJam</button> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer rutrum justo ac commodo volutpat. Vestibulum egestas, erat non iaculis ultricies, odio ipsum pellentesque risus
                    </li>
                </ul>
            </div>
        </section>

         <asset:javascript src="application.js"/>
         <asset:javascript src="fingerprint/fingerprint.js"/>
         <asset:javascript src="detect/detect.min.js"/>
         <asset:javascript src="cookie/jquery.cookie.js"/>
        <script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
        %{--<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>--}%
        %{--<script src="js/plugins.js"></script>
        <script src="js/main.js"></script>
        <script src="js/jquery.easytabs.min.js"></script>
        <script src="js/jquery.colorbox-min.js"></script>--}%
        <script src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-52db4aff4182b691"></script>

    <script>
        $.cookie.raw = true;
        var userFingerprint = new Fingerprint({screen_resolution: true,canvas: true,ie_activex: true});
        var ua = detect.parse(navigator.userAgent);
        var itemLocality='';
        var itemCountry='';
        var addressToCode = function (position) {
            var url = "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + position.coords.latitude + "," + position.coords.longitude + "&sensor=false";
            $.getJSON(url, function (json) {
                if (json.status == 'OK') {
                    //console.log(json);
                    var arrAddress = json.results[0].address_components;

                    $.each(arrAddress, function (i, address_component) {
                        //console.log('address_component:'+i);

                        if (address_component.types[0] == "route"){
                            //console.log(i+": route:"+address_component.long_name);
                            //itemRoute = address_component.long_name;
                        }

                        if (address_component.types[0] == "locality"){
                            //console.log("town:"+address_component.long_name);
                            itemLocality = address_component.long_name;
                        }

                        if (address_component.types[0] == "country"){
                            //console.log("country:"+address_component.long_name);
                            itemCountry = address_component.long_name;
                        }

                        if (address_component.types[0] == "postal_code_prefix"){
                            //console.log("pc:"+address_component.long_name);
                            //itemPc = address_component.long_name;
                        }

                        if (address_component.types[0] == "street_number"){
                            // console.log("street_number:"+address_component.long_name);
                            //itemSnumber = address_component.long_name;
                        }

                        if(i == (arrAddress.length - 1)) {
                            afterPosition(true);
                        }
                    });
                    //json.results[0].formatted_address;
                } else {
                    afterPosition(false);
                    //alert("Geocode was not successful for the following reason: " + json.status);
                }
            });
        };

        function afterPosition(result){
            console.log(itemCountry);
            console.log(itemLocality);
            console.log(userFingerprint.get());
            console.log(ua.device.family);
        };

        $(document).ready(function(){
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(addressToCode);
            }
            geolocator.locateByIP(onIpSuccess, onGeoError, 1);
            $.cookie('hasdonethevoting', 'false', { expires: 0.1, path: '/' });
        });
    </script>
    </body>
</html>
