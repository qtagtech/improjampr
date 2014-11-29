<html>

<head>
	<meta name='layout' content='register'/>
	<title><g:message code='spring.security.ui.register.title'/></title>
	<style>
	/* Start by setting display:none to make this hidden.
Then we position it in relation to the viewport window
with position:fixed. Width, height, top and left speak
speak for themselves. Background we set to 80% white with
our animation centered, and no-repeating */
	.modal {
		display:    none;
		position:   fixed;
		z-index:    1000;
		top:        0;
		left:       0;
		height:     100%;
		width:      100%;
		background: rgba( 255, 255, 255, .8 )
		url('http://i.stack.imgur.com/FhHRx.gif')
		50% 50%
		no-repeat;
	}

	/* When the body has the loading class, we turn
       the scrollbar off with overflow:hidden */
	body.loading {
		overflow: hidden;
	}

	/* Anytime the body has the loading class, our
       modal element will be visible */
	body.loading .modal {
		display: block;
	}
	</style>
	<script>
		$(function() {
			$( "#accordion" ).accordion({
				event: "click hoverintent"
			});
		});

		/*
		 * hoverIntent | Copyright 2011 Brian Cherne
		 * http://cherne.net/brian/resources/jquery.hoverIntent.html
		 * modified by the jQuery UI team
		 */
		$.event.special.hoverintent = {
			setup: function() {
				$( this ).bind( "mouseover", jQuery.event.special.hoverintent.handler );
			},
			teardown: function() {
				$( this ).unbind( "mouseover", jQuery.event.special.hoverintent.handler );
			},
			handler: function( event ) {
				var currentX, currentY, timeout,
						args = arguments,
						target = $( event.target ),
						previousX = event.pageX,
						previousY = event.pageY;

				function track( event ) {
					currentX = event.pageX;
					currentY = event.pageY;
				};

				function clear() {
					target
							.unbind( "mousemove", track )
							.unbind( "mouseout", clear );
					clearTimeout( timeout );
				}

				function handler() {
					var prop,
							orig = event;

					if ( ( Math.abs( previousX - currentX ) +
							Math.abs( previousY - currentY ) ) < 7 ) {
						clear();

						event = $.Event( "hoverintent" );
						for ( prop in orig ) {
							if ( !( prop in event ) ) {
								event[ prop ] = orig[ prop ];
							}
						}
						// Prevent accessing the original event since the new event
						// is fired asynchronously and the old event is no longer
						// usable (#6028)
						delete event.originalEvent;

						target.trigger( event );
					} else {
						previousX = currentX;
						previousY = currentY;
						timeout = setTimeout( handler, 100 );
					}
				}

				timeout = setTimeout( handler, 100 );
				target.bind({
					mousemove: track,
					mouseout: clear
				});
			}
		};
	</script>
</head>

<body>
<div class="modal"><!-- Place at bottom of page --></div>

<p/>

<s2ui:form width='900' height='500' elementId='loginFormContainer'
           titleCode='spring.security.ui.register.description' center='true'>

<g:form action='register' name='registerForm'>

	<g:if test='${emailSent}'>
	<br/>
	<g:message code='spring.security.ui.register.sent'/><br/>
		<br/><br/>
		<a id="createuser" href="${createLink(controller: 'register',action: 'index')}">CREAR OTRO USUARIO</a>
		<br/><br/>
		<button type="button" id="gobackpanel">Volver Al Panel</button>
	</g:if>
	<g:else>

	<br/>
		<div id="accordion">
			<h3>DATOS DE USUARIO</h3>
			<div>
				<table>
					<tbody>
					<g:if test='${errors}'>
						<br/>
						<h3>${errors}</h3>
					</g:if>
					<s2ui:textFieldRow name='name' labelCode='user.name.label' bean="${command}"
									   size='40' labelCodeDefault='Nombre' value="${command.name}"/>

					<s2ui:textFieldRow name='email' bean="${command}" value="${command.email}"
									   size='40' labelCode='user.email.label' labelCodeDefault='E-mail'/>

					<s2ui:textFieldRow name='country' bean="${command}" value="${command.country}"
									   size='40' labelCode='user.country.label' labelCodeDefault='País'/>

					<s2ui:textFieldRow name='city' bean="${command}" value="${command.city}"
									   size='40' labelCode='user.city.label' labelCodeDefault='Ciudad'/>

					<s2ui:textFieldRow name='telephone' bean="${command}" value="${command.telephone}"
									   size='40' labelCode='user.telephone.label' labelCodeDefault='Celular'/>



					%{--<s2ui:passwordFieldRow name='password' labelCode='user.password.label' bean="${command}"
                                         size='40' labelCodeDefault='Clave' value="${command.password}"/>

                    <s2ui:passwordFieldRow name='password2' labelCode='user.password2.label' bean="${command}"
                                         size='40' labelCodeDefault='Cave (confirmar)' value="${command.password2}"/>--}%

					</tbody>
				</table>


			</div>
			<h3>DATOS DE VIDEO</h3>
			<div>

					<table>
						<tbody>
						<g:if test='${errors}'>
							<br/>
							<h3>${errors}</h3>
						</g:if>
				<s2ui:textFieldRow name='videourl' bean="${command}" value="${command.videourl}"
								   size='40' labelCode='user.videourl.label' labelCodeDefault='URL Video'/>

				<s2ui:textFieldRow name='videotitle' bean="${command}" value="${command.videotitle}"
								   size='40' labelCode='user.videotitle.label' labelCodeDefault='Título Video'/>

				<s2ui:textFieldRow name='videoyoutuber' bean="${command}" value="${command.videoyoutuber}"
								   size='40' labelCode='user.videoyoutuber.label' labelCodeDefault='Autor Video'/>
						</tbody>
					</table>
			</div>


		</div>

		<s2ui:submitButton elementId='create' form='registerForm' messageCode='spring.security.ui.register.submit'/>

		<br/><br/>
		<button type="button" id="gobackpanel">Volver Al Panel</button>
	</g:else>

</g:form>

</s2ui:form>
<div id="mydiv" style=" width: 100%; text-align: center; margin-top: 2em;"><iframe id="frame" src="" width="560" height="315">
</iframe></div>

<script>
	$body = $("body");
$(document).ready(function() {
	//$body.addClass("loading");
	//$body.removeClass("loading");
	$('#username').focus();
	$('#gobackpanel').button();
	$('#createuser').button();

	$("body").on("click","#gobackpanel",function(e){
		e.preventDefault();
		if (!window.location.origin)
			window.location.origin = window.location.protocol+"//"+window.location.host;
		window.location = window.location.origin + "${createLink(controller: 'admin',action: 'index')}";
	});
});
var url = "";
$(function(){
	$("[name='videourl']").focusout(function () {
		var valor = $(this).val();
		if(valor !== url && valor !== "" && valor !== undefined){
			$body.addClass("loading");
			url = valor;
			var iden = valor.split("=");
			if(iden.length == 2){
				loadInfo(iden[1]);
			}
		}


	});
});

//youtube video info loading
var loadInfo = function (videoId) {
	var gdata = document.createElement("script");
	gdata.src = "http://gdata.youtube.com/feeds/api/videos/" + videoId + "?v=2&alt=jsonc&callback=storeInfo";
	var body = document.getElementsByTagName("body")[0];
	body.appendChild(gdata);
};

var storeInfo = function (info) {
	$body.removeClass("loading");

	//console.log(info.data);
	$("[name='videotitle']").val(info.data.title);
	$("[name='videoyoutuber']").val(info.data.uploader);
	$("#frame").attr("src", "//youtube.com/embed/"+ info.data.id +"?rel=0&autoplay=1");
};
</script>

</body>
</html>
