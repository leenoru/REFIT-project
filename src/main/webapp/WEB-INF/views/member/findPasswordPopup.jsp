<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
</head>

<body>
이메일
<input type="text" id="email">
<button id="submit" onclick="sendCertEmail()">인증 메일 발송</button>
<input type="hidden" id="code" placeholder="인증번호">
<button type="button" id="codeButton" onclick="checkCode($('#code').val())" style="display: none;">확인</button>
<div id="checkMessage" style="color: red; font-size: small;"></div>
<button type="button" onclick="javascript:window.close()">취소</button>
</body>
<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
<script type="text/javascript">

    // 인증 메일 발송 함수
    function sendCertEmail() {
        $.ajax({
            type: "GET",
            url: "../api/member/sendFindEmail",
            data: {
                "email": $('#email').val()
            },
            success: function (res) {
                if(res == "0") {
                    alert("존재하지 않는 사용자입니다.");
                } else {
                    alert("인증번호가 전송되었습니다.");
                    document.getElementById("code").type = "text";
                    document.getElementById("codeButton").style.display = "block";
                    code = res;
                }
            }
        });
    }

    // 코드 검증 함수
    function checkCode(input) {
        if (input == code) {
            alert("확인되었습니다. 임시비밀번호가 메일로 전송됩니다.");
            $.ajax({
                type: "POST",
                url: "../api/member/sendTempPassword",
                data: {
                    "email": $('#email').val()
                }
            })
            window.close();
        } else {
            alert("인증번호가 틀렸습니다. 다시 입력해주세요.");
        }
    }
</script>
</html>