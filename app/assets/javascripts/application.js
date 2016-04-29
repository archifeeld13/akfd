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
//= require jquery.remotipart
//= require turbolinks
//= require_tree .
//

// 여기 있으나 마나이다. 익스플로러나 모바일에선 다른곳에서 이거 못읽는다
function tag_truncate(){
	var result = ""
	$('.tag_list').each(function(){	
		tmp_arr = $(this).html().split(",").slice(0, 3);
		result = tmp_arr.join();
		if ($(this).html().split(",").length > 3)
			result += " <strong> ...+</strong> "
		$(this).html(result);
	})
}

function imgIconHover(selector){
	prev = ""
	$( selector ).hover(
		function() {
			prev = $(this).attr('src')
			prev_split = prev.split(".")
			$( this ).attr('src',  prev_split[0] + "rev" + ".png")
		}, function() {
			$( this ).attr('src', prev)
		}
	);
}


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
function showModalBG(){
	isModalBgShowed = true;

	// 흐린 배경 표시 -> 이 액션은 posts.js에서도 post item 클릭시 취한다
	$('#modal_bg')
		.css('height', $(document).height())
		.css('width', $(document).width())
		.fadeIn()/*show()*/
}


// 로딩중 표시 위해서
// 로딩중 표시 위해서
// 로딩중 표시 위해서
// http://gasparesganga.com/labs/jquery-loading-overlay/
function showLoadingBG(option="modal"){
		$('body').LoadingOverlay("show")
	//	$('.modal-body').LoadingOverlay("show")
		//$('#modal_board').LoadingOverlay("show")
}
function hideLoadingBG(option="modal"){
		$('body').LoadingOverlay("hide")
	//	$('.modal-body').LoadingOverlay("hide")
		//$('#modal_board').LoadingOverlay("hide")
}
// 로딩중 표시 위해서
// 로딩중 표시 위해서



// modal bg와options를 숨긴다. background 클릭시 호출한다
function hideModalBGandBoard(){
	$('#modal_bg').fadeOut()/*hide()*/
	$('#option_container').fadeOut()
}

// feeldup 눌렀을 때 나오는 배경 및 필드업 보드  숨겨놓기
// 맨첨에만 불린다
//  로딩 bg랑 별거 다 없애논다
function hideDivsAtFirst(){
	$('#modal_bg').hide()
	$('#option_container').hide()
}



// RFM의 여러 이벤트를 설정하는 곳
var isFavFeeldupClicked = false
function rightFixedMenuEvent(){
	// 인기 필드업
	$('#fav_feeldup').click(function() {
		if (!isFavFeeldupClicked){
			isFavFeeldupClicked = true
			$('#fav_feeldup_content').animate({height: '315'});
		}
		else{
			isFavFeeldupClicked = false;
			$('#fav_feeldup_content').animate({height: '105'});
		}
	});
	//인기 태그
}


// 문서가 다 로드 되면 해야 할 작업들
// 문서가 다 로드 되면 해야 할 작업들
$(function(){

	rightFixedMenuEvent();

	// 네브바 서치 인풋태그 배경 토글
	$('#nav_search_input').bind('focus', function(){
		$(this).css('background-color', 'white')
	}).bind('blur', function(){
		$(this).css('background-color', 'rgba(104,104,104,0.3)')
	})

	//	feeldup Background를일단 숨겨놓음 
	hideDivsAtFirst();

	imgIconHover(".nav-icon");
	imgIconHover("#feeldup img");
	
	
	// #feeldup click
	// #feeldup click
	$('#feeldup').click(function(){

		isFeeldupClicked = true;
		showModalBG();
		showOptionContainer();

		// modal board는
		// option_item이 클릭 되었을 때 띄운다
		return false;

	})
	// #feeldup click end


	// feeldup option 클릭 
	// feeldup option 클릭 
	$('.option_item').click(function(){
		// 옵션들 지워주자, 화면 리사이즈 할 때 옵션들이 움직이면서 거슬리는 경우가 있다
		hideModalBGandBoard();
		
		// 배경 눌러서 없어지는 찰나에 옵션 누르는게 가능한  버그 해결
		if (isModalBgShowed){
			$('#my_modal').modal({
				keyboard: true,
			})
		}
	})
	// feeldup option 클릭 end

	//User Search Button 클릭
	$('#userSearchBtn').click(function() {
		$('#my_modal').modal({
			keyboard: true,
		})
		//모달 보여줘야대고 새로 작성해야대는 부분
	})
	
	// #modal_bg click
	// #modal_bg click
	$('#modal_bg').click(function(){
		isModalBgShowed = false;
		isFeeldupClicked = false;

		hideModalBGandBoard();
	})
	// #modal_bg click end
	//

})
