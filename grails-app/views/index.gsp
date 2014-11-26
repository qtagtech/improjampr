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
        %{--<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>--}%
        %{--<script src="js/plugins.js"></script>
        <script src="js/main.js"></script>
        <script src="js/jquery.easytabs.min.js"></script>
        <script src="js/jquery.colorbox-min.js"></script>--}%
        <script src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-52db4aff4182b691"></script>
    </body>
</html>
