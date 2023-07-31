<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<%@ include file="../../layout/header.jsp" %>

<title>AI 매칭시작</title>

<div class="container" style="margin-top:50px;">
    <div class="container col-md-8">
        <div class="row">
            <h1 style="font-size:18px;">📸 AI매칭 받을 옷 사진을 올려주세요!</h1>
            <hr/>
            <div class="image-preview-container autoplay">
              <!-- 이미지 카드가 여기에 동적으로 추가됩니다 -->
            </div>
            <br>
            <br>
            <span class="placeholder-text" style="visibility: visible; text-align: center;">사진을 올리면 AI가 매칭해드려요😊</span>
            <br>
            <br>
            <br>
            <hr/>
            <br>
            <form id="uploadForm" method="post" enctype="multipart/form-data" action="<%=request.getContextPath()%>/doMatching">
              <div class="file-input-wrapper">
                <button type="button" id="upload_file" class="btn btn-outline-dark upload_btn" onclick="$('#upload').click()">
                  사진 올리고 AI매칭 받기
                </button>
                <input type="file" class="upload file-upload-button" id="upload" name="upload" accept="image/*" required multiple>
              </div>
              <input type="button" value="결과 보기" id="matching_btn" class="btn btn-dark submit_btn">
            </form>
        </div>
    </div>
<div>

<style>
  .file-input-wrapper {
    position: relative;
    display: inline-block;
  }

  .file-upload-button {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    opacity: 0;
    cursor: pointer;
  }
</style>

<style>
    .slick-slide {
      display: flex;
    }
</style>

<!--버튼 클릭 조정-->
<style>
  .upload_btn {
    display: block;
    width: 824px;
    margin-top: 2rem;
  }

 .file-input-wrapper {
    display: block;
    width: 824px;
    margin-top: 2rem;
  }

  .submit_btn {
    display: block;
    width: 824px;
    margin-top: 2rem;
  }

  @media (max-width: 768px) {
    .upload_btn{
      width: 100%;
      margin-top: 1rem;
    }
  }

  @media (max-width: 768px) {
    .file-input-wrapper,
    .submit_btn {
      width: 100%;
      margin-top: 1rem;
    }
  }
</style>

<!-- Slick Slider CSS -->
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick-theme.min.css"/>


<!-- Slick Slider JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.js"></script>


<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

<script>
let subCategories = ""; // subCategories 변수를 전역 변수로 선언합니다.

  function getImageFiles(e) {
    const placeholderText = document.querySelector(".placeholder-text");
    if (e.currentTarget.files.length > 0) {
      $(".autoplay").slick("unslick");
      placeholderText.style.visibility = "hidden";
    } else {
      placeholderText.style.visibility = "visible";
    }

    // 이미지 파일이 로드되는 것을 기다리기 위한 Promise 들을 담는 배열
    const promises = [];

    Array.from(e.currentTarget.files).forEach((file) => {
      if (!file.type.match("image/.*")) {
        alert("이미지 파일만 업로드 가능합니다.");
        return;
      }
      const reader = new FileReader();

      // 이미지가 로드되면 리졸브하는 프로미스를 합니다.
      promises.push(loadImage(reader, file));

      reader.readAsDataURL(file);
    });

    // 모든 이미지 파일이 로드되면 슬라이더 초기화
    Promise.all(promises).then(() => {
      initSlickSlider();
      subCategory();
    });
  }

  document.getElementById("upload").addEventListener("change", getImageFiles);
  document.querySelector("#uploadForm").addEventListener("submit", handleSubmit);

  // 슬라이드 초기화
  function initSlickSlider() {
    $(".autoplay").slick({
      infinite: false,
      slidesToShow: 1,
      slidesToScroll: 1,
      autoplay: false,
      variableWidth: true,
    });
  }

  function handleSubmit(event) {
    event.preventDefault(); // 기존 이벤트를 중단
    doMatching();
  }

  function doMatching(event) {
    let imageInput = $("#upload")[0];
    let formData = new FormData();
    formData.append("images", imageInput.files[0]);

    for (let i = 0; i < imageInput.files.length; i++) {
      formData.append("images[]", imageInput.files[i]);
    }

    $.ajax({
      type: "POST",
      url: "<%=request.getContextPath()%>/api/campaign/doMatching",
      data: formData,
      processData: false,
      contentType: false,
      success: function (response) {
        handleResponse(response);
      },
    });
  }

  function createCardElement(e, file, category) {
    const card = document.createElement("div");
    card.className = "card";
    card.style.width = "200px";
    card.style.height = "280px";
    card.style.margin = "1px";

    const img = document.createElement("img");
    img.className = "card-img-top";
    img.src = e.target.result;
    img.alt = "Uploaded Image";
    img.style.maxWidth = "200px";
    img.style.minWidth = "200px";
    img.style.maxHeight = "200px";
    img.style.minHeight = "200px";
    img.style.borderRadius = "10px"; // 모서리 둥글게
    card.appendChild(img);

    const cardBody = document.createElement("div");
    cardBody.className = "card-body";
    card.appendChild(cardBody);

    const cardTitle = document.createElement("h8");
    cardTitle.className = "card-title";
    cardTitle.style.fontSize = "14px";
    cardBody.appendChild(cardTitle);

    return card;
  }

  function loadImage(reader, file) {
    return new Promise((resolve) => {
      reader.onload = (e) => {
        const imagePreview = document.querySelector(".image-preview-container");
        const category = "예시 카테고리";
        const cardElement = createCardElement(e, file, category);
        imagePreview.appendChild(cardElement);
        resolve();
      };
    });
  }

  function handleResponse(response) {
    console.log(response);
  }

  initSlickSlider();

  function subCategory (event) {
      alert("💘 매칭 시작! 잠시만 기다려주세요");
      subCategories = ""; // subCategories 변수의 값을 초기화합니다.
      let count = 0;

      let alertShown = false; // alert가 표시되었는지 여부를 저장하는 변수

      $("img.card-img-top").each(async function () {
        var src = $(this).prop("src"); //Example
        response = await axios({
          method: "post", // 백엔드 호출 방식 get, post
          url: "/api/campaign/doMatching", // 백엔드 컨트롤러의 url
          data: { img_data: src }, //백엔드로 전송 할 메시지
          headers: { "Content-Type": "image/jpeg" }, //백엔드로 전송할 이미지 타입
        });
        if (response.data != null) {
          if (!alertShown) {
            // alert가 표시되지 않았다면
            alert("매칭이 완료되었습니다😊");
            alertShown = true; // alert가 표시되었음을 저장
          }

          const htmlString =
            "대분류: " +
            response.data.efficientnet_category +
            "<p>" +
            "소분류: " +
            response.data.resnet_category;
          $(this).siblings().html(htmlString);

          // subCategories 변수의 값을 설정합니다.
          if (count === 0) {
            subCategories += response.data.resnet_category;
          } else {
            subCategories += "," + response.data.resnet_category;
          }
          count++;
        }
      });
    }
</script>

<script>
$("#matching_btn").click(function (event) {
  // matching_btn 버튼 클릭 이벤트에서 설정한 subCategories 변수의 값을 전달합니다.
  axios
    .get("<%=request.getContextPath()%>/campaign/AI/doMatching", {
      params: {
        subCategories: subCategories,
      },
    })
    .then((response) => {
      // 응답 데이터에서 각 타입별 정렬된 캠페인 목록을 가져옴
      const matchingRewardList = response.data.matchingRewardList;
      const matchingProfitList = response.data.matchingProfitList;
      const matchingDonationList = response.data.matchingDonationList;

      // /campaign/AI/doMatching 엔드포인트로 리다이렉트
      window.location.href =
        "<%=request.getContextPath()%>/campaign/AI/doMatching?subCategories=" +
        subCategories;
    })
    .catch((error) => {
      console.error(error);
    });
});
</script>

<%@ include file="../../layout/footer.jsp" %>
