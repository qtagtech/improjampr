<!DOCTYPE html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title></title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <asset:stylesheet href="application.css"/>
        <asset:stylesheet href="notification.css"/>
        <asset:javascript src="modernizr/modernizr.custom.js"/>
        <asset:stylesheet href="css-ganador.css"/>
        <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,700italic,400,300,700' rel='stylesheet' type='text/css'>
        <asset:javascript src="geolocator/geolocator.js"/>
        <script src="https://apis.google.com/js/platform.js"></script>
        <script type="text/javascript">
        var ip = 0;
            //The callback function executed when the location is fetched successfully.
            function onGeoSuccess(location) {
                console.log(location);
                //puede venir de dos partes, de ip o de html5, se revisa el objeto ipGeoSource ¿, si es nulo es de html5, si no, se toma data, ahi esta la ip, y los datos de ubicación quese pueden comparar
                //con los obtenidos por html5 y asegurar así la ubicaciín de la persona
            }

            function onIpSuccess(location) {
//                console.log("porip");
//                console.log(location);
                ip = location.ipGeoSource.data.geoplugin_request;
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
                //geolocator.locate(onGeoSuccess, onGeoError, 1, html5Options, 'map-canvas');

            }
        </script>
    </head>
    <body>
    <script>
        function facebookInit(){
            checkFacebookLogin(function(response){
                checkFacebook();
            });
        };

        function checkFacebookLogin(f){
            FB.getLoginStatus(function(response) {
                if (response.status === 'connected') {
                    if(typeof f === 'function'){
                        f(response);
                    }
                    //console.log('Logged in.');
                }
                else {

                }
            });
        };
        window.fbAsyncInit = function() {
            FB.init({
                appId      : '1008044385879083',
                xfbml      : true,
                version    : 'v2.1'
            });
            facebookInit();
        };

        (function(d, s, id){
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/es_LA/sdk.js";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));

    </script>
    <script type="text/javascript">
        window.twttr = (function (d, s, id) {
            var t, js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s); js.id = id;
            js.src= "https://platform.twitter.com/widgets.js";
            fjs.parentNode.insertBefore(js, fjs);
            return window.twttr || (t = { _e: [], ready: function (f) { t._e.push(f) } });
        }(document, "script", "twitter-wjs"));
    </script>

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
    <g:if test="${showVideos}">
        <sec:ifNotLoggedIn>
            <section>
                <div class="home_description">
                    Bienvenidos al concurso #IMPROJAM de Nicky Jam este concurso busca fomentar el talento urbano y descubrir nuevas promesas para la improvisación musical.<br />
                    De todas las personas que participaron se eligieron los 16 mejores para hacer un sorteo e iniciar una batalla de VS en dónde el público será quién elige los ganadores en cada ronda de votaciones.

                    %{--<button type="button" id="login">ENTRAR AHORA</button>--}%
                    <h3>Para votar, inicia Sesión con Facebook y podrás ver todos los videos.</h3>
                    <facebookAuth:connect permissions="email,user_likes" />

                </div>
            </section>
        </sec:ifNotLoggedIn>
    <sec:ifAnyGranted roles="ROLE_USER,ROLE_CONTESTANT,ROLE_ADMIN">
    <section>
        <div class="home_description contest">
            Bienvenido <strong>${currentUser?.name}</strong>. Vota por tus videos favoritos. Máximo podrás hacerlo una vez por día. Recuerda que debes ser fan de Nickyjam en Facebook para poder votar.
            <ul id="alert_login">
                <li class="facebook">
                    <div class="fb-like" data-href="https://www.facebook.com/NickyJamPR" data-layout="box_count" data-action="like" data-show-faces="true" data-share="false" data-colorscheme="dark"></div>
                </li>

                <g:if test="${!!youtube?.token == false}">
                    <li class="youtube">
                        <button type="button" id="authYoutube"><i class="icon-youtube"></i>Ir a Youtube</button>
                    </li>
                </g:if>
                <g:else>
                    <g:if test="${youtube?.subscribed == 0}">
                        <li class="youtube">
                            <div class="g-ytsubscribe" data-channelid="UCpb_iJuhFe8V6rQdbNqfAlQ" data-layout="full" data-theme="dark" data-count="undefined"></div>
                        </li>
                    </g:if>
                </g:else>
                <g:if test="${!!twitter?.token == false}">
                    <li class="twitter">
                        <button type="button" id="authTwitter"><i class="icon-twitter"></i>Ir a Twitter</button>
                    </li>
                </g:if>
                <g:else>
                    <g:if test="${twitter?.follows == 0}">
                        <li class="twitter">
                            <a class="twitter-follow-button"  href="https://twitter.com/nickyjampr"  data-lang="es">Seguir a @NickyJamPR</a>
                        </li>
                    </g:if>
                </g:else>

                <g:if test="${!!instagram?.token == false}">
                    <li class="instagram">
                        <button type="button" id="authInstagram"><i class="icon-instagram"></i>Ir a Instagram</button>
                    </li>
                </g:if>
                <g:else>
                    <g:if test="${instagram?.follows == 0}">
                        <li class="instagram">
                            <style>.ig-b- { display: inline-block; }
                            .ig-b- img { visibility: hidden; }
                            .ig-b-:hover { background-position: 0 -60px; } .ig-b-:active { background-position: 0 -120px; }
                            .ig-b-48 { width: 48px; height: 48px; background: url(//badges.instagram.com/static/images/ig-badge-sprite-48.png) no-repeat 0 0; }
                            @media only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min--moz-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 2 / 1), only screen and (min-device-pixel-ratio: 2), only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx) {
                                .ig-b-48 { background-image: url(//badges.instagram.com/static/images/ig-badge-sprite-48@2x.png); background-size: 60px 178px; } }</style>
                            <a href="http://instagram.com/nickyjampr?ref=badge" class="ig-b- ig-b-48"><img src="//badges.instagram.com/static/images/ig-badge-48.png" alt="Instagram" /></a>

                        </li>
                    </g:if>
                </g:else>
            </ul>
        </div>
    </section>

    <g:set var="limittime" value="${java.util.Calendar.getInstance(TimeZone.getTimeZone(grailsApplication.config.app.timezone))}"/>
    <g:set var="actualtime" value="${java.util.Calendar.getInstance(TimeZone.getTimeZone(grailsApplication.config.app.timezone)).getTime()}"/>
    <%
        limittime.set(2015,5,22,0,0,0)
        if (actualtime.compareTo(limittime.getTime())<=0){
    %>
    <div class="timedate">
        <span>Final de la <strong>2° Ronda</strong></span>
        <div class="wrapper" >
            <div class="cell">
                <div id="holder">
                    <div class="digits"></div>
                </div>
            </div>
        </div>
    </div>
    <section>

    <div id="tab-container" class="tab-container">
    <ul class="tabs">
        <li class="tab"><a href="#ronda-1">1° Ronda <span>(TERMINADA)</span></a></li>
        <li class="tab" id="the-second-round"><a href="#ronda-2">2° Ronda <span>(<g:formatDate date="${fechas2?.startDate}" type="date" style="SHORT" locale="es_CO"/>)</span></a></li>
        <li class="tab"><a href="#ronda-3">3° Ronda <span>(PRONTO)</span></a></li>
        <li class="tab"><a href="#final">Final <span>(PRONTO)</span></a></li>
    </ul>
    <div id="ronda-1" class="cont-tab">



    <section>
    <div class="home_description">
    <h2>La Primera Ronda ha terminado, estos son los resultados oficiales:</h2>

    <h2 class="subtitle">Haz Clic en ronda 2 para votar por tus nevos favoritos.</h2>

    <h1 class="title_battle">BATALLA 1</h1>
    <section id="battles_finish">
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> rmsrap - <span>Canción:</span> #IMPROJAM @Rms RAP Venezuela
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>10.859
            </span>
            <h5>¡GANADOR!</h5>

            <div><img src="http://i3.ytimg.com/vi/9tTXz1UQ5EM/0.jpg"></div>
        </article>

        <h2 class="vs">VS</h2>
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> dantedamageklan - <span>Canción:</span> #IMPROJAM Nicky Jam (FreeStyle) - Dante Damageklan
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>7.824
            </span>

            <div class="loser"><img src="http://i3.ytimg.com/vi/k4a1wgU-YrI/0.jpg"></div>
        </article>

        <div class="more_votos">
            <span>
                <h3>SUMA DE VOTOS</h3><i class="icon-heart5"></i>18.683
            </span>
        </div>
    </section>


    <h1 class="title_battle">BATALLA 2</h1>
    <section id="battles_finish">
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> mckilleroficial - <span>Canción:</span> #IMPROJAM NickyJam (FreeStyle) - Mc Killer
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>7.571
            </span>
            <h5>¡GANADOR!</h5>

            <div><img src="http://i3.ytimg.com/vi/9xBOm_mqx8o/0.jpg"></div>
        </article>

        <h2 class="vs">VS</h2>
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> parapetoelcaballo - <span>Canción:</span> El Way Parapeto - #ImproJam (Medellin - Colombia)
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>7.409
            </span>

            <div class="loser"><img src="http://i3.ytimg.com/vi/cDsf6irTXJM/0.jpg"></div>
        </article>

        <div class="more_votos">
            <span>
                <h3>SUMA DE VOTOS</h3><i class="icon-heart5"></i>14.980
            </span>
        </div>
    </section>


    <h1 class="title_battle">BATALLA 3</h1>
    <section id="battles_finish">
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> elprofetard - <span>Canción:</span> El ProfetaRD #IMPROJAM En Busca De Los 10,000 USD
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>2.784
            </span>

            <div class="loser"><img src="http://i3.ytimg.com/vi/Whgk1kFj_Tg/0.jpg"></div>
        </article>

        <h2 class="vs">VS</h2>
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> skoneoficial - <span>Canción:</span> SKONE - #IMPROJAM
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>4.548
            </span>
            <h5>¡GANADOR!</h5>

            <div><img src="http://i3.ytimg.com/vi/3aPI0-u6Gr4/0.jpg"></div>
        </article>

        <div class="more_votos">
            <span>
                <h3>SUMA DE VOTOS</h3><i class="icon-heart5"></i>7.332
            </span>
        </div>
    </section>


    <h1 class="title_battle">BATALLA 4</h1>
    <section id="battles_finish">
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> elputasmc - <span>Canción:</span> SANTUPLEX EL FENIX - ¨EL PUTAS¨- #IMPROJAM Quibdó Chocó Colombia
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>8.602
            </span>

            <div class="loser"><img src="http://i3.ytimg.com/vi/pBUhu-nRWjM/0.jpg"></div>
        </article>

        <h2 class="vs">VS</h2>
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> mcflakooficial - <span>Canción:</span> MC FLAKO - #‎IMPROJAM‬
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>10.619
            </span>
            <h5>¡GANADOR!</h5>

            <div><img src="http://i3.ytimg.com/vi/Zaw7dU53Im4/0.jpg"></div>
        </article>

        <div class="more_votos">
            <span>
                <h3>SUMA DE VOTOS</h3><i class="icon-heart5"></i>19.221
            </span>
        </div>
    </section>


    <h1 class="title_battle">BATALLA 5</h1>
    <section id="battles_finish">
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> Dominic Perez - <span>Canción:</span> #IMPROJAM Dominic Perez | Nicky Jam
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>2.238
            </span>

            <div class="loser"><img src="http://i3.ytimg.com/vi/Z88pM0hlHPM/0.jpg"></div>
        </article>

        <h2 class="vs">VS</h2>
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> Centinela - <span>Canción:</span> Centinela - #IMPROJAM
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>4.680
            </span>
            <h5>¡GANADOR!</h5>

            <div><img src="http://i3.ytimg.com/vi/VPANgHVXoB4/0.jpg"></div>
        </article>

        <div class="more_votos">
            <span>
                <h3>SUMA DE VOTOS</h3><i class="icon-heart5"></i>6.918
            </span>
        </div>
    </section>


    <h1 class="title_battle">BATALLA 6</h1>
    <section id="battles_finish">
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> dulzhelaurahd - <span>Canción:</span> #IMPROJAM NickyJam (FreeStyle) ( ESPAÑA ) - Dulzhe Laura
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>3.160
            </span>

            <div class="loser"><img src="http://i3.ytimg.com/vi/l3PR0IEzaUo/0.jpg"></div>
        </article>

        <h2 class="vs">VS</h2>
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> theodlanier - <span>Canción:</span> #IMPROJAM Odlanier  (CARACAS-VENEZUELA) SESION DE FREESTYLE
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>4.781
            </span>
            <h5>¡GANADOR!</h5>

            <div><img src="http://i3.ytimg.com/vi/oj9QIV4T4Mc/0.jpg"></div>
        </article>

        <div class="more_votos">
            <span>
                <h3>SUMA DE VOTOS</h3><i class="icon-heart5"></i>7.941
            </span>
        </div>
    </section>


    <h1 class="title_battle">BATALLA 7</h1>
    <section id="battles_finish">
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> jrstylooriginal - <span>Canción:</span> #IMPROJAM NICKY JAM  (EUROPA) - JR Stylo Original (COLOMBIA)
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>3.102
            </span>
            <h5>¡GANADOR!</h5>

            <div><img src="http://i3.ytimg.com/vi/ht7F9bjXSEk/0.jpg"></div>
        </article>

        <h2 class="vs">VS</h2>
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> thepromocionmusical - <span>Canción:</span> #IMPROJAM Marchena Del 2 (Caracas - Venezuela) FREESTYLE
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>2.936
            </span>

            <div class="loser"><img src="http://i3.ytimg.com/vi/5aopP_uSMmk/0.jpg"></div>
        </article>

        <div class="more_votos">
            <span>
                <h3>SUMA DE VOTOS</h3><i class="icon-heart5"></i>6.038
            </span>
        </div>
    </section>


    <h1 class="title_battle">BATALLA 8</h1>
    <section id="battles_finish">
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> dario720 - <span>Canción:</span> DARCO MC #IMPROJAM-SANTANDER/COLOMBIA Freestyle 2014
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>2.175
            </span>

            <div class="loser"><img src="http://i3.ytimg.com/vi/OonbPuczXmg/0.jpg"></div>
        </article>

        <h2 class="vs">VS</h2>
        <article class="battle_conclucion">
            <div class="credits_users">
                <span>Artista:</span> jpmsoy - <span>Canción:</span> Jpm Soy - #IMPROJAM
            </div>
            <span class="votos_users">
                Votos Totales:  <i class="icon-heart5"></i>6.717
            </span>
            <h5>¡GANADOR!</h5>

            <div><img src="http://i3.ytimg.com/vi/70rFZQq4YNI/0.jpg"></div>
        </article>

        <div class="more_votos">
            <span>
                <h3>SUMA DE VOTOS</h3><i class="icon-heart5"></i>8.892
            </span>
        </div>
    </section>
    </div>
    </section>

    </div>
    <div id="ronda-2" class="cont-tab">
        <g:if test="${showVideos}">
            <g:each in="${videos}" var="fixture" status="j">
                <article>
                    <div class="competitor">
                        <span data-video-id="${fixture?.video1?.video?._id}" data-fixture-id="${fixture?.fixtureid}" class="vote_competitor">
                            <i class="icon-heart5"></i><g:formatNumber number="${fixture?.video1.votes}" type="number" locale="es_CO" />
                        </span>
                        <span class="play_competitor video_open" href="#inline_content" data-video-id="${fixture?.video1?.id}" data-video-title="${fixture?.video1?.video?.title}" data-video-artist="${fixture?.video1?.video?.uploader}">
                            <i class="icon-play3"></i> PLAY
                        </span>
                        <img src="http://img.youtube.com/vi/${fixture?.video1?.id}/0.jpg"/>
                        <div class="my_vote icon-heart5">
                            <span id="after_vote_${fixture?.video1?.video?._id}"><g:formatNumber number="${fixture?.video1.votes}" type="number" locale="es_CO" /></span>
                        </div>
                    </div>
                    <span class="versus">VS</span>
                    <div class="competitor">
                        <span data-video-id="${fixture?.video2?.video?._id}" data-fixture-id="${fixture?.fixtureid}" class="vote_competitor">
                            <i class="icon-heart5"></i> <g:formatNumber number="${fixture?.video2.votes}" type="number" locale="es_CO"/>
                        </span>
                        <span class="play_competitor video_open" href="#inline_content" data-video-id="${fixture?.video2?.id}" data-video-title="${fixture?.video2?.video?.title}" data-video-artist="${fixture?.video2?.video?.uploader}">
                            <i class="icon-play3"></i> PLAY
                        </span>
                        <img src="http://img.youtube.com/vi/${fixture?.video2?.id}/0.jpg"/>
                        <div class="my_vote icon-heart5">
                            <span id="after_vote_${fixture?.video2?.video?._id}"><g:formatNumber number="${fixture?.video2.votes}" type="number" locale="es_CO"/></span>
                        </div>
                    </div>
                    <div class="data_battle">
                        <div class="data_battle_1">
                            <span>Artista:</span> ${fixture?.video1.video?.uploader} - <span>Canción:</span> ${fixture?.video1.video?.title}
                        </div>
                        <span id="allvote_${fixture?.fixtureid}" class="vote_all">
                            <i class="icon-heart5"></i><g:formatNumber number="${fixture?.video1.votes + fixture?.video2.votes}" type="number" locale="es_CO" />
                        </span>
                        <div class="data_battle_2">
                            <span>Artista:</span> ${fixture?.video2.video?.uploader} - <span>Canción:</span> ${fixture?.video2.video?.title}
                        </div>
                    </div>
                </article>

            </g:each>
        </g:if>
        <g:else>
            <article>
                <asset:image src="soon.jpg"/>
            </article>
        </g:else>

    </div>

    <div id="ronda-3" class="cont-tab">
    </div>
    <div id="final" class="cont-tab">
    </div>
    </div>

    </section>
    <%
        }else{
    %>
    <section>
        <h1 style="color: white;
        float: left;
        text-align: center;
        border-bottom: 1px solid;
        border-top: 1px solid;
        padding: 25px 0;
        text-transform: uppercase;
        ">La primera fase ha terminado, los ganadores están grabando sus nuevas improvisaciones. Espera muy pronto las nuevas batallas</h1>
    </section>

    <%
        }
    %>
    <div class="timedate">
        <span><h4> Loggeado como [ ${currentUser?.name} ] -- <g:remoteLink class="logout" controller="logout" method="post" asynchronous="false" onSuccess="location.reload()">Logout</g:remoteLink></h4></span>
    </div>
    <footer>

    </footer>
    </sec:ifAnyGranted>
    </g:if>
    <g:else>
        <section>
            <article id="soon_image">
                <asset:image src="soon.jpg"/>
            </article>
        </section>
    </g:else>




        <div style='display:none'>
            <div id='inline_content'>
                <div class="colorbox_top">
                    <div class="addthis_native_toolbox"></div>
                </div>
                <iframe  id="videoframe" width="100%" height="580" src="//www.youtube.com/embed/OxxggwHFj7M" frameborder="0" allowfullscreen></iframe>
                <div class="colorbox_bottom">
                    <span>Artista:</span> <span id="textoartista"></span> - <span>Canción:</span> <span id="textocancion"></span>
                    <span class="vote_competitor" style="display: none">
                        <i class="icon-heart5"></i> 1.235
                    </span>
                </div>
            </div>
        </div>

    <asset:javascript src="application.js"/>
    <asset:javascript src="fingerprint/fingerprint.js"/>
    <asset:javascript src="detect/detect.min.js"/>
    <asset:javascript src="cookie/jquery.cookie.js"/>
    <script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>

    %{--<script src="js/plugins.js"></script>
    <script src="js/main.js"></script>
    <script src="js/jquery.easytabs.min.js"></script>
    <script src="js/jquery.colorbox-min.js"></script>--}%
    <script src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-52db4aff4182b691"></script>
    <script>
        var likesFB = true;
        var likesYT = true;
        var likesTW = true;
        var likesIN = true;

        //revisar youtube en caso que si
        <g:if test="${youtube?.subscribed == 1}">
            likesYT = true;
        </g:if>
        //revisar twitter en caso que si
        <g:if test="${twitter?.follows == 1}">
            likesTW = true;
        </g:if>
        <g:if test="${instagram?.follows == 1}">
            likesIN = true;
        </g:if>
        $.cookie.raw = true;
        $body = $("body");
        var $element
        var userFingerprint = new Fingerprint({screen_resolution: true,canvas: true,ie_activex: true});
        var enddate = '${formatDate(type: "date", locale: "es_CO" , style: "SHORT" ,date: fechas2.endDate)}';
        var sepdate = enddate.split('/');
        $(document).ready(function(){

            geolocator.locateByIP(onIpSuccess, onGeoError, 1);

            $(".digits").countdown({
                image:  '${assetPath(src: 'digits.png')}',
                format: "dd:hh:mm:ss",
                endTime: new Date(new Date('20'+sepdate[2]+'-'+sepdate[1]+'-'+sepdate[0]))
            });

            $('body').on("click",".vote_competitor_on",function () {
                $element = $(this);
                $body.addClass("loading");
                if(likesFB && likesYT && likesTW && likesIN){
                    doVote();
                }else{
                    checkFacebook(function(resulty){
                        if(!resulty){
                            $body.removeClass("loading");
                            var notification = new NotificationFx({
                                message : '<span class="icon icon-megaphone"></span><p>ERROR: Aún no te gusta la Página NickyJamPR en Facebook. <a href="https://www.facebook.com/NickyJamPR" target="_blank">¡Hazlo  y vota!</a></p>',
                                layout : 'bar',
                                effect : 'slidetop',
                                type : 'error' // notice, warning or error
                            });
                            notification.show();
                            return false;
                        }else{
                            $body.removeClass("loading");
                            checkLikes().done(function(response){
                                if((response.youtube == 1)&&(response.twitter == 1)&&(response.instagram == 1)){
                                    doVote();
                                }else{
                                    if(response.youtube == 0){
                                        var notification = new NotificationFx({
                                            message : '<span class="icon icon-megaphone"></span><p>ERROR: Aún no estás suscrito a NickyJamTV en Youtube. <a href="https://www.youtube.com/channel/UCpb_iJuhFe8V6rQdbNqfAlQ" target="_blank">¡Suscríbete y vota!</a></p>',
                                            layout : 'bar',
                                            effect : 'slidetop',
                                            type : 'error' // notice, warning or error
                                        });
                                        notification.show();
                                    }
                                    if(response.twitter == 0){
                                        var notification = new NotificationFx({
                                            message : '<span class="icon icon-megaphone"></span><p>ERROR: Aún no sigues A @NickyJamPR en Twitter. <a href="https://twitter.com/NickyJamPR" target="_blank">¡Síguelo y vota!</a></p>',
                                            layout : 'bar',
                                            effect : 'slidetop',
                                            type : 'error' // notice, warning or error
                                        });
                                        notification.show();
                                    }
                                    if(response.instagram == 0){
                                        var notification = new NotificationFx({
                                            message : '<span class="icon icon-megaphone"></span><p>ERROR: Aún no sigues A @NickyJamPR en Instagram. <a href="http://instagram.com/nickyjampr" target="_blank">¡Síguelo y vota!</a></p>',
                                            layout : 'bar',
                                            effect : 'slidetop',
                                            type : 'error' // notice, warning or error
                                        });
                                        notification.show();
                                    }
                                    return false;
                                }

                            }).fail(ajaxError);
                        }
                    });

                }

            });

            $('body').on('click','#authYoutube',function(e){
                e.preventDefault();
                if (!window.location.origin)
                    window.location.origin = window.location.protocol+"//"+window.location.host;
                window.location = window.location.origin + '${createLink(controller: 'authorize',action: 'redirectyoutube')}';

            });

            $('body').on('click','#authTwitter',function(e){
                e.preventDefault();
                if (!window.location.origin)
                    window.location.origin = window.location.protocol+"//"+window.location.host;
                window.location = window.location.origin + '${createLink(controller: 'authorize',action: 'redirecttwitter')}';

            });

            $('body').on('click','#authInstagram',function(e){
                e.preventDefault();
                if (!window.location.origin)
                    window.location.origin = window.location.protocol+"//"+window.location.host;
                window.location = window.location.origin + '${createLink(controller: 'authorize',action: 'redirectinstagram')}';
            });


        });

        function doVote(){
            if($.cookie('hasdonethevoting_'+$element.data('fixture-id'))){
                $body.removeClass("loading");
                var notification = new NotificationFx({
                    message : '<span class="icon icon-megaphone"></span><p>ERROR: Ya has votado en esta batalla el día de hoy. Inténtalo de nuevo mañana.</p>',
                    layout : 'bar',
                    effect : 'slidetop',
                    type : 'notice' // notice, warning or error
                });
                notification.show();
                return false;
            }
            $element.parent(".competitor").addClass("competitor_vote");
            $element.siblings(".my_vote").addClass("my_vote_on");
            $element.parent(".competitor").siblings(".competitor").addClass("competitor_not_vote");
//            $body.addClass("loading");
            var data = {};
            data["videoid"] = $element.data("video-id");
            data["round"] = 2;
            data["ipaddr"] = ip != 0 ? ip : '0.0.0.0';
            data["fingerprint"] = userFingerprint.get();
            data["reportDate"] = "Fecha de inicio de la ronda";
            saveVote(data).done(function(response){
                $body.removeClass("loading");
                if(response.status == 1){
                    $.cookie('hasdonethevoting_'+response.fixtureid, true, { expires: 1, path: '/' });
                    $("#after_vote_"+response.ownid).html(response.own);
                    $("#after_vote_"+response.contenderid).html(response.contender);
                    $("#allvote_"+response.fixtureid).html('<i class="icon-heart5"></i>'+response.totales);
                    var notification = new NotificationFx({
                        message : '<span class="icon icon-megaphone"></span><p>'+response.message+'</p>',
                        layout : 'bar',
                        effect : 'slidetop',
                        type : 'notice' // notice, warning or error
                    });
                    notification.show();
                }
                else{
                    var notification = new NotificationFx({
                        message : '<span class="icon icon-megaphone"></span><p>'+response.message+'</p>',
                        layout : 'bar',
                        effect : 'slidetop',
                        type : 'error' // notice, warning or error
                    });
                    notification.show();
                }
            }).fail(ajaxError);
        };


        function saveVote(data) {
            return $.post('${createLink(controller: "vote",action: "vote")}', data);
        };

        function checkLikes() {
            return $.get('${createLink(controller: "vote",action: "remoteCheckAll")}', {});
        };

        function ajaxError(data){
            console.log(data);
        };



        function checkFacebook(f){
            FB.api(
                    "/${facebookUser?.uid}/likes/32705316158",
                    function (response) {
                        if (response && !response.error) {
                            if(response.data.length > 0){
                                if(response.data[0].id){
//                                    alert("yes")
                                    likesFB = true;
                                    if(typeof f === "function")
                                        f(true)
                                    $(".facebook").hide();
                                }else{
//                                    alert("no")
                                    $(".facebook").show();
                                    likesFB = true;
                                    if(typeof f === "function")
                                        f(false)
                                }
                            }else{
//                                alert("no")
                                $(".facebook").show();
                                likesFB = true;
                                if(typeof f === "function")
                                    f(false)
                            }

                        }
                    }
            );
        };

    </script>
    <div class="modal"><!-- Place at bottom of page --></div>
    </body>
</html>
