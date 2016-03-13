//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/


// 이 파일은 posts를 뿌려주는 페이지에 관한 코드다

function postsColumnResize(){
	// 컬럼 4개
	if ($(window).width() > 1600){
		$('.posts-item').css('width', '23%').css('height', '400px')
	}
	// 컬럼 4개
	else if ($(window).width() > 1300){
		$('.posts-item').css('width', '23%').css('height', '320px')
	}
	// 컬럼 3개
	else if ($(window).width() > 1000){
		$('.posts-item').css('width', '31.3%').css('height', '320px')
	}
	// 컬럼 1개 스마트폰 980px
	else if ($(window).width() > 480){
		$('.posts-item').css('width', '48%')
	}
}

// 초기 너비 설정
$(function(){
	postsColumnResize();

	// 처음엔 숨겨놓기
	$('#archive_hover').hide();

	// 조회 기능
	$('.posts-item-img').click(function(){
		// feeldup 버튼 눌렀을 때의 액션 중 option 띄우는거 제외하고 
		isClickedFeeldup = true;

		// 흐린 배경 표시
		$('#modal_bg')
			.css('height', $(document).height())
			.css('width', $(document).width())
			.fadeIn()/*show()*/

		// application.js 에 정의됨
		showModalBoard();
		// ajax에 의해 이 보드가 채워진다

	})
	
	// 필드 아카이브에 hover했을 때
	$("#archive").hover(
		function() {
			$(this).hide()
			$('#archive_hover').show();
			// 이 둘의 배경이 제대로 설정되지 않는 버그가 있어서 직접 설정함
			$('#archive_mine').css('background', '#D9E5FF');	
			$('#archive_share').css('background', '#DAD9FF');	
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
			setTimeout(function(){ hoverCheck[0] = false; }, 10);
			$(this).css('background', '#D9E5FF');	
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
			setTimeout(function(){ hoverCheck[1] = false; }, 10);
			$(this).css('background', '#DAD9FF');	
			if ( !hoverCheck[0] && !hoverCheck[1]){
				$('#archive_hover').hide();
				$('#archive').show();
			}
		}
	);

})

//# window resize
//# window resize
$( window ).resize(function() {
	postsColumnResize();
});
//# window resize end


