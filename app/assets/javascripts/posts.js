//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/


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

	$('.posts-item-img').click(function(){
		// feeldup 버튼 눌렀을 때의 액션 중 option 띄우는거 제외하고 
		isClickedFeeldup = true;

		// 흐린 배경 표시
		$('#feeldup_bg')
			.css('height', $(document).height())
			.css('width', $(document).width())
			.fadeIn()/*show()*/

		// application.js 에 정의됨
		showFeeldupBoard();

	})
})

//# window resize
//# window resize
$( window ).resize(function() {
	postsColumnResize();
});
//# window resize end
//# window resize end


