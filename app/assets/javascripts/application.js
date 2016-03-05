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

// post-container와 right_fixed_menu는 상호작용한다. 	
// posts.js 와 큰 연관 관계를 가지고 있다.
function changeWidthPCandRFM(){
	// 컬럼 4개 여기 안먹히는데? 일단 걍 살려두자
	if ($(window).width() > 1300){
		$('#post-container').css('width', '80%')
		//$('#right_fixed_menu').css('width', '15%').css('left', $(window).width() * 0.825 ).show()
		$('#right_fixed_menu').css('width', '15%').css('right', '2.5%')
	}
	// 컬럼 3개
	else if ($(window).width() > 1000){
		$('#post-container').css('width', '74%') // 여러번 테스트해본결과 적정한 수치
		$('#right_fixed_menu').css('width', '20%').css('right', '2.5%')
	}
	// 컬럼 2개
	else if ($(window).width() > 480){
		$('#post-container').css('width', '65%') // 원래는 양쪽 합이 95% 였는데 이게 더 자연스러워서..
		$('#right_fixed_menu').css('width', '30%').css('right', '2.5%')
	}
}

// change width and height of feeldup board
function changeWidthHeightFUBoard(){

	// 스크린이 한없이 작아질 때, 필드업 보드가 납작해지니까.. 50%이상으로 해주자.
	$('#feeldup_board').css('width','700px').css('margin-left', ($(window).width() -  $('#feeldup_board').width())/2)

	// 필드업 보드의 높이를 조정
	$('#feeldup_board')
		.css('height', $(window).height() * 0.8)
		.css('top', $(window).height() * 0.10 )
}


// feeldup 눌렀을 때 나오는 배경 및 필드업 보드  숨겨놓기
function hideFeeldupBG(){
	$('#feeldup_option_bg').hide()
	$('#option_container').hide()
	$('#feeldup_board').hide()
}

$(function(){

	changeWidthPCandRFM();

	hideFeeldupBG();

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
	
	
	// '필드업 버튼' 클릭시 이벤트
	// isClickedFeeldup 변수는 화면 사이즈 조정시 요소의 사이즈를 다시 구하기 위해서
	// window resize이벤트가 발생할 때마다 feeldup버튼을 다시 클릭을 해줌으로써
	// 요소의 사이즈를 재정비 하려고 했지만, 버튼을 클릭하지 않은 상태에서도 resize이벤트에 걸려서
	// 버튼을 누르지 않았음에도 이벤트가 발생해 이 문제를 해결하고자 추가했다.
	isClickedFeeldup = false;

	// #feeldup click
	// #feeldup click
	$('#feeldup').click(function(){
		isClickedFeeldup = true;

		// 흐린 배경 표시
		$('#feeldup_option_bg')
			.css('height', $(document).height())
			.css('width', $(document).width())
			.fadeIn()/*show()*/

		// fix시키면 된다. (fix하지 않으면 $(window).scroll이벤트에 위치 설정을 반복해야한다)
		// + 반드시 #feeldup_option_bg가 show되고 나서 와야한다.
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
		// feeldup 보드를 띄운 후, 사이즈를 조정한다 (윈도우 리사이즈 이벤트일 때 다시 구해야한다)
		$('#feeldup_board').fadeIn()

		// 보드가 뜨지 않은 상태에서 호출하면 넓이가 작은 상태에서 구해지기 때문이다.
		// changeWidthHeightFUBoard ( window resize시 변경) 함수와 연관이 있는 부분이다.
		$('#feeldup_board')
			.css('margin-left', ($(window).width() -  $('#feeldup_board').width())/2)
			.css('position', 'fixed')
		changeWidthHeightFUBoard();
		// 일단 보드를 띄우면 ajax 통신에 의해서 내용이 채워지게 끔 구성하자
		
		return false;
	})
	

	// feeldup 버튼 누르면 나오는 옵션 눌렀을 때 부모로 클릭 이벤트 전달 막으려고
	// feeldup 보드의 부분을 클릭하면 부모로 이벤트 전달 막기
	$('#feeldup_board').click(function(){
		return false;
	})		


	// #feeldup_option_bg click
	// #feeldup_option_bg click
	$('#feeldup_option_bg').click(function(){
		isClickedFeeldup = false

		$('#feeldup_option_bg').fadeOut()/*hide()*/
		$('#feeldup_board').fadeOut()

		// 그외 변수 및 폼 초기화가 필요할 것 같다.
		$('#feeldup_board').html("")
	})
	// #feeldup_option_bg click end


	// window resize
	// window resize
	$( window ).resize(function() {
		// feeldup 클릭 후 리사이즈 할 때 유지하기 위해서
		if (isClickedFeeldup){
			$('#feeldup').click()
		}

		changeWidthPCandRFM();
		changeWidthHeightFUBoard();
	});
	// window resize end
	// window resize end

})
