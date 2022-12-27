<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
<title>리뷰 작성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/vs-css/review-write.css"> <!--css 불러오는 링크--> 

</head>
<body>           

<div class="wrapper">
        <div class="Rwrite">
            <div class="inner">
                <div class="RwriteH">
                    <a href="${pageContext.request.contextPath}/"><img src="${pageContext.request.contextPath}/images/Foodiary-logo.png" alt="홈으로"></a>
                </div> <!--RwriteH-->
                <div class="RwriteB">
                    <fieldset>
                        <legend>
                            <form class="form-submit" action="write" method="post" enctype="multipart/form-data">
								<!-- 첨부파일 -->
								<div>
									<label>첨부파일(1개당 1MB. 최대 10MB 가능)</label>
									<input type="file" name="attachments" multiple>
								</div>
								
								<!-- 별점 -->    
								별점 : <div class="star-score-edit" data-max="5"></div>
									
								<!-- summernote + 리뷰장소 -->	
								<div class="float-container">
									<!-- summernote -->
									<div class="float-left">
										<textarea name="reviewContent" class="reviewContent"></textarea>
									</div>
									
									<!-- 리뷰장소 -->
									<div class="float-left">
								    	<label>리뷰 장소</label>
								    	<br>
								        <input type="text" name="reviewAddress" placeholder=" 주소 : 지도에서 주소를 선택하세요" readonly>
									        <button class="btn-xmark" type="button">
									        	<i class="fa-regular fa-rectangle-xmark"></i>
								        	</button>
								       	<br>
								        <input type="text" name="reviewPlace" placeholder=" 장소명 : 추가 입력 가능">
										<div class="map_wrap">
									    	<div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
										    <div id="menu_wrap" class="bg_white">
										        <div class="option">
										            <div>
										                <!-- <form onsubmit="searchPlaces(); return false;">  -->
										                    <input type="text" value="당산역 맛집" id="keyword" size="15"> 
										                    <button type="button" class="keywordMap">검색</button> 
										                <!--  </form> -->
										            </div>
										        </div>
										        <hr>
										        <ul id="placesList"></ul>
										        <div id="pagination"></div>
										    </div>
										</div>
									</div>
								</div>
								
								<div class="btn-write">
									<button type="submit">등록하기</button>
								</div>
                            </form>
                        </legend>
                    </fieldset>
                </div> <!--RwriteB-->
            </div> <!--inner-->
        </div> <!--Rwrite-->
    </div> <!--wrapper-->


<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.1.js"></script>
<!-- 별점 -->
<script src="${pageContext.request.contextPath}/js/score.min.js"></script> <!-- 수정본 js파일 : 별점단위 0.5로 변경 -->
<!-- summernote -->
<link href="${pageContext.request.contextPath}/css/summernote-lite.min.css" rel="stylesheet" type="text/css" >
<script src="${pageContext.request.contextPath}/js/summernote-lite.min.js"></script>
<script src="${pageContext.request.contextPath}/js/summernote-ko-KR.min.js"></script>
<!-- 지도 키워드검색 -->
<link href="${pageContext.request.contextPath}/css/kakao-keyword.css" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${appkey}&libraries=services"></script>
<script src="${pageContext.request.contextPath}/js/kakao-keyword.js"></script>
<!-- font-awesome -->   
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css"/>
    
<script type="text/javascript">
	$(function(){
		//summernote 옵션 수정
		$("textarea[name=reviewContent]").summernote({
			width:500,	//가로
			height:300,	//높이
			minHeight:200,	//최소높이
			placeholder:"내용을 작성하세요",	//도움말
			lang:"ko-KR",	//언어설정
			toolbar:[	//툴바 메뉴
				["style",["style"]],
				["font",["bold","underline","clear"]],
				["color",["color"]],
				["para",["ul","ol","paragraph"]],
				["table",["table"]],
				//["insert",["link","picture","video"]],	//이미지, 비디오 삭제
				["insert",["link"]],
				//["view",["fullscreen","codeview","help"]]]	//전체모드, code모드 삭제
				["view",["help"]]],
			callbacks: {
				onChange:function(contents){ //텍스트 글자수
	                setContentsLength(contents, 0);
	            }
			}
		});
		//글자수 체크
		//- byte 변환식
		const getByteLengthOfString = function(s,b,i,c){
		    for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1);
		    return b;
		};
		//-  글자수 초과직전의 내용 미리저장할 변수
		var changeText = $('.reviewContent').summernote('code');
		function setContentsLength(str, index) { //글자수 체크
		    var maxCnt = 2000; //DB저장 최대 Byte수
		    var length = getByteLengthOfString($('.reviewContent').summernote('code')); //총 글자수
	        
	        if(length <= maxCnt) {
		    	changeText = $('.reviewContent').summernote('code');
		    } 
		    if(length > maxCnt) {
		    	length = length-20;	//장문의 태그추가시 byte가 확 많아지기 때문에, 초과시 넉넉히 20 빼 준다
        		alert("등록오류 : 내용을 줄여주세요.");
                $('.reviewContent').summernote('code', changeText);
		    }
		}
		
		//별점 옵션 수정
		$(".star-score-edit").score({
            editable:true,//수정 가능하도록 설정
            zeroAvailable:true,//0 설정 가능 여부
            integerOnly:false,//정수만 가능
            display:{
                showNumber:true,//설정된 숫자 표시 가능 여부
                placeLimit:1,//소수점 자리수
                textColor:"black",//숫자 색상(기본 : 금색)
            },
            send: {
                sendable:true,//전송가능 설정
                name:"starScore"//전송 파라미터 명 설정
            }
        });
		
		//주소 : x버튼 초기화
		$(".btn-xmark").click(function(){
			$("input[name=reviewAddress]").val("");
		});
		
		//사진 없으면, 전송불가
		$(".form-submit").submit(function(e) {
			var result = true;
			if ($("input[name=attachments]").val() == "") {
				alert("사진을 선택해주세요");
				return result = false;
			}
			return result;
		});
	});
</script>
</body>
</html>