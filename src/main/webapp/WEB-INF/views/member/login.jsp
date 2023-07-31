<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
<!DOCTYPE html>
<%@ include file="../../layout/header.jsp" %>
<div class="container" style="display: flex; justify-content: center; align-items: center; margin-top: 30px; margin-bottom: 50px;">
    <div>
        <h1 style="font-size: 17px; text-align: center;">반가워요&nbsp;&nbsp;👋</h1>
        <h1 style="font-size: 17px; text-align: center;">지금 바로 나눔을 시작해보세요!</h1>
        <hr/>
        <div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
            <a class="p-2" href="https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=<spring:eval expression="@property['kakao.client_id']"/>&redirect_uri=<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/member/kakaoLogin">
                <img src="${pageContext.request.contextPath}/resources/image/icon/kakao_login.svg" width="450px"/>
            </a>
        </div>
        <%
            String redirectURI = URLEncoder.encode(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/member/naverLogin", "UTF-8");
            SecureRandom random = new SecureRandom();
            String state = new BigInteger(130, random).toString();
            String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
            apiURL += "&redirect_uri=" + redirectURI;
            apiURL += "&state=" + state;
            apiURL += "&client_id=";
            session.setAttribute("state", state);
        %>
        <div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
            <a href="<%=apiURL%><spring:eval expression="@property['naver.client_id']"/>">
                <img width="450" src="${pageContext.request.contextPath}/resources/image/icon/naver_login.svg"/>
            </a>
        </div>

        <%
            redirectURI = URLEncoder.encode(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/member/googleLogin", "UTF-8");
            apiURL = "https://accounts.google.com/o/oauth2/v2/auth?";
            apiURL += "&redirect_uri=" + redirectURI;
            apiURL += "&response_type=code";
            apiURL += "&state=" + session.getAttribute("state").toString();
            apiURL += "&scope=profile";
            apiURL += "&client_id=";
        %>

        <div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
            <a href="<%=apiURL%><spring:eval expression="@property['google.client_id']"/>">
                <img width="450" src="${pageContext.request.contextPath}/resources/image/icon/google_login.svg"/>
            </a>
        </div>

        <div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
            <img height="50" src="${pageContext.request.contextPath}/resources/image/icon/refit_start.svg"/ width="450px">
        </div>
        <form action="<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/member/loginEmail" method="post">
            <hr>
            <p>이메일<input class="form-control" type="text" name="email" placeholder="이메일"></p>
            <p>비밀번호<input class="form-control" type="password" name="password" placeholder="비밀번호"></p>
            <hr>
            <div class="d-grid gap-2 d-md-block">
                <p style="text-align: center; width: 100%;"><input class="btn btn-dark" type="submit" style="text-align: center; width: 100%;" value="로그인 하기"></p>
            </div>
        </form>
        <div style="text-align: center;">
            <button class="btn btn-outline-dark" onclick="location.href='<%=request.getContextPath()%>/member/register'" style="border-color: #000000;">회원가입</button>
            <button type="button" class="btn btn-outline-dark" onclick="findPassword()">비밀번호 찾기</button>
        </div>
    </div>
</div>


<script>
    const findPassword = () => {
        let popup = window.open("<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/member/findPasswordPopup", "비밀번호 찾기", "width=500, height=200, location=no");
    }
</script>


<%@ include file="../../layout/footer.jsp" %>