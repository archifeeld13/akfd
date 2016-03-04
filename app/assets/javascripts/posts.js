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
		$('.posts-item').css('width', '31.3%')
	}
	// 컬럼 2개
	else if ($(window).width() > 480){
		$('.posts-item').css('width', '48%')
	}
}
// 초기 너비 설정
$(function(){
	postsColumnResize();
})

//# window resize
//# window resize
$( window ).resize(function() {
	postsColumnResize();
});
//# window resize end
//# window resize end


