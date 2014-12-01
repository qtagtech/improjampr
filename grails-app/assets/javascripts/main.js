$(document).ready(function(){
	setTimeout(function() {
    	$(".rapper-1").addClass("rapper-1-on");
    	$(".rapper-2").addClass("rapper-2-on");
	}, 2000);
	$('#tab-container').easytabs();
	$("#ronda2, #ronda3, #ronda4" ).datepicker();
	$( "#ronda1start" ).datepicker({
		defaultDate: "+1w",
		changeMonth: true,
		numberOfMonths: 1,
		onClose: function( selectedDate ) {
			$( "#ronda1end" ).datepicker( "option", "minDate", selectedDate );
		}
	});
	$( "#ronda1end" ).datepicker({
		defaultDate: "+1w",
		changeMonth: true,
		numberOfMonths: 1,
		onClose: function( selectedDate ) {
			$( "#ronda1start" ).datepicker( "option", "maxDate", selectedDate );
		}
	});
	$("body").on("click",".play_competitor_on",function(e){
		var url = "//www.youtube.com/embed/"+$(this).closest(".play_competitor").data("video-id");
		var title = $(this).closest(".play_competitor").data('video-title');
		var artist = $(this).closest(".play_competitor").data('video-artist');
		$("#videoframe").attr("src",url);
		$("#textoartista").html(artist);
		$("#textocancion").html(title);
	});

});



$('.competitor').hover(function () {
  	$(this).children(".vote_competitor").toggleClass("vote_competitor_on");
  	$(this).children(".play_competitor").toggleClass("play_competitor_on");
	$(".play_competitor_on").colorbox({inline:true, width:"70%"});
});
