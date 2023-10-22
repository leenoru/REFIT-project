<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
    <%@ include file="../../layout/header.jsp" %>
    <title>AI 캠페인 매칭완료</title>

    <!-- Slick CSS -->
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css" />
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css" />

    <!-- slide CSS -->
    <style>
        .slick-slide {
            width: 100%;
            height: 500px;
        }

        .card {
            min-width: 280px;
            max-width: 280px;
            min-height: 390px;
            max-height: 390px;
            margin: 10px;
        }
    </style>


<div class="container" style="margin-top: 50px;">
    <div class="container col-md-10">
        <h1 style="font-size:20px; text-align: center;">🦾 매칭 완료!</h1>
        <h2 style="font-size:20px; text-align: center;">매칭된 캠페인을 확인해보세요</h2>
        <br>
        <div style="text-align: center;">
            💞 매칭된 카테고리 :
            <c:forEach var="item" items="${clothingSubcategories}" varStatus="loop">
                ${item}<c:if test="${not loop.last}">, </c:if>
            </c:forEach>
        </div>
        <br>
        <br>
        <h2 style="font-size:17px;">[🎁 리워드형] 참여하고 혜택 받기</h2>
        <hr/>
        <div id="reward-carousel" class="carousel slide" data-bs-ride="carousel">
            <!-- 슬라이드 표시 영역 -->
            <div class="carousel-inner" role="listbox">
                <div class="carousel-item active">
                    <div class="d-flex justify-content-flex-start autoplay">
                        <c:forEach var="item" items="${matchingRewardList}" varStatus="loop">
                            <div class="card" style="width: 18rem; float:left; margin-right:30px; margin-bottom:30px;">
                                <a href="${pageContext.request.contextPath}/campaign/${item.campaign_id}">
                                    <img src="${pageContext.request.contextPath}/resources/image/thumbnail/${item.thumbnail_file}" class="card-img-top" alt="...">
                                </a>
                                <div class="card-body">
                                    <p class="card-text" style="font-size:11px;">리핏 x ${item.campaign_company}</p>
                                    <p class="card-text">${item.campaign_name}</p>
                                    <div class="card-text">
                                        <p style="font-size:14px;">
                                            기간 :
                                            <span id="formattedStartDate" style="font-size:13px;">${item.campaign_start_date.split(' ')[0]}</span>
                                            ~
                                            <span id="formattedEndDate" style="font-size:13px;">${item.campaign_end_date.split(' ')[0]}</span>
                                        </p>
                                    </div>
                                    <p class="card-text" style="font-size:13px; line-height : 1;">
                                        <span class="badge text-bg-dark">REWARD</span> ${item.campaign_reward}
                                    </p>
                                    <a href="${pageContext.request.contextPath}/campaign/${item.campaign_id}" class="btn btn-dark">자세히보기</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container" style="margin-top: 50px;">
    <div class="container col-md-10">
        <h2 style="font-size:17px;">[💰 수익형] 매입 업체 찾고 용돈 벌기</h2>
        <hr/>
        <div id="profit-carousel" class="carousel slide" data-bs-ride="carousel">
            <!-- 슬라이드 표시 영역 -->
            <div class="carousel-inner" role="listbox">
                <div class="carousel-item active">
                    <div class="d-flex justify-content-flex-start autoplay">
                        <c:forEach var="item" items="${matchingProfitList}" varStatus="loop">
                            <div class="card" style="width: 18rem; float:left; margin-right:30px; margin-bottom:30px;">
                                <a href="${pageContext.request.contextPath}/campaign/${item.campaign_id}">
                                    <img src="${pageContext.request.contextPath}/resources/image/thumbnail/${item.thumbnail_file}" class="card-img-top" alt="...">
                                </a>
                                <div class="card-body">
                                    <p class="card-text" style="font-size:11px;">리핏 x ${item.campaign_company}</p>
                                    <p class="card-text">${item.campaign_name}</p>
                                    <p class="card-text" style="font-size:13px;">수거 조건 : ${item.conditions}</p>
                                    <p class="card-text" style="font-size:13px; line-height : 1;">
                                        <span class="badge text-bg-dark">수거 지역</span> ${item.campaign_area}
                                    </p>
                                    <a href="${pageContext.request.contextPath}/campaign/${item.campaign_id}" class="btn btn-dark">자세히보기</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<div class="container" style="margin-top: 50px;">
    <div class="container col-md-10">
        <h2 style="font-size:17px;">[💌 소득공제형] 기부하고 소득공제 받기</h2>
        <hr/>
        <div id="donation-carousel" class="carousel slide" data-bs-ride="carousel">
            <!-- 슬라이드 표시 영역 -->
            <div class="carousel-inner" role="listbox">
                <div class="carousel-item active">
                    <div class="d-flex justify-content-flex-start autoplay">
                        <c:forEach var="item" items="${matchingDonationList}" varStatus="loop">
                            <div class="card" style="width: 18rem; float:left; margin-right:30px; margin-bottom:30px;">
                                <a href="${pageContext.request.contextPath}/campaign/${item.campaign_id}">
                                    <img src="${pageContext.request.contextPath}/resources/image/thumbnail/${item.thumbnail_file}" class="card-img-top" alt="...">
                                </a>
                                <div class="card-body">
                                    <p class="card-text" style="font-size:11px;">리핏 x ${item.campaign_company}</p>
                                    <p class="card-text">${item.campaign_name}</p>
                                    <div class="card-text">
                                        <p style="font-size:13px;">기간 :
                                            <span id="formattedStartDate" style="font-size:13px;">${item.campaign_start_date.split(' ')[0]}</span>
                                            ~
                                            <span id="formattedEndDate" style="font-size:13px;">${item.campaign_end_date.split(' ')[0]}</span>
                                        </p>
                                    </div>
                                    <p class="card-text" style="font-size:13px; line-height : 1;">
                                        <span class="badge text-bg-dark">REWARD</span> ${item.campaign_reward}
                                    </p>
                                    <a href="${pageContext.request.contextPath}/campaign/${item.campaign_id}" class="btn btn-dark">자세히보기</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
    <br>
    <br>
    <br>
    <br>


<!-- Slick Slider CSS -->
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick-theme.min.css"/>

<!-- Slick Slider JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

<!-- slide JS-->
<script>
    // .autoplay 클래스를 가진 요소에 slick 슬라이더를 적용
    $(document).ready(function() {
        $('.autoplay').slick({
            infinite: false, //슬라이더가 끝에 도달하면 다시 시작할지 여부
            slidesToShow: 1, // 한 번에 표시할 슬라이드 수
            slidesToScroll: 1, // 한 번에 스크롤할 슬라이드 수
            autoplay: false, // 슬라이더가 자동으로 재생될지 여부를 설정
            variableWidth: true // 각 슬라이드의 너비가 다를 수 있도록 설정
        });
    });
</script>

<%@ include file="../../layout/footer.jsp" %>
