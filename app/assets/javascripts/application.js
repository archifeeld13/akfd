// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .
//

/*
if ($(window).width() < 1000){
	alert('아키필드는 현재 PC환경에 최적화 되어있습니다.\n 모바일 환경을 위한 서비스는 추후 개발 예정입니다.\n 감사합니다^^');
}
*/

// change width and height of modal board
// 필드업을 눌러서, 옵션을 선택했을 때 나오는 보드의 크기를 조정한다.
function changeWidthHeightModalBoard(){
	// 스크린이 한없이 작아질 때, 필드업 보드가 납작해지니까.. 50%이상으로 해주자.
	$('#modal_board').css('width','700px').css('left', ($(window).width() -  $('#modal_board').width())/2)
	//$('#modal_board').css('width','700px').css('right', ($(window).width() -  $('#modal_board').width())/2)

	// 필드업 보드의 높이를 조정
	$('#modal_board')
		.css('position', 'fixed')
		.css('height', 550)
		.css('top', ($(window).height() - 550)/2 )
		//.css('height', $(window).height() * 0.95)
		//.css('top', $(window).height() * 0.025 )

}

// modal board를 보여준다.
function showModalBoard(){
	// modal 보드를 띄운다 
	$('#modal_board').fadeIn()
	

	// modal 보드의 사이즈를 조절한다 (resize시 재 호출)
	// 참고: 보드가 뜨지 않은 상태에서 호출하면 넓이가 작은 상태에서
	// 구해지므로 반드시 fadeIn 이후에 나와야한다.
	changeWidthHeightModalBoard();
}

// modal board를 숨긴다. background 클릭시 호출한다
function hideModalBoard(){
	$('#modal_bg').fadeOut()/*hide()*/
	$('#option_container').fadeOut()
	$('#modal_board').html("").fadeOut()
}

// feeldup 눌렀을 때 나오는 배경 및 필드업 보드  숨겨놓기
// 사실 hideModalBoard와 비슷하다
function hideModalBG(){
	$('#modal_bg').hide()
	$('#option_container').hide()
	$('#modal_board').hide()
}


$(function(){
	// 네브바 서치 인풋태그 배경 토글
	$('#nav_search_input').bind('focus', function(){
		$(this).css('background-color', 'white')
	}).bind('blur', function(){
		$(this).css('background-color', 'rgba(104,104,104,0.3)')
	})

	//	feeldup Background를일단 숨겨놓음 
	hideModalBG();

	// icon hover
	prev = ""
	$( "#navbar a img, #feeldup img" ).hover(
		function() {
			prev = $(this).attr('src')
			prev_split = prev.split(".")
			$( this ).attr('src',  prev_split[0] + "rev" + ".png")
		}, function() {
			$( this ).attr('src', prev)
		}
	);
	
	
	// isClickedFeeldup 변수는 화면 사이즈 조정시 요소의 사이즈를 다시 구하기 위해서
	// window resize이벤트가 발생할 때마다 feeldup버튼을 다시 클릭을 해줌으로써
	// 요소의 사이즈를 재정비 하려고 했지만, 버튼을 클릭하지 않은 상태에서도 resize이벤트에 걸려서
	// 버튼을 누르지 않았음에도 이벤트가 발생해 이 문제를 해결하고자 추가했다.
	isClickedFeeldup = false;

	// #feeldup click
	// #feeldup click
	$('#feeldup').click(function(){
		isClickedFeeldup = true;

		// 흐린 배경 표시 -> 이 액션은 posts.js에서도 post item 클릭시 취한다
		$('#modal_bg')
			.css('height', $(document).height())
			.css('width', $(document).width())
			.fadeIn()/*show()*/

		// fix시키면 된다. (fix하지 않으면 $(window).scroll이벤트에 위치 설정을 반복해야한다)
		// + 반드시 #modal_bg가 show되고 나서 와야한다.
		$('#option_container')
			.css('position', 'fixed')
			.css('top', $(window).height()/2 - 75)
			.css('margin-left', ($(window).width() - $('#option_container').width())/2 )
			.fadeIn()


	})
	// #feeldup click end


	// feeldup option 클릭 
	// feeldup option 클릭 
	$('.option_item').click(function(){
		// 버그 때문에 추가한 조건문
		// 배경 눌러서 엎어지는 찰나에 옵션 누르는게 가능한  버그
		if (isClickedFeeldup)
			showModalBoard();
	})
	// feeldup option 클릭 end
	

	
	// #modal_bg click
	// #modal_bg click
	$('#modal_bg').click(function(){
		isClickedFeeldup = false

		hideModalBoard();
	})
	// #modal_bg click end


	// window resize
	// window resize
	$( window ).resize(function() {
		// feeldup 클릭 후 리사이즈 할 때 유지하기 위해서
		if (isClickedFeeldup){
			$('#feeldup').click()
		}

		changeWidthHeightModalBoard();
	});
	// window resize end

})
