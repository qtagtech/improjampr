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
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,700italic,400,300,700' rel='stylesheet' type='text/css'>
</head>
<body>
<header class="header_admin">
    <section>
        <figure id="logo">
            <asset:image src="nickyjam.png"/>
        </figure>
        <figure id="slogan">
            <asset:image src="improjam.png"/>
            <figure>

    </section>
</header>
<section>
    <g:if test="${videos?.size() != 8}">
        <div class="home_description">
            <h1>Aún no se han registrado todos los videos participantes. Deben ser 8 para realizar las batallas de segunda ronda.</h1>
            <button type="button" id="registerVideos">Haz clic Aquí Para Registrar Videos</button>
        </div>
    </g:if>
    <g:else>
        <div id="tab-container" class="tab-container">
            <g:remoteLink class="logout" controller="logout" method="post" asynchronous="false" onSuccess="location.reload()">Logout</g:remoteLink>
            <ul class="tabs">
                <li class="tab"><a href="#ronda-1">1° Ronda</a></li>
                <li class="tab" id="the-second-round"><a href="#ronda-2">2° Ronda</a></li>
                <li class="tab"><a href="#ronda-3">3° Ronda</a></li>
                %{--<li class="tab"><a href="#ronda-3">3° Ronda</a></li>--}%
                <li class="tab"><a href="#final">Final</a></li>
            </ul>
            <div id="ronda-1" class="cont-tab">
            </div>
            <div id="ronda-2" class="cont-tab">
                <div class="timedate">
                    <span><strong>2° Ronda</strong></span>
                    <g:if test="${ronda2 == false}">
                    <input type="text" id="ronda2start" placeholder="Fecha de inicio de la ronda">
                    <input type="text" id="ronda2end" placeholder="Fecha de cierre de la ronda">
                    </g:if>
                    <g:else>
                        <g:formatDate date="${fechas2?.startDate}" type="date" style="LONG" locale="es_CO"/> - <g:formatDate date="${fechas2?.endDate}" type="date" style="LONG" locale="es_CO"/>
                    </g:else>
                </div>
                <% def j = 0 %>
                <g:while test="${j < 8}">
                    <article class="article_admin" id="round1">
                        <div class="battle">
                            <input type="text" placeholder="URL del video" value="${videos[j]?.video?.url}" disabled>
                            <input type="text" class="name_author" placeholder="Nombre del Autor" value="${videos[j]?.user?.name}" disabled>
                            <input type="text" class="name_song" placeholder="Nombre de la canción" value="${videos[j]?.video?.title}" disabled>
                            <input type="hidden" name="ronda1_video_${j}" value="${videos[j]?.video?._id}"/>
                        </div>
                        <span class="versus_admin">VS</span>
                        <div class="battle">
                            <input type="text" placeholder="URL del video" value="${videos[j + 1]?.video?.url}" disabled>
                            <input type="text" class="name_author" placeholder="Nombre del Autor" value="${videos[j + 1]?.user?.name}" disabled>
                            <input type="text" class="name_song" placeholder="Nombre de la canción" value="${videos[j + 1]?.video?.title}" disabled>
                            <input type="hidden" name="ronda1_video_${j+1}" value="${videos[j+1]?.video?._id}"/>
                        </div>
                    </article>
                    <% j = j + 2 %>
                </g:while>
                <article class="article_admin">
                    <button type="button" id="generateRound2" <g:if test="${!!ronda2 != false}" >disabled="disabled" </g:if>>Iniciar Ronda</button>
                </article>
                <br/>
            </div>

            <div id="ronda-3" class="cont-tab">
                <div class="timedate">
                    <span><strong>3° Ronda</strong></span>
                    <input type="text" id="ronda3" placeholder="Fecha del cierre de la ronda">
                </div>
                <article class="article_admin">
                    <div class="battle">
                        <input type="text" placeholder="URL del video">
                        <input type="text" class="name_author" placeholder="Nombre del Autor">
                        <input type="text" class="name_song" placeholder="Nombre de la canción">
                    </div>
                    <span class="versus_admin">VS</span>
                    <div class="battle">
                        <input type="text" placeholder="URL del video">
                        <input type="text" class="name_author" placeholder="Nombre del Autor">
                        <input type="text" class="name_song" placeholder="Nombre de la canción">
                    </div>
                </article>
                <article class="article_admin">
                    <div class="battle">
                        <input type="text" placeholder="URL del video">
                        <input type="text" class="name_author" placeholder="Nombre del Autor">
                        <input type="text" class="name_song" placeholder="Nombre de la canción">
                    </div>
                    <span class="versus_admin">VS</span>
                    <div class="battle">
                        <input type="text" placeholder="URL del video">
                        <input type="text" class="name_author" placeholder="Nombre del Autor">
                        <input type="text" class="name_song" placeholder="Nombre de la canción">
                    </div>
                </article>
            </div>
            <div id="final" class="cont-tab">
                <div class="timedate">
                    <span><strong>Final</strong></span>
                    <input type="text" id="ronda4" placeholder="Fecha del cierre de la ronda">
                </div>
                <article class="article_admin">
                    <div class="battle">
                        <input type="text" placeholder="URL del video">
                        <input type="text" class="name_author" placeholder="Nombre del Autor">
                        <input type="text" class="name_song" placeholder="Nombre de la canción">
                    </div>
                    <span class="versus_admin">VS</span>
                    <div class="battle">
                        <input type="text" placeholder="URL del video">
                        <input type="text" class="name_author" placeholder="Nombre del Autor">
                        <input type="text" class="name_song" placeholder="Nombre de la canción">
                    </div>
                </article>
            </div>
        </div>
    </g:else>

</section>

<asset:javascript src="application.js"/>
<asset:javascript src="easytabs/jquery.easytabs.js"/>

<script src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-52db4aff4182b691"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<script>
    $body = $("body");
    $(document).ready(function(){

        $("body").on("click","#registerVideos",function(e){
            e.preventDefault();
            if (!window.location.origin)
                window.location.origin = window.location.protocol+"//"+window.location.host;
            window.location = window.location.origin + "${createLink(controller: 'register',action: 'index')}";
        });
        $("body").on("click","#generateRound2",function(e){
            var date1 = $("#ronda2start").val();
            var date2 = $("#ronda2end").val();
            if(!!date1 == false || !!date2 == false){
                var notification = new NotificationFx({
                    message : '<span class="icon icon-megaphone"></span><p>ERROR: No especificaste alguna de las fechas de incio o de final de la ronda.</p>',
                    layout : 'bar',
                    effect : 'slidetop',
                    type : 'error' // notice, warning or error
                });
                notification.show();
                return
            }
            $body.addClass("loading");
            e.preventDefault();
            var data = {};
            data["startDate"] = date1+' 00:00:00';
            data["endDate"] = date2+' 23:59:59';
            $("[name^='ronda1_video_']").each(function(){
                data[$(this).attr("name")] = $(this).val();
            });
            saveFixtures(data).done(function(response){
                $body.removeClass("loading");
                if(response.status == 1){
                    $("#generateRound2").attr("disabled","disabled");
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
        });
    });



    function saveFixtures(data) {
        return $.post('${createLink(controller: "admin",action: "generateFixtures")}', data);
    };

    function ajaxError(data){
        console.log(data);
    };
</script>
<div class="modal"><!-- Place at bottom of page --></div>
</body>
</html>
