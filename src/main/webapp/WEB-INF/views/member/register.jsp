<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
<!DOCTYPE html>
<%@ include file="../../layout/header.jsp" %>

<div class="container" style="display: flex; justify-content: center; align-items: center; height: 90vh;">
<table style="margin: 5%;">
    <tr>
        <td colspan="3"><h1 style="font-size:25px; text-align: center;">회원가입</h1></td>
    </tr>
    <tr>
        <td colspan="3">
            <form action="<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/member/registerEmail"
                  method="post">
                <p>이메일</p>
                <div class="row">
                      <div class="col">
                        <input class="form-control" type="text" name="email" placeholder="이메일" id="email" onblur="emailCheck()">
                      </div>
                      <div class="col">
                        <button type="button" class="btn btn-primary" id="mail-Check-Btn">인증코드 전송</button>
                      </div>
                </div>
                </div>
                <p id="check-result"></p>
                <div class="mail-check-box">
                    <input class="form-control mail-check-input" placeholder="인증코드 6자리를 입력해주세요!" disabled="disabled"
                           maxlength="6">
                    <span id="mail-check-warn"></span>
                </div>
                <br>
                <p>비밀번호<input class="form-control" type="password" name="password" placeholder="비밀번호"></p>
                <p>닉네임<input class="form-control" type="text" name="nickname" placeholder="닉네임"></p>
                <p style="text-align: center;"><input class="btn btn-dark" type="submit" id="submit" value="회원가입" disabled="disabled" style="width: 100%;"></p>
            </form>
        </td>
    </tr>
    <tr>
        <td>
            <a class="p-2"
               href="https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=<spring:eval expression="@property['kakao.client_id']"/>&redirect_uri=<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/member/registerKakao">
                <img src="${pageContext.request.contextPath}/resources/image/static/kakao_register_medium_narrow.png"/>
            </a>
        </td>
        <%
            String redirectURI = URLEncoder.encode(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/member/registerNaver", "UTF-8");
            SecureRandom random = new SecureRandom();
            String state = new BigInteger(130, random).toString();
            String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
            apiURL += "&redirect_uri=" + redirectURI;
            apiURL += "&state=" + state;
            apiURL += "&client_id=";
            session.setAttribute("state", state);
        %>
        <td>
            <a href="<%=apiURL%><spring:eval expression="@property['naver.client_id']"/>">
                <img height="50" src="http://static.nid.naver.com/oauth/small_g_in.PNG"/>
            </a>
        </td>
        <%
            redirectURI = URLEncoder.encode(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/member/registerGoogle", "UTF-8");
            apiURL = "https://accounts.google.com/o/oauth2/v2/auth?";
            apiURL += "&redirect_uri=" + redirectURI;
            apiURL += "&response_type=code";
            apiURL += "&state=" + session.getAttribute("state").toString();
            apiURL += "&scope=profile";
            apiURL += "&client_id=";
        %>
        <td>
            <a href="<%=apiURL%><spring:eval expression="@property['google.client_id']"/>">
                <img height="50" src="${pageContext.request.contextPath}/resources/image/static/btn_google_signin_dark_normal_web.png"/>
            </a>
        </td>
    </tr>
</table>
</div>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"
        integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
<script>
    // 이메일 입력값을 가져오고,
    // 입력값을 서버로 전송하고 똑같은 이메일이 있는지 체크한 후
    // 사용 가능 여부를 이메일 입력창 아래에 표시
    const emailCheck = () => {
        const email = document.getElementById("email").value;
        const checkResult = document.getElementById("check-result");
        console.log("입력한 이메일", email);
        $.ajax({
            // 요청방식: post, url: "email-check", 데이터: 이메일
            type: "post",
            url: "<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/api/member/emailCheck",
            data: {
                "email": email
            },
            success: function (res) {
                if (res == "0") {
                    console.log("사용가능한 이메일");
                    checkResult.style.color = "green";
                    checkResult.innerHTML = "사용가능한 이메일";
                } else {
                    console.log("이미 사용중인 이메일");
                    checkResult.style.color = "red";
                    checkResult.innerHTML = "이미 사용중인 이메일";
                }
            },
            error: function (err) {
                console.log("에러발생", err);
            }
        });
    }
    $('#mail-Check-Btn').click(
        function () {
            $.ajax({
                type: 'get',
                url: "<%=request.getContextPath()%>/api/member/sendRegisterEmail",
                data: {
                    "email": $('#email').val(),
                },
                success: function (res) {
                    $('.mail-check-input').attr('disabled', false);
                    code = res;
                    alert('인증번호가 전송되었습니다.');
                }
            }); // end ajax
        }); // end send eamil
    $('.mail-check-input').blur(function () {
        const inputCode = $(this).val();
        const $resultMsg = $('#mail-check-warn');
        if (inputCode === code) {
            $resultMsg.html('인증번호가 일치합니다.');
            $resultMsg.css('color', 'green');
            $('#mail-Check-Btn').attr('disabled', true);
            $('#email').attr('readonly', true);
            $('#submit').attr('disabled', false);
        } else {
            $resultMsg.html('인증번호가 불일치합니다. 다시 확인해주세요!');
            $resultMsg.css('color', 'red');
        }
    });
</script>
<%@ include file="../../layout/footer.jsp" %>