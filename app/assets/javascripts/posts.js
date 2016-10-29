//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/


// 브라우저 크기 조정시 불리는 함수
function postsColumnResize(){
	//var pWidth = $('.posts-item').width() // 없을 땐 너비를 못찾아서절대값 넣음 
	var pWidth = 215;  
	var pMargin = 5 * 2;
	if ($(window).width() > 400 ){
		$('#posts-container')
			.css('margin-left', ($('#posts-container').width() % (pWidth + pMargin))/2) 

		$("#contents-controllbar")
			.css('width', $('#contents-container').width())// contents container와 너비가 같게 해준다 
	}
}


// @outdated 
// @outdated 
// @outdated 
// my_feeld의 메뉴들에 대한 이벤트를 정의한다
// my_feeld의 메뉴들에 대한 이벤트를 정의한다
/*
function my_feeld_menu_event(){
	// 필드 아카이브에 hover했을 때
	$("#archive").hover(
		function() {
			$(this).hide()
			$('#archive_hover').show();
			// 이 둘의 배경이 제대로 설정되지 않는 버그가 있어서 직접 설정함
			$('#archive_mine').css('background', '#EAEAEA');
			$('#archive_share').css('background', '#EAEAEA');	
		},
		function(){
			$(this).css('background', '#CFCFCF');
		}
	);

	$("#project_management").hover(
		function() {
			$(this).css('background', 'white');
		},
		function(){
			$(this).css('background', '#CFCFCF');
		}
	);
	
	var hoverCheck = [false, false];
	$('#archive_mine').hover(
		function(){
			hoverCheck[0] = true;
			$(this).css('background', 'white');	
		},
		function(){
			// 0.000000001초 사이에 #archive가 보이는 버그를 해결하기위해!
			setTimeout(function(){
				hoverCheck[0] = false;
				if ( !hoverCheck[0] && !hoverCheck[1]){
					$('#archive_hover').hide();
					$('#archive').show();
				}
			}, 10);
			$(this).css('background', '#EAEAEA');	
			if ( !hoverCheck[0] && !hoverCheck[1]){
				$('#archive_hover').hide();
				$('#archive').show();
			}
		}
	);
	$('#archive_share').hover(
		function(){
			hoverCheck[1] = true;
			$(this).css('background', 'white');	
		},
		function(){
			setTimeout(function(){
				hoverCheck[1] = false;
				if ( !hoverCheck[0] && !hoverCheck[1]){
					$('#archive_hover').hide();
					$('#archive').show();
				}
			}, 10);
			$(this).css('background', '#EAEAEA');	
			
		}
	);
}
*/
// @outdated 
// @outdated 
// @outdated 


$(function(){
	postsColumnResize();

	// 처음엔 숨겨 놔야만 함
	// $('#archive_hover').hide();
	
	// index
	// index
	// 조회 기능
	// show_post_item_event();
	
	// my_feeld
	// my_feeld
	// 메뉴 이벤트
	// my_feeld_menu_event();
})

//# window resize
//# window resize
$( window ).resize(function() {
	postsColumnResize();
});
//# window resize end


