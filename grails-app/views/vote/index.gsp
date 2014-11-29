<!DOCTYPE html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title></title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <asset:stylesheet href="application.css"/>
        <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,700italic,400,300,700' rel='stylesheet' type='text/css'>
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
        <div class="timedate">
            <span>Final de la <strong>1° Ronda</strong></span>
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
                    <li class="tab"><a href="#ronda-1">1° Ronda <span>(<g:formatDate date="${fechas1?.startDate}" type="date" style="SHORT" locale="es_CO"/>)</span></a></li>
                    <li class="tab"><a href="#ronda-2">1° Ronda <span>(01-12-14)</span></a></li>
                    <li class="tab"><a href="#ronda-3">1° Ronda <span>(01-12-14)</span></a></li>
                    <li class="tab"><a href="#final">Final <span>(01-12-14)</span></a></li>
                </ul>
                <div id="ronda-1" class="cont-tab">
                    <article>
                        <div class="competitor">
                            <span class="vote_competitor">
                                <i class="icon-heart5"></i> 1.235
                            </span>
                            <span class="play_competitor video_open" href="#inline_content">
                                <i class="icon-play3"></i> PLAY
                            </span>
                            <asset:image src="dummy-img-1.jpg"/>
                            <div class="my_vote icon-heart5">
                                <span>1.259</span>
                            </div>
                        </div>
                        <span class="versus">VS</span>
                        <div class="competitor">
                            <span class="vote_competitor">
                                <i class="icon-heart5"></i> 1.235
                            </span>
                            <span class="play_competitor video_open" href="#inline_content">
                                <i class="icon-play3"></i> PLAY
                            </span>
                            <img src="http://img.youtube.com/vi/"${}"/maxresdefault.jpg"/>
                            <div class="my_vote icon-heart5">
                                <span>1.259</span>
                            </div>
                        </div>
                        <div class="data_battle">
                            <div class="data_battle_1">
                                <span>Artista:</span> Lorem Ipsum is simply dummy - <span>Canción:</span> Lorem Ipsum is 
                            </div>
                            <span class="vote_all">
                                <i class="icon-heart5"></i> 1.235
                            </span>
                            <div class="data_battle_2">
                                <span>Artista:</span> Lorem Ipsum is simply dummy - <span>Canción:</span> Lorem Ipsum is 
                            </div>
                        </div>
                    </article>
                    <article>
                        <div class="competitor">
                            <span class="vote_competitor">
                                <i class="icon-heart5"></i> 1.235
                            </span>
                            <span class="play_competitor video_open" href="#inline_content">
                                <i class="icon-play3"></i> PLAY
                            </span>
                            <asset:image src="dummy-img-1.jpg"/>
                            <div class="my_vote icon-heart5">
                                <span>1.259</span>
                            </div>
                        </div>
                        <span class="versus">VS</span>
                        <div class="competitor">
                            <span class="vote_competitor">
                                <i class="icon-heart5"></i> 1.235
                            </span>
                            <span class="play_competitor video_open" href="#inline_content">
                                <i class="icon-play3"></i> PLAY
                            </span>
                            <asset:image src="dummy-img-2.jpg"/>
                            <div class="my_vote icon-heart5">
                                <span>1.259</span>
                            </div>
                        </div>
                        <div class="data_battle">
                            <div class="data_battle_1">
                                <span>Artista:</span> Lorem Ipsum is simply dummy - <span>Canción:</span> Lorem Ipsum is 
                            </div>
                            <span class="vote_all">
                                <i class="icon-heart5"></i> 1.235
                            </span>
                            <div class="data_battle_2">
                                <span>Artista:</span> Lorem Ipsum is simply dummy - <span>Canción:</span> Lorem Ipsum is 
                            </div>
                        </div>
                    </article>
                </div>
                <div id="ronda-2" class="cont-tab">
                </div>
                <div id="ronda-3" class="cont-tab">
                </div>
                <div id="final" class="cont-tab">
                </div>
            </div>
        </section>
        <div class="timedate">
            <span>Final de la <strong>1° Ronda</strong></span>
            <h2 class="days">000<small>Días</small></h2>
            <h2 class="hours">000<small>Horas</small></h2>
            <h2 class="minutes">000<small>Minutos</small></h2>
            <h2 class="seconds">000<small>Segundos</small></h2>
        </div>
        <div id="twitterfeed">  
        </div>
        <footer>
        </footer>
        <div style='display:none'>
            <div id='inline_content'>
                <div class="colorbox_top">
                    <div class="addthis_native_toolbox"></div>
                </div>
                <iframe width="100%" height="580" src="//www.youtube.com/embed/OxxggwHFj7M" frameborder="0" allowfullscreen></iframe>
                <div class="colorbox_bottom">
                    <span>Artista:</span> Lorem Ipsum is simply dummy - <span>Canción:</span> Lorem Ipsum is 
                    <span class="vote_competitor">
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
    %{--<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>--}%
    %{--<script src="js/plugins.js"></script>
    <script src="js/main.js"></script>
    <script src="js/jquery.easytabs.min.js"></script>
    <script src="js/jquery.colorbox-min.js"></script>--}%
    <script src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-52db4aff4182b691"></script>
    <script>
        var enddate = '${formatDate(type: "date", locale: "es_CO" , style: "SHORT" ,date: fechas1.endDate)}';
        var sepdate = enddate.split('/');
        $(document).ready(function(){
            $(".digits").countdown({
                image:  '${assetPath(src: 'digits.png')}',
                format: "dd:hh:mm:ss",
                endTime: new Date(new Date('20'+sepdate[2]+'-'+sepdate[1]+'-'+sepdate[0]))
            });
        });
    </script>
    </body>
</html>
