<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<%@ include file="../../layout/header.jsp" %>

  <!-- summernote -->
  <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>

  <!-- CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
  rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65"
  crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.7.2/font/bootstrap-icons.min.css">

  <!-- datepicker -->
  <!-- flatpickr 스타일시트 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
  <!-- flatpickr 라이브러리 -->
  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>


<div class="container" style="margin-top:50px; margin-right: auto;">
    <div class="container">
            <div id="write">
                    <div class="container col-md-8">
                <h1 style="font-size:20px;">💌 캠페인 등록하기</h1>
                <hr/>

                <form id="campaignForm" name="campaignForm" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="campaign_id" id="campaign_id" value="${campaign_id}"/>
                    <input type="hidden" name="mode" id="mode" value="${mode}"/>
                    <div class="form-group">
                        <label for="title">캠페인타입 선택</label>
                        <select class="form-select" aria-label="Default select example" id="selectBox" name="selectBox">
                            <option value="reward" ${writeDto.campaign_type == 'reward' ? 'selected' : ''}>리워드형</option>
                            <option value="donation" ${writeDto.campaign_type == 'donation' ? 'selected' : ''}>기부형</option>
                            <option value="profit" ${writeDto.campaign_type == 'profit' ? 'selected' : ''}>수익형</option>
                        </select>
                    </div>
                    <br>

                    <div class="form-group">
                        <label for="campaign_company">기업명</label>
                        <input id="campaign_company" name="campaign_company" type="text" class="form-control" placeholder="기업명을 입력하세요" value="${writeDto.campaign_company}">
                    </div>
                    <br>

                    <div class="form-group">
                        <label for="campaign_name">캠페인명</label>
                        <input id="campaign_name" name="campaign_name" type="text" class="form-control" placeholder="캠페인명을 입력하세요" value="${writeDto.campaign_name}">
                    </div>
                    <br>

                    <div class="form-group">
                        <label for="campaign_reward">제공 혜택</label>
                        <input id="campaign_reward" name="campaign_reward" type="text" class="form-control" placeholder="혜택을 입력하세요" value="${writeDto.campaign_reward}">
                    </div>
                    <br>


                    <div class="form-group">
                      <div class="row">
                        <div class="col">
                          <label for="campaign_start_date">캠페인 시작일</label>
                          <div class="input-group">
                            <input id="campaign_period" name="campaign_start_date" type="text" class="form-control" placeholder="캠페인 시작일을 선택하세요" style="background-color: white;" value="${writeDto.campaign_start_date}">
                            <div class="input-group-append">
                              <button class="btn btn-outline-secondary" type="button" id="start_date_button">
                                <i class="bi bi-calendar4"></i>
                              </button>
                            </div>
                          </div>
                        </div>
                        <div class="col">
                          <label for="campaign_end_date">캠페인 종료일</label>
                          <div class="input-group">
                            <input id="campaign_period" name="campaign_end_date" type="text" class="form-control" placeholder="캠페인 종료일을 선택하세요" style="background-color: white;" value="${writeDto.campaign_end_date}">
                            <div class="input-group-append">
                              <button class="btn btn-outline-secondary" type="button" id="end_date_button">
                                <i class="bi bi-calendar4"></i>
                              </button>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <br>


                    <div class="form-group">
                        <label for="conditions">수거 조건</label>
                        <input id="conditions" name="conditions" type="text" class="form-control" placeholder="수거 조건을 입력하세요" value="${writeDto.conditions}">
                    </div>
                    <br>

                    <div class="form-group">
                        <label for="campaign_area">수거 지역</label>
                        <input id="campaign_area" name="campaign_area" type="text" class="form-control" placeholder="수거 지역을 입력하세요" value="${writeDto.campaign_area}">
                    </div>
                    <br>

                    <div class="form-group">
                        <label for="campaign_url">캠페인 이동 URL</label>
                        <input id="campaign_url" name="campaign_url" type="text" class="form-control" placeholder="캠페인 참여 URL을 입력하세요" value="${writeDto.campaign_url}">
                    </div>
                    <br>

                    <div class="form-group">
                        <label for="title">썸네일 업로드(750x400)</label>
                        <div class="input-group mb-3">
                            <input type="file" class="form-control" id="inputThumbnailFile" name="inputThumbnailFile">
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col">
                            <label for="title">⭐ 새로 등록될 썸네일</label>
                            <br>
                            <div id="thumbnailPreview" class="card card-img-top ratio ratio-4x3" style="width: 18rem; float:left; margin-right:10px; margin-bottom:30px; min-width: 270px; max-width: 270px; min-height: 150px; max-height: 150px;"></div>
                        </div>
                        <div class="col" id="existingThumbnailWrapper">
                            <label for="title">이전 등록된 썸네일</label>
                            <br>
                            <div class="card card-img-top ratio ratio-4x3" style="margin-bottom:30px; min-width: 270px; max-width: 270px; min-height: 150px; max-height: 150px;">
                                <img id="existingThumbnail" src="${pageContext.request.contextPath}/resources/image/thumbnail/${writeDto.thumbnail_file}" alt="이전에 등록된 썸네일이 없네요" />
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="title">내용</label>
                        <textarea id="summernote" name="summernoteDetail">${writeDto.campaign_contents}</textarea>
                    </div>
                    <br>

                    <span class="badge text-bg-secondary" style="font-size:14px;">의류 카테고리 : 상의</span>
                    <p>
                        <div class="form-group form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="inlineCheckbox1" name="inlineCheckbox" value="맨투맨" ${writeDto.cloth_subcategory.contains('맨투맨') ? 'checked' : ''}>
                            <label class="form-check-label" for="inlineCheckbox1">맨투맨</label>
                        </div>
                        <div class="form-group form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="inlineCheckbox2" name="inlineCheckbox" value="티셔츠" ${writeDto.cloth_subcategory.contains('티셔츠') ? 'checked' : ''}>
                            <label class="form-check-label" for="inlineCheckbox2">티셔츠</label>
                        </div>
                        <div class="form-group form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="inlineCheckbox3" name="inlineCheckbox" value="셔츠" ${writeDto.cloth_subcategory.contains('셔츠') ? 'checked' : ''}>
                            <label class="form-check-label" for="inlineCheckbox3">셔츠</label>
                        </div>
                        <div class="form-group form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="inlineCheckbox4" name="inlineCheckbox" value="아우터" ${writeDto.cloth_subcategory.contains('아우터') ? 'checked' : ''}>
                            <label class="form-check-label" for="inlineCheckbox2">아우터</label>
                        </div>
                        <div class="form-group form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="inlineCheckbox5" name="inlineCheckbox" value="기타상의" ${writeDto.cloth_subcategory.contains('기타상의') ? 'checked' : ''}>
                            <label class="form-check-label" for="inlineCheckbox1">기타상의</label>
                        </div>
                    </p>

                    <span class="badge text-bg-secondary" style="font-size:14px;">의류 카테고리 : 하의</span>
                    <p>
                        <div class="form-group form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="inlineCheckbox8" name="inlineCheckbox" value="긴바지" ${writeDto.cloth_subcategory.contains('긴바지') ? 'checked' : ''}>
                            <label class="form-check-label" for="inlineCheckbox1">긴바지</label>
                        </div>
                        <div class="form-group form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="inlineCheckbox9" name="inlineCheckbox" value="반바지" ${writeDto.cloth_subcategory.contains('반바지') ? 'checked' : ''}>
                            <label class="form-check-label" for="inlineCheckbox2">반바지</label>
                        </div>
                        <div class="form-group form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="inlineCheckbox10" name="inlineCheckbox" value="숏팬츠" ${writeDto.cloth_subcategory.contains('숏팬츠') ? 'checked' : ''}>
                            <label class="form-check-label" for="inlineCheckbox1">숏팬츠</label>
                        </div>
                        <div class="form-group form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="inlineCheckbox11" name="inlineCheckbox" value="치마" ${writeDto.cloth_subcategory.contains('치마') ? 'checked' : ''}>
                            <label class="form-check-label" for="inlineCheckbox2">치마</label>
                        </div>
                    </p>

                    <span class="badge text-bg-secondary" style="font-size:14px;">의류 카테고리 : 신발</span>
                    <p>
                        <div class="form-group form-check form-check-inline">
                          <input class="form-check-input" type="checkbox" id="inlineCheckbox18" name="inlineCheckbox" value="운동화" ${writeDto.cloth_subcategory.contains('운동화') ? 'checked' : ''}>
                          <label class="form-check-label" for="inlineCheckbox1">운동화</label>
                        </div>
                        <div class="form-group form-check form-check-inline">
                          <input class="form-check-input" type="checkbox" id="inlineCheckbox19" name="inlineCheckbox" value="샌들" ${writeDto.cloth_subcategory.contains('샌들') ? 'checked' : ''}>
                          <label class="form-check-label" for="inlineCheckbox2">샌들</label>
                        </div>
                        <div class="form-group form-check form-check-inline">
                          <input class="form-check-input" type="checkbox" id="inlineCheckbox20" name="inlineCheckbox" value="기타신발" ${writeDto.cloth_subcategory.contains('기타신발') ? 'checked' : ''}>
                          <label class="form-check-label" for="inlineCheckbox1">기타신발</label>
                        </div>
                    </p>

                    <span class="badge text-bg-secondary" style="font-size:14px;">의류 카테고리 : 가방</span>
                    <p>
                        <div class="form-group form-check form-check-inline">
                          <input class="form-check-input" type="checkbox" id="inlineCheckbox22" name="inlineCheckbox" value="가방" ${writeDto.cloth_subcategory.contains('가방') ? 'checked' : ''}>
                          <label class="form-check-label" for="inlineCheckbox1">가방</label>
                        </div>
                    </p>

                    <span class="badge text-bg-secondary" style="font-size:14px;">의류 카테고리 : 기타</span>
                    <p>
                        <div class="form-group form-check form-check-inline">
                          <input class="form-check-input" type="checkbox" id="inlineCheckbox23" name="inlineCheckbox" value="기타" ${writeDto.cloth_subcategory.contains('기타') ? 'checked' : ''}>
                          <label class="form-check-label" for="inlineCheckbox1">기타</label>
                        </div>
                    </p>

                    <div class="form-group">
                        <a href="/" role="button" class="btn btn-secondary">취소</a>
                        <button id="btnSend" class="btn btn-dark bi bi-pencil-fill" type="button">등록</button>
                        <button id="btnUpdate" class="btn btn-dark bi bi-pencil-fill" type="button">수정완료</button>
                    </div>
                 </form>
            </div>
            <br>
            <br>
    </div>
</div>


<script>
    $(document).ready(function () {

        $('#summernote').summernote({
            codeviewFilter: false, // 코드 보기 필터 비활성화
            codeviewIframeFilter: false, // 코드 보기 iframe 필터 비활성화

            height: 500, // 에디터 높이
            minHeight: null, // 최소 높이
            maxHeight: null, // 최대 높이
            focus: true, // 에디터 로딩 후 포커스 설정
            lang: 'ko-KR', // 언어 설정 (한국어)

            toolbar: [
                ['style', ['style']], // 글자 스타일 설정 옵션
                ['fontsize', ['fontsize']], // 글꼴 크기 설정 옵션
                ['font', ['bold', 'underline', 'clear']], // 글자 굵게, 밑줄, 포맷 제거 옵션
                ['color', ['color']], // 글자 색상 설정 옵션
                ['table', ['table']], // 테이블 삽입 옵션
                ['para', ['ul', 'ol', 'paragraph']], // 문단 스타일, 순서 없는 목록, 순서 있는 목록 옵션
                ['height', ['height']], // 에디터 높이 조절 옵션
                ['insert', ['picture', 'link', 'video']], // 이미지 삽입, 링크 삽입, 동영상 삽입 옵션
                ['view', ['codeview', 'fullscreen', 'help']], // 코드 보기, 전체 화면, 도움말 옵션
            ],

            fontSizes: [
                '8', '9', '10', '11', '12', '14', '16', '18',
                '20', '22', '24', '28', '30', '36', '50', '72',
            ], // 글꼴 크기 옵션

            styleTags: [
                'p',  // 일반 문단 스타일 옵션
                {
                    title: 'Blockquote',
                    tag: 'blockquote',
                    className: 'blockquote',
                    value: 'blockquote',
                },  // 인용구 스타일 옵션
                'pre',  // 코드 단락 스타일 옵션
                {
                    title: 'code_light',
                    tag: 'pre',
                    className: 'code_light',
                    value: 'pre',
                },  // 밝은 코드 스타일 옵션
                {
                    title: 'code_dark',
                    tag: 'pre',
                    className: 'code_dark',
                    value: 'pre',
                },  // 어두운 코드 스타일 옵션
                'h1', 'h2', 'h3', 'h4', 'h5', 'h6',  // 제목 스타일 옵션
            ],

            //콜백 함수
            callbacks : {
            	onImageUpload : function(files, editor, welEditable) {
            // 파일 업로드(다중업로드를 위해 반복문 사용)
            for (var i = files.length - 1; i >= 0; i--) {
            uploadSummernoteImageFile(files[i],
            this);
            		}
            	},
            },
        });
    });
    // 이미지 업로드 함수 ajax 활용
    function uploadSummernoteImageFile(file, el) {
			data = new FormData();
			data.append("file", file);
			$.ajax({
				data : data,
				type : "POST",
				url : "<%=request.getContextPath()%>/uploadSummernoteImageFile",
				contentType : false,
				enctype : 'multipart/form-data',
				processData : false,
				success : function(data) {
					$(el).summernote('editor.insertImage', data.url);
				}
			});
	}

$(document).ready(() => {
    $("#btnSend").click(() => {
        callsend("<%=request.getContextPath()%>/campaign/save");
    });

    $("#btnUpdate").click(() => {
        callsend("<%=request.getContextPath()%>/campaign/update");
    });
});

function callsend(url) {
    var title = $("#title").val();
    var frmData = new FormData($("#campaignForm")[0]);
    // summernote의 값 가져와서 frmData에 추가
    var summernoteValue = $("#summernote").summernote("code");
    frmData.append("campaign_contents", summernoteValue);
    console.log(url);
    console.log(frmData);
    $.ajax({
        url: url,
        dataType: "json",
        type: "post",
        processData: false,
        contentType: false,
        data: frmData
    })
    .done((res) => {
        if (res.result == "success") {
            alert("캠페인 등록을 성공했습니다.");
        } else {
            alert("캠페인 등록이 실패했습니다.");
        }
        location.href = "<%=request.getContextPath()%>/campaign/write";
    })
    .fail((res, status, error) => {
        console.log(status);
        console.log(res);
    });
}

</script>

<script>
    window.addEventListener('DOMContentLoaded', () => {
        // 업로드한 썸네일
        const thumbnailFileInput = document.getElementById('inputThumbnailFile');
        // 업로드한 썸네일 미리보기
        const thumbnailPreview = document.getElementById('thumbnailPreview');
        // 이전에 등록한 썸네일
        const existingThumbnailWrapper = document.getElementById('existingThumbnailWrapper');

        // 이전에 등록한 파일의 경로가 있는 경우, 미리보기 이미지를 표시
        if ("${writeDto.thumbnail_file}" !== "") {
            const existingImage = document.createElement('img');
            existingImage.src = "${writeDto.thumbnail_file}";
            existingImage.alt = "이전 썸네일이 삭제되어 등록이 필요합니다";
            thumbnailPreview.appendChild(existingImage);
        } else {
            // 이전 썸네일이 없는 경우, 해당 영역을 숨깁니다.
            existingThumbnailWrapper.style.display = 'none';
        }

        // 파일 선택 시, 선택한 파일의 미리보기 이미지를 표시합니다.
        thumbnailFileInput.addEventListener('change', (event) => {
            const selectedFile = event.target.files[0];

            // 선택한 파일의 미리보기 이미지를 표시하기 위해 FileReader 객체를 사용합니다.
            const reader = new FileReader();
            reader.onload = (event) => {
                const previewImage = document.createElement('img');
                previewImage.src = event.target.result;
                previewImage.alt = "이전 썸네일이 삭제되어 등록이 필요합니다!";

                // 기존 미리보기 이미지와 교체합니다.
                thumbnailPreview.innerHTML = '';
                thumbnailPreview.appendChild(previewImage);
            };

            // FileReader를 사용하여 파일을 읽고, 미리보기 이미지를 생성합니다.
            reader.readAsDataURL(selectedFile);
        });
    });
</script>

<script>
  $(document).ready(function() {
      flatpickr("#campaign_period", {
        enableTime: true, // 시간 선택 활성화
        dateFormat: "Y.m.d H:i", // 선택한 날짜와 시간의 형식
        minDate: new Date(new Date().setDate(new Date().getDate() - 1)).toISOString().split("T")[0], // 오늘 이전 날짜는 선택 불가능
      });
  });
</script>

<%@ include file="../../layout/footer.jsp" %>