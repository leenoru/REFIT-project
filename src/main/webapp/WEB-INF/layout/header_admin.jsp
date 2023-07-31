<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

    <!-- jquery -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>


    <!-- dropdown -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function () {
            // 드롭다운 초기화
            $('.dropdown-toggle').dropdown();
        });
    </script>
    <script defer src="/resources/js/index.js"></script>
    <script
            defer
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAYTFj2b7yNbkyC3aA0PfzY0ifaeY7jswM&callback=initMap"
    ></script>

    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Bootstrap core CSS -->
    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="/resources/css/shop-homepage.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="/">REFIT</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarScroll"
                aria-controls="navbarScroll" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarScroll">
            <ul class="navbar-nav me-auto my-2 my-lg-0 navbar-nav-scroll" style="--bs-scroll-height: 100px;">
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page"
                       onclick="location.href='<%=request.getContextPath()%>/campaign/AI'">AI 캠페인 매칭</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" onclick="location.href='<%=request.getContextPath()%>/share/index'">의류 나눔
                        게시판</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button"
                       aria-expanded="false">기부 캠페인 리스트</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campaign/reward">리워드형</a>
                        </li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campaign/donation">기부형</a>
                        </li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campaign/profit">수익형</a>
                        </li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link" onclick="location.href='<%=request.getContextPath()%>/collection'">근처 의류 수거함
                        찾기</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button"
                       aria-expanded="false">관리자 기능</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campaign/write">캠페인 등록</a>
                        </li>
                    </ul>
                </li>
            </ul>
            <c:if test="${sessionScope.nickname==null}">
                <button class="btn btn-outline-success"
                        onclick="location.href='<%=request.getContextPath()%>/member/login'">로그인
                </button>
                <button class="btn btn-outline-success"
                        onclick="location.href='<%=request.getContextPath()%>/member/register'">회원가입
                </button>
            </c:if>
            <c:if test="${sessionScope.nickname!=null}">
                <button class="btn btn-outline-success"
                        onclick="location.href='<%=request.getContextPath()%>/member/profile'">마이페이지
                </button>
                <button class="btn btn-outline-success"
                        onclick="location.href='<%=request.getContextPath()%>/member/logout'">로그아웃
                </button>
            </c:if>
        </div>
    </div>
</nav>
