<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>비밀번호 변경</title>
</head>

<body>
현재 비밀번호
<input type="password" id="password" onkeyup="passwordCheck(this.value, ${sessionScope.id})">
<div id="checkMessage" style="color: red; font-size: small;"></div>
변경 비밀번호
<input type="password" id="newPassword" onkeyup="newPasswordCheck(this.value)" disabled="disabled">
<div id="checkMessage2" style="color: red; font-size: small;"></div>
<input type="hidden" value="${sessionScope.id}">
비밀번호 확인 <input type="password" name="newPassword" onkeyup="checkPasswordEqual(this.value)" id="equalCheck"
               disabled="disabled">
<div id="checkMessage3" style="color: red; font-size: small;"></div>
<button type="button" onclick="javascript:window.close()">취소</button>
<button id="submit" disabled="disabled" onclick="submitNewPassword()">변경</button>
</body>


<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
<script type="text/javascript">

    // 현재 비밀번호가 일치하는지 확인하는 함수
    function passwordCheck(typed, id) {
        $.post("<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/api/member/passwordCheck", {id : id, password: typed}, function(data){
            if(data == "0") {
                $('#checkMessage').html("비밀번호가 일치하지 않습니다.");
            } else {
                $("#password").attr("disabled", true); // 입력된 비밀번호 칸을 비활성화
                $('#checkMessage').html("");
                $("#newPassword").attr("disabled", false); // 변경 비밀번호 칸을 활성화
            }
        })
    }
    function newPasswordCheck(typed){
        $("#equalCheck").attr("disabled", true);
        $("#equalCheck").val('');
        $("#checkMessage3").html("");
        $("#submit").attr("disabled", true);
        if (typed.length < 8 || typed.length > 20) {
            $('#checkMessage2').html("8자리 ~ 20자리 이내로 입력해주세요.");
            $("#equalCheck").attr("disabled", true);
        } else if (typed.search(/\s/) != -1){
            $('#checkMessage2').html("비밀번호는 공백 없이 입력해주세요.");
            $("#equalCheck").attr("disabled", true);
        } else {
            $('#checkMessage2').html("");
            $('#equalCheck').attr("disabled", false);
        }
    }
    function checkPasswordEqual(typed){
        if($("#newPassword").val() != typed) {
            $('#checkMessage3').html("변경할 비밀번호와 일치하지 않습니다.");
            $("#submit").attr("disabled", true);
        } else {
            $('#checkMessage3').html("");
            $("#submit").attr("disabled", false);
        }
    }
    function submitNewPassword() {
        $.ajax({
            type: "POST",
            url: "<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/api/member/modify-password",
            data: {
                "id" : ${sessionScope.id},
                "password": newPassword.value
            },
            success: function () {
                alert("비밀번호가 변경되었습니다.");
                window.close();
            },
            error: function (error) {
                console.log("에러발생", error);
            }
        });
    }
</script>
</html>