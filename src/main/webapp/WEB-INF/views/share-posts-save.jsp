<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<%@ include file="../layout/header.jsp" %>

<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<br></br>
<div class="container container col-md-7">
    <h2>나눔 게시글 등록하기</h2>
    <hr>
<form action="<%=request.getContextPath()%>/api/v1/posts" method="post" enctype="multipart/form-data" onsubmit="return checkImageUploaded()">
    <div class="mb-3">
        <label for="title" class="form-label">제목</label>
        <input type="text" class="form-control" id="title" name="title" required>
    </div>
    <div class="mb-3">
        <select class="form-select" id="category" name="region" required style="width: 200px;">
            <option value="">지역을 선택하세요</option>
            <option value="서울">서울</option>
            <option value="경기">경기</option>
            <option value="인천">인천</option>
            <option value="부산">부산</option>
            <option value="대구">대구</option>
            <option value="대전">대전</option>
            <option value="광주">광주</option>
            <option value="울산">울산</option>
            <option value="세종">세종</option>
            <option value="충북">충북</option>
            <option value="충남">충남</option>
            <option value="전북">전북</option>
            <option value="전남">전남</option>
            <option value="경북">경북</option>
            <option value="경남">경남</option>
            <option value="강원">강원</option>
            <option value="제주">제주</option>
        </select>
    </div>
    <div class="mb-3">
        <label for="content" class="form-label">내용</label>
        <textarea class="form-control" id="summernote" name="originalContent" rows="20" required></textarea>
    </div>
    <script>
        function checkImageUploaded() {
            var content = $('#summernote').summernote('code');
            var hasImage = $(content).find('img').length > 0;

            if (!hasImage) {
                alert('최소 한 장의 이미지를 첨부해주세요');
                return false;
            }

            return true;
        }

        $(document).ready(function() {
            $('#summernote').summernote({
                placeholder: '내용을 입력하세요',
                tabsize: 2,
                width: 865,
                height: 400,
                toolbar: [
                    ['style', ['style']],
                    ['font', ['bold', 'underline', 'clear']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['table', ['table']],
                    ['insert', ['link', 'picture', 'video']],
                    ['view', ['fullscreen', 'codeview', 'help']]
                ]
            });
        });
    </script>
    <div style="text-align: right;">
        <a href="/share/index" role="button" class="btn btn-dark">취소</a>
        <button type="submit" class="btn btn-outline-dark">등록</button>
    </div>
</form>
</div>
<br></br>
<br></br>
<%@ include file="../layout/footer.jsp" %>
