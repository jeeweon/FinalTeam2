<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<title>알림</title>
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">


<style>
.fixed-top {
	position: fixed;
	width: 100%;
	height:160px;
	top: 0;
	box-sizing: border-box;   
    background-color: #ffffff;
	z-index: 99;
	text-align: center;
}

.logo{
    position: absolute;
    top: 30px;
    left: 100px;
}

.logo img {
    width: 160px;
}

.title {
	text-align: center;
	margin-top: 65px;
}

.subtitle {
	font-size: 18px;
	color: gray;
}

.noti-list {
	width: 600px;
	margin: 0 auto;
	margin-top: 160px;
	margin-bottom: 100px;
}

.noti-item {
	font-size: 20px;
	display: flex;
    lex-direction: row;
	justify-content: flex-start;
	align-items: center;
    padding: 30px;
}

.noti-item:hover {
	background-color: #F2F7FE;
}

.noti-icon, .noti-info {
	display: inline;
}

.noti-info {
	display: flex;
    flex-direction: column;
    justify-content: flex-start;
    align-items: flex-start;
}

.noti-time {
	margin-top: 10px;
	color: #AAAAAA;
	font-size: 16px;
	text-align: right;
}

.noti-icon {
	margin-right: 25px;
}

.fa-user {
	color: #F8D588;
}

.fa-heart {
	color: #E27C5E;
}

.fa-comment {
	color: #57B9F9;
}

.no-item {
	width: 600px;
	margin: 0 auto;
	margin-top: 200px;
	text-align: center;
	color: gray;
}
</style>
</head>
<body>
<div class="fixed-top">
	<h1><a href="${pageContext.request.contextPath}/" class="logo"><img src="${pageContext.request.contextPath}/images/Foodiary-logo.png" alt="로고/홈으로"></a></h1>
	<h1 class="title">알림</h1>
	<span class="subtitle">최근 7일 간의 알림을 확인할 수 있어요.</span>
</div>

<div class="noti-list">
	<c:choose>
		<c:when test="${fn:length(list) != 0}">
			<c:forEach var="list" items="${list}">
				<div class="noti-item" data-url="${list.notiUrl}" data-no="${list.notiNo}">
					<div class="noti-icon">
						<c:choose>
							<c:when test="${list.notiType == 'follow'}">
								<span><i class="fa-solid fa-user fa-2x"></i></span>
							</c:when>
							<c:when test="${list.notiType == 'like'}">
								<span><i class="fa-solid fa-heart fa-2x"></i></span>
							</c:when>
							<c:when test="${list.notiType == 'reply'}">
								<span><i class="fa-solid fa-comment fa-2x"></i></span>
							</c:when>
						</c:choose>
					</div>
					<div class="noti-info">
						<span class="noti-content">${list.notiContent}</span>
						<span class="noti-time">${list.notiCreateDate}</span>
					</div>
				</div>
			</c:forEach>
		</c:when>
		<c:otherwise>
			<div class="no-item">
				<span>받은 알림이 없어요.</span>
			</div>
		</c:otherwise>
	</c:choose>
</div>
<!-- jquery 라이브러리 -->
<script src="https://code.jquery.com/jquery-3.6.1.js"></script>
<script src="${pageContext.request.contextPath}/js/commons.js"></script>
<script type="text/javascript">
//알림 목록 클릭 시, 타겟 url로 이동
$(document).on("click", ".noti-item", function(){
	//읽은 시간 업데이트
	let notiNo = $(this).data("no");
	$.ajax({
		url : "${pageContext.request.contextPath}/rest/noti/read/"+ notiNo,
		method : "get",
		dataType : "json",
		success : function(resp) {
		}
	});
	window.location = "${pageContext.request.contextPath}" + $(this).data("url");
});
</script>
</body>
</html>


