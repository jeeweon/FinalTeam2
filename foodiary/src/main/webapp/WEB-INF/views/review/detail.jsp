<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- 현재 시간 구하기 -->
<jsp:useBean id="now" class="java.util.Date"></jsp:useBean>
<c:set var="today">
	<fmt:formatDate value="${now}" pattern="yyyy-MM-dd"/>
</c:set>
<c:set var="current">
	<fmt:formatDate value="${reviewDto.reviewWriteTime}" pattern="yyyy-MM-dd"/>
</c:set>

<style>
/* summernote(좌측), 리뷰장소(우측) 구분용 style */
	.float-container {
		width: 850px;
	}
    .float-container::after {
        content: "";        /* 영역에 들어갈 글자 */
        display: block;   /* block형태 공간 */
        clear: both;
    }
    .float-left {
        float: left;
        width: 50%;
    }
    .clear {
        clear: both;
    }
    
    .reviewBox {
    	width: 450px;
    	border: 1px solid gray;
    	border-radius: 5px;
    }

/* 댓글목록 관련 style */
	.replyBox {
		width: 450px;
	}
	.replyListHead {
		margin-top: 6px;
		margin-left: 6px;
		font-size: 14px;
	}
	.replyListBody {
		text-align: center;
	}
	.profile {
		width: 50px;
	}
	.replyContent {
		width: 430px;
		border: 1px solid transparent;
		border-radius: 5px;
		outline: none;
		padding: 4px;
	}
	.input-reply {
		width: 370px;
	}
</style>



<div>
	<h1>리뷰 상세</h1>
</div>

<!-- 글번호 -->
<input type="hidden" name="reviewNo" value="${reviewDto.reviewNo}">

<div>

작성자 회원번호 : ${reviewDto.memNo} <br>
<!-- 회원정보 : 프로필 사진, 닉네임, 팔로우버튼(팔로우중:팔로잉)
				- (사진,닉네임)클릭시 프로필로 이동 
-->

<!-- 작성일 -->
<c:choose>
	<c:when test="${today == current}">
		작성일 : 
		<fmt:formatDate value="${reviewDto.reviewWriteTime}" pattern="HH:mm"/>
	</c:when>
	<c:otherwise>
		작성일 : 
		<fmt:formatDate value="${reviewDto.reviewWriteTime}" pattern="yyyy-MM-dd"/>
	</c:otherwise>
</c:choose>	

<!-- 회원 기능 
	1. 작성자 본인이 아닐 때 : 신고버튼
		- 신고버튼 (확인 팝업 노출: 취소불가능, 불이익 안내, 완료시 완료 팝업)
	2. 작성자 본인일 때 : 수정/삭제
-->	
	<!-- 신고 -->
	<c:set var="member" value="${loginNo != null && loginNo != reviewDto.memNo}"></c:set>
	<c:if test="${member}">
		<input class="btn-report" type="button" value="신고">
	</c:if>

	<!-- 수정, 삭제 -->
	<c:set var="owner" value="${loginNo == reviewDto.memNo}"></c:set>		
	<c:if test="${owner}">
		<a href="edit?reviewNo=${reviewDto.reviewNo}">수정</a>
		<a href="delete?reviewNo=${reviewDto.reviewNo}">삭제</a>
	</c:if>
</div>
	
<div class="float-container"> <!-- 사진(좌측)/본문(우측) 배치 -->
	<!-- 첨부파일 : 슬라이딩 기능 필요 -->
	<div class="float-left">
		<!-- 사진 --> <br>
		<c:forEach var="attachDto" items="${attachments}">
			<img src="${pageContext.request.contextPath}/attach/download/${attachDto.attachNo}" width="400" height="400">
		</c:forEach>
	</div>
	
	<div class="float-left">
		<div class="float-container">
			<div class="reviewBox">
				<div class="float-left">
				<!-- 리뷰 : 주소/장소, 별점은 있을 경우에만 출력 -->
				<!-- 별점 -->
				<c:if test="${reviewDto.starScore >0}">
					별점 <div class="star-score" data-max="5" data-rate="${reviewDto.starScore}"></div> <br>
				</c:if>
				
				<c:if test="${reviewDto.reviewAddress!=null || reviewDto.reviewPlace!=null}">
					<!-- 리뷰장소 : 위치 (본문 상단) -->
				    	<label>리뷰 장소</label>
				    	<br>
				    	<c:choose>
					    	<c:when test="${reviewDto.reviewPlace==null}">
						        <input type="text" name="reviewAddress" value="${reviewDto.reviewAddress}" readonly>
								<div class="map_wrap">
							    	<div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
								    <div id="menu_wrap" class="bg_white">
								        <div class="option">
								            <div>
								                <!-- <form onsubmit="searchPlaces(); return false;">  -->
								                    <input type="text" value="${reviewDto.reviewAddress}" id="keyword" size="15" readonly> 
								                    <button type="button" class="keywordMap">검색</button> 
								                <!--  </form> -->
								            </div>
								        </div>
								        <hr>
								        <ul id="placesList"></ul>
								        <div id="pagination"></div>
								    </div>
								</div>
							</c:when>
							<c:when test="${reviewDto.reviewAddress==null}">
						        <input type="text" name="reviewPlace" value="${reviewDto.reviewPlace}" readonly>
							</c:when>
							<c:otherwise>
						        <input type="text" name="reviewAddress" value="${reviewDto.reviewAddress}" readonly>
						       	<br>
					        	<input type="text" name="reviewPlace" value="${reviewDto.reviewPlace}" readonly>
								<div class="map_wrap">
							    	<div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
								    <div id="menu_wrap" class="bg_white">
								        <div class="option">
								            <div>
								                <!-- <form onsubmit="searchPlaces(); return false;">  -->
								                    <input type="text" value="${reviewDto.reviewAddress}" id="keyword" size="15" readonly> 
								                    <button type="button" class="keywordMap">검색</button> 
								                <!--  </form> -->
								            </div>
								        </div>
								        <hr>
								        <ul id="placesList"></ul>
								        <div id="pagination"></div>
								    </div>
								</div>
							</c:otherwise>
						</c:choose>
					</c:if>
				</div>
		
				<div class="clear"></div>
				<br>
				
				<!-- 본문 내용 -->
				<div class="float-left">
					<!-- 리뷰 내용 -->
					${reviewDto.reviewContent}
				</div>
				
			<div class="clear"></div>
			<br>
		</div>
		
			<div class="float-left replyBox">
				<!-- 댓글 위치 
					1. 댓글목록 : 최신순, 한번에 10개씩, 더보기클릭
						- 작성시간 출력
						- 회원 : 댓글 신고
						- 내 댓글 : 삭제 가능 (회원탈퇴시 자동삭제)
					2. 하단 위치 고정 : 좋아요, 북마크, 댓글작성란
						- 댓글 작성 : 내용없을 때 등록버튼 비활성화
				-->
				<!-- 댓글 목록 -->
				<div class="reply-list">
				</div>
					
	    		<hr>
				
				<!-- 댓글 작성 -->
				<input type="text" class="input-reply" name="replyContent" placeholder="내용을 입력해주세요.">
				<button class="btn-replyWrite" type="button">등록</button>
			</div>
		</div>
	</div>
</div>

<a href="list">목록으로</a>

	
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.1.js"></script>
<!-- 별점 -->
<script src="${pageContext.request.contextPath}/js/score.min.js"></script> <!-- 수정본 js파일 : 별점단위 0.5로 변경 -->
<!-- 지도 키워드검색 -->
<link href="${pageContext.request.contextPath}/css/kakao-keyword.css" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${appkey}&libraries=services"></script>
<script src="${pageContext.request.contextPath}/js/kakao-keyword.js"></script>
<!-- axios cdn -->
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>

<script type="text/javascript">
	$(function(){
		//변수 저장
		//reviewNo = $("input[name=reviewNo]").val()
		let reviewNo = ${reviewDto.reviewNo}	//리뷰 글번호
		let loginNo = ${loginNo}	//로그인한 회원번호
		
		//별점 옵션 수정
		$(".star-score").score({
			display: {
				showNumber:true,//설정된 숫자 표시 가능 여부
                placeLimit:1,//소수점 자리수
                textColor:"black",//숫자 색상(기본 : 금색)
		    }
        });
		
		//신고버튼
		$(".btn-report").click(function(){
			//확인 팝업(경고)
			var result = confirm("정말 신고하시겠습니까?\n허위 신고시 서비스 이용제한조치를 받으실 수 있습니다.");
			var that=$(this);
			
			//신고 카운트+1
			if(result) {
				axios.post("${pageContext.request.contextPath}/rest/review/report/"+reviewNo)
				.then(function(response){
					//console.log(response);
					if(response.data) {	//response가 true일 경우
						alert("신고가 접수되었습니다.");
						$(that).prop("disabled", true);
					}
				});
			}
		});
	
		
		//댓글목록 출력
		loadReplyList();
		
		//댓글 입력
		$(".btn-replyWrite").click(function(){
			var memNo = loginNo;
    		var replyContent = $(".input-reply").val();
    		
			axios.post("${pageContext.request.contextPath}/rest/reply/insert", {
				reviewNo: reviewNo,	
				memNo: memNo,
				replyContent: replyContent
			})
			.then(function(resp){
				//console.log(resp);
				$(".input-reply").val("");
				loadReplyList();
			});
		});
		
		//댓글 : 목록조회
		function loadReplyList(){
			axios.get("${pageContext.request.contextPath}/rest/reply/list/"+reviewNo)
			.then(function(resp){
	        	var replyListVO = resp.data;

	        	$(".reply-list").empty();	//목록 초기화
	        	$.each(replyListVO, function(index, value){
	        		var replyNo = value.replyNo;
	        		var replyMemNo = value.memNo;
	        		var replyReportCnt = value.replyReportCnt;
	        		
	        		//replyListHead
	        		var profile;
	        		if(value.attachNo == 0) {
	        			profile = $("<img>").attr("src", "${pageContext.request.contextPath}/images/basic-profile.png");						
					} else {
						profile = $("<img>").attr("src", "${pageContext.request.contextPath}/attach/download/"+value.attachNo);
					}
	        		profile.addClass("profile");
	        		
	        		var memNick = $("<span>").text(value.memNick);
	        		
	        		var memLevel = $("<span>").text(" Lv."+value.memLevel);
	        		
        			var replyReport = $("<input>").val("신고");
        			replyReport.attr("type", "button").addClass("btn-reply-report");

        			var replyDelete = $("<input>").val("삭제");
        			replyDelete.attr("type", "button").addClass("btn-reply-delete");
	        		
        			//replyListBody
	        		var replyWriteTime = $("<span>").text("\n"+value.replyWriteTime);
	        		
	        		var replyContent = $("<input>").attr("value", value.replyContent).prop("readonly", true);
	        		replyContent.addClass("replyContent");
	        		
	        		//reply-list
	        		var replyListHead = $("<div>").append(profile).append(memNick).append(memLevel).append(replyWriteTime);
	        		if(loginNo==replyMemNo) {
	        			replyListHead = $("<div>").append(profile).append(memNick).append(memLevel).append(replyWriteTime)
													.append(" ").append(replyDelete);
	        		}else if(!loginNo.empty){
		        		replyListHead = $("<div>").append(profile).append(memNick).append(memLevel).append(replyWriteTime)
		        									.append(" ").append(replyReport);
	        		}
	        		replyListHead.addClass("replyListHead");
	        		
	        		var replyListBody = $("<div>").append(replyContent);
	        		replyListBody.addClass("replyListBody");
	        		
	        		$(".reply-list").append(replyListHead).append(replyListBody);
	        	});
			});
		}
	});
</script>