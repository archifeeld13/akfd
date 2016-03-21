//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/


// 이 파일은 posts를 뿌려주는 페이지에 관한 코드다

function postsColumnResize(){
	var pWidth = $('.posts-item').width()
	var rWidth = $('#right_fixed_menu').width()
	var except_RFM = $(window).width() - (rWidth + 25) // 25 : RFM의 오른쪽 마진
	if ($(window).width() > 700){
		$('#contents-container').css('width', except_RFM - (except_RFM % (pWidth + 10)) ) // 각 포스트 아이템 마진 사방으로 5px임
											.css('margin-left', (except_RFM - $('#contents-container').width())/2)
	}
}

// 초기 너비 설정
$(function(){
	postsColumnResize();

	// 처음엔 숨겨놓기
	$('#archive_hover').hide();

	
	// index
	// index
	// 조회 기능
	$('.posts-item-img, .posts-item-text, .fav-posts').click(function(){
		// feeldup 버튼 눌렀을 때의 액션 중 option 띄우는거 제외하고 
		isModalBgShowed = true;
		isPostItemClicked = true;

		// 흐린 배경 표시
		$('#modal_bg')
			.css('height', $(document).height())
			.css('width', $(document).width())
			.fadeIn()/*show()*/

		// application.js 에 정의됨
		showModalBoard();
		// ajax에 의해 이 보드가 채워진다

	})
	
	// my_feeld
	// my_feeld
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

	$("#project_list").hover(
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

})

//# window resize
//# window resize
$( window ).resize(function() {
	postsColumnResize();
});
//# window resize end


