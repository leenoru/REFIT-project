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

<!-- axios -->
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

<script>
  let subCategories = ""; // subCategories 변수(AI가 예측한 카테고리)를 전역 변수로 선언

  // upload 요소에 값이 변경될 때 발생하는 이벤트로 getImageFiles() 함수를 호출
  document.getElementById("upload").addEventListener("change", getImageFiles);

  // 이미지 파일을 업로드하고 슬라이더를 초기화 하는 함수
  function getImageFiles(e) {
    // 사진을 올리면 AI가 매칭해드려요 문구 노출 여부 결정
    // .placeholder-text 클래스 요소 선택
    const placeholderText = document.querySelector(".placeholder-text");
    //  이벤트가 발생한 요소의 files 속성 길이가 0보다 큰지 확인
    if (e.currentTarget.files.length > 0) {
      // 파일 업로드 감지 시 슬라이더를 비활성화(파일이 업로드되는 동안 슬라이드가 정상적으로 동작하지 않을 수 있기 때문)
      $(".autoplay").slick("unslick");
      //  Placeholder 텍스트 숨김
      placeholderText.style.visibility = "hidden";
    } else {
      // 사진을 올리면 AI가 매칭해드려요 문구 노출
      placeholderText.style.visibility = "visible";
    }

    // 이미지 파일이 로드되는 것을 기다리기 위한 Promise 들을 담는 배열
    // Promise : 자바스크립트 비동기 사용 객체, 특정 코드의 실행이 완료되면 다음 코드를 실행되도록 처리해 줌
    const promises = [];
    // Array.from() :  iterable 객체에서 새 배열을 생성하는 메서드 (e.currentTarget.files(파일 목록) 배열은 iterable 객체)
    Array.from(e.currentTarget.files).forEach((file) => {
      // 파일을 하나씩 순회하며 이미지 파일이 아니면 경고 메시지를 표시
      if (!file.type.match("image/.*")) {
        alert("이미지 파일만 업로드 가능합니다.");
        return;
      }
      // FileReader 객체를 생성
      const reader = new FileReader();

      // 이미지 파일이면 promises 배열에 추가(loadImage() 함수의 결과를 promises 배열에 추가)
      promises.push(loadImage(reader, file));

      // reader 객체를 사용하여 파일을 읽음
      reader.readAsDataURL(file);
    });

    // 모든 이미지 파일이 로드 완료(all)되면 then() 메서드를 통해 슬라이더 초기화
    // subCategory() : 매칭된 카테고리 정보 가져오기
    // Promise.all(promises) 여러 프로미스를 병렬로 실행하고, 모든 프로미스가 리졸브되면 결과를 배열로 반환
    Promise.all(promises).then(() => {
      // Slick 슬라이더를 초기화하는 함수
      initSlickSlider();
      // 서브 카테고리 정보를 가져오는 함수
      subCategory();
      // 슬라이더를 초기화
      initSlickSlider();
    });
  }

  // 파일을 읽고 이미지 미리보기(카드) 생성(reader : FileReader, file : 읽을 파일)
  function loadImage(reader, file) {
    // 아래 작업 완료 시 Promise 객체를 반환
    return new Promise((resolve) => {
      reader.onload = (e) => {
        const imagePreview = document.querySelector(".image-preview-container");
        const category = "예시 카테고리";
        // createCardElement() 이미지 카드 요소를 생성(이벤트, 이미지 파일, 카테고리)
        const cardElement = createCardElement(e, file, category);
        // 이미지 미리보기 요소에 이미지 카드 요소 추가
        imagePreview.appendChild(cardElement);
        // Promise 객체의 resolve() 메서드가 호출
        resolve();
      };
    });
  }

  // 이미지 카드 생성 함수
  function createCardElement(e, file, category) {
    // card 클래스 추가
    const card = document.createElement("div");
    card.className = "card";
    card.style.width = "200px";
    card.style.height = "280px";
    card.style.margin = "1px";
    // img 요소 추가
    const img = document.createElement("img");
    img.className = "card-img-top";
    // e.target.result : FileReader 객체의 onload 이벤트(e)에서 요소(target)의 파일 내용을 Base64 인코딩된 형태(result)로 얻음
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

    // 카드 바디에 타이틀 추가
    const cardTitle = document.createElement("h8");
    cardTitle.className = "card-title";
    cardTitle.style.fontSize = "14px";
    cardBody.appendChild(cardTitle);

    return card;
    /* 아래의 형식과 같이 동적으로 카드 추가
        <div class="card">
          <img class="card-img-top" src="data:image/jpeg;base64,..." alt="Uploaded Image">
          <div class="card-body">
            <h8 class="card-title">...</h8>
          </div>
        </div>
    */
  }

  // slick 플러그인을 사용하여 슬라이드 초기화
  function initSlickSlider() {
    // .autoplay 클래스가 있는 요소에 slick 플러그인을 적용
    $(".autoplay").slick({
      // 슬라이더의 끝에서 끝으로 이동할 수 있는지 여부
      infinite: false,
      // 한 번에 표시할 슬라이드의 수
      slidesToShow: 1,
      // 한 번에 스크롤할 슬라이드의 수
      slidesToScroll: 1,
      // 슬라이더가 자동으로 재생되는지 여부
      autoplay: false,
      // 슬라이드의 너비가 동적으로 변경될 수 있는지 여부
      variableWidth: true,
    });
  }

  function subCategory (event) {
      alert("💘 매칭 시작! 잠시만 기다려주세요");
      subCategories = ""; // 카테고리 소분류가 담길 변수
      let count = 0;

      let alertShown = false; // alert가 표시되었는지 여부를 저장하는 변수(false : alert가 표시되지 않음)

      // 이미지 카드 함수에서 생성되었던 img 요소의 card-img-top 클래스의 모든 이미지 요소 src 순회
      // each() : 선택된 요소를 하나씩 반복
      // async function () : 비동기 함수로 함수가 완료될 때까지 다음 요소로 넘어가지 않음(await 키워드를 사용하여 비동기 작업을 실행)
      $("img.card-img-top").each(async function () {
        // src 변수에 이미지 요소의 src 속성 값(카드 생성 때 Base64 인코딩된 형태(result)로 얻었던)을 저장
        // prop() : 속성 값 반환 함수
        var src = $(this).prop("src");
        // axios 라이브러리를 사용하여 백엔드 서버에 이미지 파일을 전송
        response = await axios({
          method: "post", // 백엔드 호출 방식
          url: "/api/campaign/doMatching", // 백엔드 컨트롤러의 url
          data: { img_data: src }, //백엔드로 전송 할 메시지
          headers: { "Content-Type": "image/jpeg" }, //백엔드로 전송할 이미지 타입
        });
        // 백엔드 서버에서 응답을 수신(응답 데이터가 유효하면)
        if (response.data != null) {
          // alert가 표시되지 않았다면
          if (!alertShown) {
            alert("매칭이 완료되었습니다😊");
            alertShown = true; // alert가 표시되었음을 저장
          }

          // 대분류와 소분류 응답을 보여줄 HTML 문자열을 생성
          const htmlString =
            "대분류: " +
            response.data.efficientnet_category +
            "<p>" +
            "소분류: " +
            response.data.resnet_category;

          // 이미지 요소의 형제 요소에 HTML 문자열을 설정
          /* this :현재 이벤트(event)를 발생시킨 요소(img)
           siblings() : 선택한 요소의 형제 요소(div class=card-body)를 반환
           html(): 선택 요소의 HTML 텍스트를 설정(대분류와 소분류 삽입) */
          $(this).siblings().html(htmlString);

          // 소분류를 subCategories 변수에 추가
          if (count === 0) {
            subCategories += response.data.resnet_category;
          } else {
            subCategories += "," + response.data.resnet_category;
          }
          count++;
        }
      });
    }

/* 기존 파일 업로드 방식
  // uploadForm 요소의 submit 이벤트가 발생하면 폼을 처리
  document.querySelector("#uploadForm").addEventListener("submit", handleSubmit);

  // handleSubmit(event) : submit 이벤트를 처리하는 함수
  function handleSubmit(event) {
    // 폼이 서버로 전송되는 것을 방지(doMatching()을 호출하기 위함)
    event.preventDefault();
    // 매칭을 수행하는 함수를 호출
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


  function handleResponse(response) {
    console.log(response);
  }
*/
  // 슬라이더를 초기화
  initSlickSlider();
</script>

<script>
    // matching_btn(결과보기) 버튼 클릭 이벤트에서 subCategories 변수의 값을 전달
    $("#matching_btn").click(function (event) {
      axios
        .get("<%=request.getContextPath()%>/campaign/AI/doMatching", {
          params: { //params 객체는 요청에 전달할 파라미터를 지정(추후 유효성 검사 추가)
            subCategories: subCategories,
          },
        })
        .then((response) => { //요청이 성공적으로 완료되면 실행되는 콜백 함수를 지정
          /*  응답 데이터에서 각 타입별 정렬된 캠페인 목록을 가져옴 (보상형, 수익형, 기부형)
          const matchingRewardList = response.data.matchingRewardList;
          const matchingProfitList = response.data.matchingProfitList;
          const matchingDonationList = response.data.matchingDonationList;
          */
          // /campaign/AI/doMatching 엔드포인트로 리다이렉트(유형 별 캠페인 목록)
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
