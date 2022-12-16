<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" type="text/css"href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/vs-css/board.css"> <!--css불러오는 링크-->
<style>
	.orign{
		width:50px;
		hight:50px;
	}
</style>
<script src="https://code.jquery.com/jquery-3.6.1.js"></script>	
<script>
	$(function(){
		memRek();
		let memRekList = [];
		function memRek() {
		$.ajax({
			url : "${pageContext.request.contextPath}/rest/profile/memrek",
			method : "get",
			dataType : "json",
			success : function(resp) {
				memRekList = resp;
				console.log(memRekList);
				threeMem();
			}
		});
	};
	function threeMem(){
		$.each(memRekList, function(index, value) {
// 			console.log(value);
// 			console.log(value.memNo);
			console.log(value.attachNo);
			var memImg=$("<img>").attr("src","");
			var reviewImg = $("<img>").attr("src","${pageContext.request.contextPath}/attach/downloadReviewAttach/"+value.reviewNo);
			var br=$("<br>");
			var name=$("<span>").text(value.memNick);
			var a=$("<a>").attr("data-mno",value.memNo).append(memImg).append(name);
			a.click(function(){
				console.log("a클릭");
				window.location = "${pageContext.request.contextPath}/profilepage/yourprofile?memNo="+$(this).data("mno");
			});
			var button=$("<button>").attr("data-rno",value.memNo).text("팔로우");
			
			button.click(function(){
				console.log("팔로우 클릭");
				var that=$(this);
				$.ajax({
					url:"${pageContext.request.contextPath}/rest/review/follow",
					method:"post",
					data :{
						 passiveMemNo : $(this).data("rno")	
					},
					success :function(resp){
						console.log(resp);
						if(resp){
							$(that).text("팔로잉");
						}else{
							$(that).text("팔로우");
						}
					}
				});
			});
			memImg.addClass("orign");
			//사진이 있는지 없는지 확인
		   if(value.attachNo > 0){
			   	memImg.attr("src","${pageContext.request.contextPath}/attach/download/"+value.attachNo);
			}else{
				memImg.attr("src","${pageContext.request.contextPath}/images/basic-profile.png");
			} 
			$(".main").append(a).append(button).append(br);	
		});
	};
});
</script>
<div class="main">
</div>



