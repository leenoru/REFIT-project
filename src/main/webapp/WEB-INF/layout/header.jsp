<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>REFIT</title>
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
          rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
          crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz"
            crossorigin="anonymous"></script>
    <!-- jquery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- dropdown -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>


    <script>
        $(document).ready(function () {
            // 드롭다운 초기화
            $('.dropdown-toggle').dropdown();
        });
    </script>
    <script defer src="<%=request.getContextPath()%>/resources/js/index.js"></script>
    <script
            defer
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDz29rjsZ-ikW1gU2dO9VG62qMHW1UtbgI&callback=initMap"
    ></script>

    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Bootstrap core CSS -->
    <!--link href="<%=request.getContextPath()%>/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet"-->

    <!-- Custom styles for this template -->
    <link href="<%=request.getContextPath()%>/resources/css/shop-homepage.css" rel="stylesheet">

    <!-- favicon_logo -->
    <link rel="icon" href="${pageContext.request.contextPath}/resources/image/icon/favicon_log.png" type="image/x-icon">
</head>

<body>
<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top">
  <div class="container">
    <a class="navbar-brand" href="<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>" style="color: #000000;">
      <img src="${pageContext.request.contextPath}/resources/image/icon/refit_logo_sharp.svg" alt="Logo" width="80" height="18" class="d-inline-block align-text-top" style="margin-top: 4.8px;">
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarScroll"
            aria-controls="navbarScroll" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarScroll">
      <ul class="navbar-nav me-auto my-2 my-lg-0 navbar-nav-scroll" style="--bs-scroll-height: 100px;">
        <li class="nav-item">
          <a class="nav-link" aria-current="page" onclick="location.href='<%=request.getContextPath()%>/campaign/AI'" style="color: #000000;">
            <span class="underline-hover">AI 캠페인 매칭</span>
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" onclick="location.href='<%=request.getContextPath()%>/share/index'" style="color: #000000;">
            <span class="underline-hover">의류 나눔 게시판</span>
          </a>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-expanded="false" style="color: #000000;">
            <span class="underline-hover">캠페인 리스트</span>
          </a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campaign/reward" style="color: #000000;">리워드형</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campaign/donation" style="color: #000000;">기부형</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campaign/profit" style="color: #000000;">수익형</a></li>
          </ul>
        </li>
        <li class="nav-item">
          <a class="nav-link" onclick="location.href='<%=request.getContextPath()%>/collection'" style="color: #000000;">
            <span class="underline-hover">근처 의류 수거함 찾기</span>
          </a>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-expanded="false" style="color: #000000;">
            <span class="underline-hover">🛠 관리자기능</span>
          </a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campaign/write" style="color: #000000;">캠페인 등록</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campaign/donation" style="color: #000000;">캠페인 관리</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campaign/profit" style="color: #000000;">회원 관리</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campaign/profit" style="color: #000000;">메인배너 관리</a></li>
          </ul>
        </li>
      </ul>

      <c:if test="${sessionScope.nickname==null}">
          <a href="<%=request.getContextPath()%>/member/login" class="btn btn-outline-success" style="border-color: #000000; color: #000000; text-decoration: none;" onmouseover="this.style.backgroundColor='#000000'; this.style.color='#FFFFFF';"
                                                                                                                                                                         onmouseout="this.style.backgroundColor=''; this.style.color='#000000';">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16" style="margin-top: -4.5px;">
                  <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
                  <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
              </svg>
              로그인
          </a>
      </c:if>
      <c:if test="${sessionScope.nickname!=null}">
        <button class="btn btn-dark" onclick="location.href='<%=request.getContextPath()%>/member/profile'" >마이페이지</button>
        <button class="btn btn-outline-dark" onclick="location.href='<%=request.getContextPath()%>/member/logout'" >로그아웃</button>
      </c:if>
    </div>
  </div>
  <hr/>
</nav>


<style>
.underline-hover {
  position: relative;
  text-decoration: none;
  color: #000000;
}

.underline-hover::after {
  content: "";
  position: absolute;
  left: 0;
  bottom: -5px; /* 조정할 높이값 설정 */
  width: 100%;
  height: 1px; /* 조정할 높이값 설정 */
  background-color: #000000;
  transform: scaleX(0);
  transition: transform 0.2s ease-in-out;
}

.underline-hover:hover::after {
  transform: scaleX(1);
}
</style>





