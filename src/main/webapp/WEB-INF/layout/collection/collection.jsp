<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Slick Slider CSS -->
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick-theme.min.css"/>

<!-- Slick Slider JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.js"></script>


<div class="container">
  <div class="row">
      <div class="col-sm-8">
        <table style="width: 90%; height: 300px; margin-left: auto; margin-right: auto;">
          <tr style="height: 10%; text-align: left;">
            <h1 style="font-size:18px;">🚩 근처 의류 수거함 위치가 궁금하다면?</h1>
              <div class="mb-3 d-flex justify-content-start align-items-center" >
                <input type="text" class="form-control search_btn" id="searchBox" placeholder="주소를 입력하세요" style="margin-top: 10px; width: 92%;">
                <button type="button" class="btn btn-dark" onclick="searchBinsAndCompanies()" style="margin-top: 10px;">검색</button>
              </div>
              <ul id="output"></ul>
              <div id="map" style="height: 500px;"></div>
            </td>
          </tr>
        </table>
      </div>


    <div class="col-sm-4">
        <h2 style="font-size:18px;">♻ 검색하면 주변 수거업체가 아래 나타나요</h2>
        <hr class="custom-hr"/>
        <div style="flex-direction: column; autoplay">
            <div id="resultTable2" style="width:100%; display: flex; flex-wrap: wrap;"></div>
        </div>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
    </div>
  </div>
</div>

<div style="display: flex; flex-direction: column;">
  <div id="resultTable2" style="width:100%; display: flex; flex-wrap: wrap;"></div>
</div>


<script>
  function searchBinsAndCompanies() {
    searchBins();
    searchCompanies();
  }

  function searchCompanies() {
    console.log("searchCompanies()");

    function geocodeAndRetrieveRegion() {
      var serviceLocation = document.getElementById("searchBox").value;
      var serviceLocationInput = document.getElementById("searchBox");
      var geocoder = new google.maps.Geocoder();
      var location = serviceLocationInput.value;

      geocoder.geocode({ address: location }, function (results, status) {
        if (status === google.maps.GeocoderStatus.OK && results.length > 0) {
          var formattedAddress = results[0].formatted_address;
          var addressComponents = results[0].address_components;

          var region = getRegionFromAddressComponents(addressComponents);

          console.log("입력된 위치: " + formattedAddress);

          var serviceLocation = region.substr(0, 2);
          console.log("지역구: " + serviceLocation);

          $.ajax({
            url: "<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/collection/search",
            method: "GET",
            data: { serviceLocation: serviceLocation },
            success: function (response) {
              console.log(response);
              var resultTable = document.getElementById("resultTable2");
              resultTable.innerHTML = "";
              response.forEach(function (company, index) {
                var cardContainer = document.createElement("div");
                cardContainer.classList.add("card");
                cardContainer.style.width = "430px";
                cardContainer.style.width = "18rem";
                cardContainer.style.height = "380px";
                cardContainer.style.marginRight = "30px";
                cardContainer.style.marginBottom = "30px";

                var thumbnailLink  = document.createElement("a");
                thumbnailLink.href = "/campaign/"+company.campaign_id;

                var contextPath = "<%=request.getContextPath()%>";
                var thumbnail = document.createElement("img");
                thumbnail.src = contextPath + "/resources/image/thumbnail/" + company.thumbnail_file;
                thumbnail.alt = "...";
                thumbnail.style.width = "100%";
                thumbnail.height = 280;
                thumbnail.style.height = "10rem";
                thumbnail.style.objectFit = "cover"
                thumbnailLink.appendChild(thumbnail);
                cardContainer.appendChild(thumbnailLink);

                var cardBody = document.createElement("div");
                cardBody.classList.add("card-body");

                var campaignCompany = document.createElement("p");
                campaignCompany.className = "card-text";
                campaignCompany.style.fontSize = "11px";
                campaignCompany.textContent = "업체명: " + company.campaign_company;
                cardBody.appendChild(campaignCompany);

                var campaignName = document.createElement("p");
                campaignName.className = "card-text";
                campaignName.textContent = company.campaign_name;
                cardBody.appendChild(campaignName);

                var conditions = document.createElement("p");
                conditions.className = "card-text";
                conditions.style.fontSize = "13px";
                conditions.textContent = "수거 조건 : " + company.conditions;
                cardBody.appendChild(conditions);

                var campaignAreaLabel = document.createElement("p");
                campaignAreaLabel.className = "card-text";
                campaignAreaLabel.style.fontSize = "13px";
                campaignAreaLabel.style.lineHeight = "1";

                var areaBadge = document.createElement("span");
                areaBadge.className = "badge text-bg-dark";
                areaBadge.textContent = "수거 지역 ";

                campaignAreaLabel.appendChild(areaBadge);

                var areaText=document.createTextNode(company.campaign_area);

                campaignAreaLabel.appendChild(areaText);

                cardBody.appendChild(campaignAreaLabel);

                var detailsLink=document.createElement("a");
                detailsLink.href=contextPath+"/campaign/"+company.campaign_id;
                detailsLink.className="btn btn-dark";
                detailsLink.textContent="자세히보기";

                cardBody.appendChild(detailsLink);

                cardContainer.appendChild(cardBody);

                resultTable.appendChild(cardContainer);
              });
            },

            error: function (error) {
              console.log("검색 요청에 실패했습니다.");
              console.log(error);
            }
          });
        } else {
          console.log("지오코딩에 실패하였습니다.");
        }
      });
    }

    function getRegionFromAddressComponents(addressComponents) {
      for (var i = 0; i < addressComponents.length; i++) {
        var component = addressComponents[i];
        var types = component.types;
        if (types.includes("administrative_area_level_1")) {
          return component.long_name;
        }
      }

      return null;
    }

    geocodeAndRetrieveRegion();
  }

</script>


<style>
  .custom-hr {
    width: 100%; /* 원하는 길이로 조절할 수 있습니다 */
    margin-left: auto;
    margin-right: auto;
  }
</style>

<!--버튼 클릭 조정-->
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