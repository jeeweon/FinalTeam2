<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css"/>
<style>
   .success-message,
   .fail-message,
   .NNNNN-message,
   .NNNNY-message { 
           display: none;
        }
   .input.success ~ .success-message{
   		display : block;
   }	
   .input.fail ~ .fail-message {
            display: block;
        }
   #success-message,
   #fail-message { 
           display: none;
        }
   .input.success ~ #success-message{
   		display : block;
   }
   .input.fail ~ #fail-message{
   		display : block;
   }
   .input.NNNNY ~ .success-message{
   		display : block;
   }	   
   .input.NNNNN ~ .NNNNN-message{
   		display : block;
   }	   
        
</style>	
	<div>
		<h1>회원가입</h1>
	</div>

<form action="join" class="join-form" method="post" autocomplete="off">
	<div>
		<label>
			이메일
			<i class="fa-solid fa-asterisk"></i>
		</label>
		<input type="text" class="input" name="memEmail" placeholder="?">
        <div class="success-message">올바른 이메일 형식입니다</div>
        <div class="fail-message">올바르지 않은 이메일 형식입니다</div>
        <div class="NNNNN-message">이미 사용중인 이메일입니다</div>
		<div><button class="send-btn" type="button" hidden>인증번호 보내기</button></div>
	</div>
	
        <div class="email-check">
	        <div id="success-message">올바른 인증번호입니다</div>
	     	<div id="fail-message">인증번호를 다시 확인해주세요</div>
        </div>

	
	<div>
		<label>
			비밀번호
			<i class="fa-solid fa-asterisk"></i>
		</label>
		<input type="text" class="input" name="memPw" placeholder="?">
        <div class="success-message">올바른 비밀번호 형식입니다</div>
        <div class="fail-message">비밀번호는 숫자, 영문 소문자, 특수문자를 반드시 1개 이상 포함하여 8~16자로 작성해주세요</div>		
	</div>
	
	<div>
		<label>
			비밀번호 확인
			<i class="fa-solid fa-asterisk"></i>
		</label>
		<input type="text" class="input" id="pw-re" placeholder="?">
		<div class="success-message">비밀번호가 일치합니다</div>
        <div class="fail-message">비밀번호가 일치하지 않습니다</div>		
	</div>
	
	<div>
		<label>
			닉네임
			<i class="fa-solid fa-asterisk"></i>
		</label>
		<input type="text" class="input" name="memNick" placeholder="?" >
		<div class="success-message">멋진 닉네임이에요</div>
        <div class="fail-message">닉네임은 한글과 숫자를 이용하여 2~10글자로 작성해주세요</div>
        <div class="NNNNN-message">이미 사용중인 닉네임입니다</div>		
	</div>
	
	<div>
		<label>
			생일
			<i class="fa-solid fa-asterisk"></i>
		</label>		
		<input type="date" class="input" name="memBirth" id="memBirth" placeholder="?">
        <div class="fail-message">생년월일을 선택해주세요</div>
	</div>
	
	<div>
		<button type="submit" >가입하기</button>
	</div>		
</form>

<script src="https://code.jquery.com/jquery-3.6.1.js"></script>
<script type="text/javascript">

$(function(){
	var judge = {
			memEmailValid : false,
	};
	
	var validChecker = {
			memEmailValid : false, memEmailRegex : /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/,
			memPwValid : false, memPwRegex : /^(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$])[a-zA-Z0-9!@#$]{8,16}$/,
			memPwReValid : false,
			memNickValid : false, memNickRegex : /^[가-힣0-9]{2,10}$/,
			memBirthValid : false, memBirthRegex : /([0-9]{2}(0[1-9]|1[0-2])(0[1-9]|[1,2][0-9]|3[0,1]))/,
			
			isAllValid : function(){
				return this.memEmailValid
					&& this.memPwValid
					&& this.memPwReValid
					&& this.memNickValid
					&& this.memBirthValid
			}
	};
	
	$("[name]").blur(function(){
		var name = $(this).attr("name");
		var value = $(this).val();
		var regex = validChecker[name+"Regex"];
		if(regex.test(value)) {
			validChecker[name+"Valid"] = true;
			$(this).removeClass("success fail").addClass("success");
		}
        else {
            validChecker[name+"Valid"] = false;
            $(this).removeClass("success fail").addClass("fail");
        }
		
	});
	
	//이메일 중복 검사
	$("input[name=memEmail]").blur(function(){
		var memEmail = $(this).val();
		$(this).removeClass("fail NNNNN NNNNY");
		
		if(validChecker.memEmailValid){
			var that = this;//this 보관
			
			$.ajax({
				url:"${pageContext.request.contextPath}/rest/mem/email",
				method:"post",
				data:{
					memEmail:memEmail
				},
				success:function(resp){
					if(resp=="NNNNN"){
						$(that).addClass("NNNNN");
						validChecker.memEmailValid = false;	
						$(this).removeClass("success fail").addClass("NNNNN");
					}
					else if(resp="NNNNY"){
						$(that).addClass("NNNNY");
						validChecker.memEmailValid = true;
						$(this).removeClass("success fail").addClass("success");
						$(".send-btn").prop("hidden",false);
					}
				},
				error:function(){}
			});
		}
		else{
			$(this).addClass("fail");
			validChecker.memEmailValid = false;	
		}
		
		
	});
	
	//이메일 발송
	$(".send-btn").click(function(){
		var email = $("[name=memEmail]").val();
		if(email.length==0) return;
		
		var btn =$(this);
		btn.prop("disabled",true);
		
		$.ajax({
			url : "${pageContext.request.contextPath}/rest/mem/email_check1",
			method: "post",
			data : {who:email},
			success : function(){
				btn.prop("disabled",false);
				
			var div = $("<div>");
			var input = $("<input>").addClass("serial");
			var successMessage = $("#success-message");
			var failMessage = $("#fail-message");
			var button = $("<button>").attr("type","button").text("인증번호 확인")
						
			button.click(function(){
				var serial = input.val(); //변수 input의 value 값 
				if(serial.length !=6) return;
				
				$.ajax({
					url : "${pageContext.request.contextPath}/rest/mem/email_check2",
					method : "post",
					data : {
						who : email, //바깥에 있는 email
						serial : serial //지금 불러온 serial
					},
					success:function(resp){
						judge.emailValid = resp;
						
						//버튼 잠금
// 						btn.prop("disabled",true);
// 						button.prop("disabled",true);
						
						if(resp) {
							$(".serial").removeClass("success fail").addClass("input success");
							$(".serial").after(successMessage);
// 							button.remove;
						}
				        else {
				            $(".serial").removeClass("success fail").addClass("input fail");
				            $(".serial").after(failMessage);
				        }
					}
				});
			});
			
			$(".email-check").html(div);		
			div.append(input).append(button);
			}
		});
	});
	
	$("input[name=memNick]").blur(function(){
		var memNick = $(this).val();
		$(this).removeClass("fail NNNNN NNNNY");
		
		if(validChecker.memNickValid){
			var that = this;//this 보관
			
			$.ajax({
				url:"${pageContext.request.contextPath}/rest/mem/nick",
				method:"post",
				data:{
					memNick:memNick
				},
				success:function(resp){
					if(resp=="NNNNN"){
						$(that).addClass("NNNNN");
						validChecker.memNickValid = false;	
						$(this).removeClass("success fail").addClass("success");
					}
					else if(resp="NNNNY"){
						$(that).addClass("NNNNY");
						validChecker.memNickValid = true;
						$(this).removeClass("success fail").addClass("fail");
					}
				},
				error:function(){}
			});
		}
		else{
			$(this).addClass("fail");
			validChecker.memNickValid = false;	
		}
	});
	
	$("input[name=memPw]").blur(function(){
		var pw = $(this).val();
		$(this).removeClass("fail success");
		
		if(validChecker.memPwValid){
			$(this).addClass("success");
			pwReValid = true;
		}
		else{
			$(this).addClass("fail");
			pwReValid = false;
		}
	});
	
	$("#pw-re").blur(function(){
		var origin = $("input[name=memPw]").val();
		var repeat = $(this).val();

		if(origin==repeat){
			validChecker.memPwReValid = true;
			$(this).addClass("success");
		}
		else{
			validChecker.memPwReValid = false;
			$(this).addClass("fail");
		}
		
	});
	
	$("input[name=memBirth]").blur(function(){
		var memBirth = $(this).val();
		if(memBirth.length>0){
			validChecker.memBirthValid = true;
		}
		else{
			validChecker.memBirthValid = false;
			$(this).addClass("fail");
		}
	});
	
	$(".join-form").submit(function(e){
		e.preventDefault();
		
		$(this).find("input, textarea, select").blur();

		if(validChecker.isAllValid()){
				this.submit();			
		}
		
		console.log('이메일',validChecker.memEmailValid);
		console.log('본인이메일',judge.memEmailValid);
		console.log('비번',validChecker.memPwValid);
		console.log('비번확인',validChecker.memPwReValid);
		console.log('닉',validChecker.memNickValid);
		console.log('생일',validChecker.memBirthValid);
	});
});

</script>

