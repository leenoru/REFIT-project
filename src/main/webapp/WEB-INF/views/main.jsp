<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<%@ include file="../layout/header.jsp" %>

<!-- Carousel -->
<div class="container">
    <div class="container container col-md-10">
        <div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel">
            <ol class="carousel-indicators">
                <!-- 인디케이터 버튼 -->
            </ol>
            <div class="carousel-inner">
                <!-- 동적으로 생성되는 캐러셀 아이템 -->
            </div>
            <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </a>
            <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </a>
        </div>
        <p style="text-align: center; margin-top: 30px;" >🤔 캠페인이 너무 많아서 고민이라면?</p>
        <div style="text-align: center;">
            <a href="<%=request.getContextPath()%>/campaign/AI"><button type="button" class="btn btn-outline-dark" style="width:26%">지금 바로 AI 매칭 시작하기</button></a>
        </div>
    </div>
</div>


<style>
.carousel-item img {
  min-height: 400px; /* 이미지의 최소 높이를 500px로 지정 */
  max-height: 400px; /* 이미지의 최대 높이를 500px로 지정 */
}
</style>


<!-- 게시판 영역 -->

<div class="container" style="margin-top: 50px;">
    <div class="container container col-md-10">
        <div class="row">
            <div class="col-md-6">
                <h1 class="text-center" style="font-size: 20px; display: inline;">🔥 현재 진행중인 나눔</h1>
                &nbsp;
                <a href="<%=request.getContextPath()%>/share/index" class="btn btn-dark" style="width: 80px; padding-top: 1px; padding-bottom: 1px; display: inline; font-size: 14px; line-height: 16px; position: relative; top: -2px;" onmouseover="addButtonShadow(this);" onmouseout="removeButtonShadow(this);">더보러가기</a>
            </div>
        </div>
        <br>
        <div class="row justify-content-center">
            <c:forEach var="item" items="${MainShareList}" varStatus="status">
                <c:if test="${status.index % 4 == 0 and not status.first}">
                    </div><div class="row justify-content-center">
                </c:if>
                <div class="col-md-auto mb-3 d-flex">
                    <div class="image-container" onmouseover="moveImageUp(event)" onmouseout="resetImagePosition(event)">
                        <a href="<%=request.getContextPath()%>/share/posts/view/${item.id}">
                            <img src="${item.imageText2[0]}" alt="" style="width: 245px; height: 245px; border-radius: 5%;">
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

 <style>
   .image-container {
     transition: transform 0.2s ease-in-out;
   }
 </style>

 <script>

   function moveImageUp(event) {
     var image = event.currentTarget;
     image.style.transform = "translateY(-5px)";
   }

   function resetImagePosition(event) {
     var image = event.currentTarget;
     image.style.transform = "translateY(0)";
   }

   function addButtonShadow(element) {
       element.style.boxShadow = "0 2px 6px rgba(0, 0, 0, 0.5)";
     }

     function removeButtonShadow(element) {
       element.style.boxShadow = "none";
     }
 </script>

<!-- 지도 영역 -->
<div class="container" style="margin-top:50px;">
    <div class="container container col-md-10">
              <h2 style="font-size:18px;">🚩 근처 의류 수거함 위치가 궁금하다면?</h2>
        <div style="display: flex; justify-content: center;">
          <table style="width: 100%;">
            <tr>
              <td>
                <div class="mb-3 d-flex justify-content-start align-items-center">
                  <input type="text" class="form-control search_btn" id="searchBox" placeholder="주소를 입력하세요" style="display: flex; justify-content: start; max-width:300px">
                  <button type="button" class="btn btn-dark" onclick="searchBins()" style="height: 80%;">검색</button>
                </div>
                <ul id="output"></ul>
                <div id="map" style="height: 400px; margin-bottom: 20px;"></div>
              </td>
            </tr>
          </table>
        </div>
    </div>
</div>

<style>
  .search_btn {
    display: block;
    width: 70%;
  }

  @media (max-width: 768px) {
    .search_btn{
      width: 100%;
      margin-top: 1rem;
    }
  }

  /* 지도와 카드 간격 조정 */
  #map {
    margin-bottom: -16rem; /* 간격을 줄이거나 조절하려면 이 값을 변경하세요 */
  }
</style>

<!-- 푸터 영역 -->
<br>
<br>
<footer>
  <div class="container">
    <div style="display: flex; align-items: center; justify-content: center;">
      <span>Copyright © REFIT
      <script>document.write(new Date().getFullYear());</script>. All Rights Reserved.</span>
    </div>
  </div>
</footer>


<style>
footer {
  bottom: 0;
  width: 100%;
  height: 150px;
  background-color: #333;
  color: white;
  padding: 20px;
  text-align: center;
  line-height: 110px;
}
</style>


<script>
  $.ajax({
    url: "<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/banner/info",
    method: "GET",
    success: function (response) {
    console.log(response);
      var carouselInner = document.querySelector(".carousel-inner");
      carouselInner.innerHTML = "";

      var carouselIndicators = document.querySelector(".carousel-indicators");
      carouselIndicators.innerHTML = "";

      response.forEach(function (banner, index) {
        var carouselItem = document.createElement("div");
        carouselItem.classList.add("carousel-item");

        if (index === 0) {
          carouselItem.classList.add("active");
        }

        var img = document.createElement("img");
        img.src = "${pageContext.request.contextPath}/resources/image/banner/" + banner.banner_photo;
        img.classList.add("d-block");
        img.classList.add("w-100");
        img.alt = "Banner Image";
        img.style.objectFit = "cover";
        img.style.width = "100%";
        img.style.height = "100%";

        img.addEventListener("click", function() {
          window.location.href = banner.campaign_url;
        });

        var indicatorButton = document.createElement("button");
        indicatorButton.setAttribute("type", "button");
        indicatorButton.setAttribute("data-bs-target", "#carouselExampleIndicators");
        indicatorButton.setAttribute("data-bs-slide-to", index.toString());

        if (index === 0) {
          indicatorButton.classList.add("active");
          indicatorButton.setAttribute("aria-current", "true");
        }

        carouselItem.appendChild(img);
        carouselInner.appendChild(carouselItem);
        carouselIndicators.appendChild(indicatorButton);
      });

      var carousel = new bootstrap.Carousel(document.querySelector("#carouselExampleIndicators"), {
        interval: 5000 // 이미지 전환 간격 (5초)
      });
    },
    error: function (error) {
      console.log("배너 정보를 가져오는 데 실패했습니다.");
      console.log(error);
    }
  });
</script>

<%@ include file="../layout/footer.jsp" %>