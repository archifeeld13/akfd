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
// 다음 변수를 통해 판단한다
var isPostItemClicked = false


// modal bg를 클릭햇을 때
// 여기서 변경하는 modal 의 height를 auto로 초기화해줘야한다.
// http://stackoverflow.com/questions/20267675/div-height-doesnt-adjust-to-fit-content
// show_modal_bg_board 호출 이후에 불리는 함수이다
// show_modal_bg_board 호출 이후에 불리는 함수이다
function changeWidthHeightModalBoard(){
	// 스크린이 한없이 작아질 때, 필드업 보드가 납작해지니까.. 50%이상으로 해주자.
	$('#modal_board').css('left', ($(window).width() -  $('#modal_board').width())/2)

	// 필드업 보드의 높이를 조정
	if (!isPostItemClicked){
		// 필드업 했다면
		$('#modal_board')
			.css('position', 'fixed')
			.css('height', 550)
			.css('top', $(window).height() * 0.1 )
			//.css('top', ($(window).height() - 550)/2 )
	}
	else {
		$('#modal_board')
			.css('position', 'fixed')
			.css('top', $(window).height() * 0.1 )

		if ($('#modal_board').height() >  ($(window).height() - 100)){
			$('#modal_board').css('height', $(window).height() * 0.8)
			.css('top', $(window).height() * 0.1 )
		}
	}

}					

// modal board를 보여준다.
function showModalBoard(){
	// modal 보드를 띄운다 
	$('#modal_board').fadeIn()
	// 모달창의 높이를 초기상태로 돌려준다 
	// edit 할 땐 따로 호출해줬다. edit.js.erb에서
 	$('#modal_board').css('height', 'auto')

	// modal 보드의 사이즈를 조절한다 (resize시 재 호출)
	// 참고: 보드가 뜨지 않은 상태에서 호출하면 넓이가 작은 상태에서
	// 구해지므로 반드시 fadeIn 이후에 나와야한다.
	//changeWidthHeightModalBoard();
	// 이걸 여기서 하면안되는 이유는, 내용이 다 로드 된다음 판단을 해야 하기 때문!!!
	// post item클릭했을 경우, 내용의 높이와 윈도우를 비교하는 부분이 있기 때문에!
}

// showModalBoard와 showModalBG사이에 불릴 가능성이 있는 함수이다
// ex) feeldup click 후 option click
function showOptionContainer(){
	// fix시키면 된다. (fix하지 않으면 $(window).scroll이벤트에 위치 설정을 반복해야한다)
	// + 반드시 #modal_bg가 show되고 나서 와야한다.
	$('#option_container')
		.css('position', 'fixed')
		.css('top', $(window).height()/2 - 75)
		.css('margin-left', ($(window).width() - $('#option_container').width())/2 )
		.fadeIn()
}

// isModalBgShowed 변수는 화면 사이즈 조정시 요소의 사이즈를 다시 구하기 위해서
// window resize이벤트가 발생할 때마다 feeldup버튼을 다시 클릭을 해줌으로써
// 요소의 사이즈를 재정비 하려고 했지만, 버튼을 클릭하지 않은 상태에서도 resize이벤트에 걸려서
// 버튼을 누르지 않았음에도 이벤트가 발생해 이 문제를 해결하고자 추가했다.
isModalBgShowed = false;
// modal board 의 배경을 보여준다
// showModalBoard와 분리한 이유는 showModalBG와 showModalBoard 사이에 선택적으로
// 옵션을 보여줄 수도 있고 없기도 하기 때문이다
// 필드업을 눌렀을 때에는 모달을 띄우기 전에 옵션을 보여줘야 하지만
// 포스트 아이템을 눌렀을 때에는 옵션을 보여줄 필요가 없다.
function showModalBG(){
	isModalBgShowed = true;

	// 흐린 배경 표시 -> 이 액션은 posts.js에서도 post item 클릭시 취한다
	$('#modal_bg')
		.css('height', $(document).height())
		.css('width', $(document).width())
		.fadeIn()/*show()*/
}

// 동적으로 모달 배경과 모달 창을 보여주는 부분으로
// 여러 곳에서 호출할 수 있다
// 호출 후에 반드시 changeWidthHeightModalBoard 함수를 호출해줌으로써 모달보드를 조정해줘야한다
function show_modal_bg_board(){

	showModalBG();
	showModalBoard();
	// ajax에 의해 이 보드가 채워진다
	// 호출 이후 내용을 채우고 나서
	// 반드시 changeWidthHeightModalBoard를 호출해서 모달보드의 너비를 보정한다
}

// modal board를 숨긴다. background 클릭시 호출한다
function hideModalBoard(){
	$('#modal_bg').fadeOut()/*hide()*/
	$('#option_container').fadeOut()
	$('#modal_board').html("").fadeOut()
}

// feeldup 눌렀을 때 나오는 배경 및 필드업 보드  숨겨놓기
// 맨첨에만 불린다
// 사실 hideModalBoard와 비슷하다
function hideModalBG(){
	$('#modal_bg').hide()
	$('#option_container').hide()
	$('#modal_board').hide()
}



// 문서가 다 로드 되면 해야 할 작업들
// 문서가 다 로드 되면 해야 할 작업들
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
	$( ".nav-icon, #feeldup img" ).hover(
		function() {
			prev = $(this).attr('src')
			prev_split = prev.split(".")
			$( this ).attr('src',  prev_split[0] + "rev" + ".png")
		}, function() {
			$( this ).attr('src', prev)
		}
	);
	
	
	// #feeldup click
	// #feeldup click
	$('#feeldup').click(function(){

		showModalBG();

		showOptionContainer();

		// modal board는
		// option_item이 클릭 되었을 때 띄운다

	})
	// #feeldup click end


	// feeldup option 클릭 
	// feeldup option 클릭 
	$('.option_item').click(function(){
		// 옵션들 지워주자, 화면 리사이즈 할 때 옵션들이 움직이면서 거슬리는 경우가 있다
		$('#option_container').hide()
		
		// 배경 눌러서 없어지는 찰나에 옵션 누르는게 가능한  버그 해결
		if (isModalBgShowed)
			showModalBoard();
	})
	// feeldup option 클릭 end

	
	// #modal_bg click
	// #modal_bg click
	$('#modal_bg').click(function(){
		isModalBgShowed = false;
		isPostItemClicked = false;

		hideModalBoard();
	})
	// #modal_bg click end


	// window resize
	// window resize
	$( window ).resize(function() {
		// 모달 보드를 띄운 후 리사이즈 할 때 
		// 다시 호출해 줌으로써 위치를 조정한다(배경과 보드의)
		if (isModalBgShowed){
			show_modal_bg_board();
		}

		changeWidthHeightModalBoard();
	});
	// window resize end

})
