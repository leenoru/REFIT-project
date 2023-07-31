<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<%@ include file="../../layout/header.jsp" %>

<input type="hidden" id="campaignId" data-campaign-id="${model.getAttribute("viewDto").campaign_id}">

    <form id="campaignForm" name="campaignForm">
        <input type="hidden" name="campaign_id" id="campaign_id" value="${campaign_id}"/>
        <input type="hidden" name="campaign_type" id="campaign_type" value="${viewDto.campaign_type}"/>
        <input type="hidden" name="mode" id="mode" value="modify"/>
        <br>
        <br>
        <div class="container col-md-8 card">
            <div class="container mt-3">
                  <div class="mb-3">
                    <p>리핏 x ${viewDto.campaign_company}</p>
                  </div>

                  <div class="mb-3">
                    <h1 style="font-size:30px;">${viewDto.campaign_name}</h1>
                  </div>

                  <div class="mb-3">
                    <p>기간:
                      <span id="formattedStartDate">${viewDto.campaign_start_date.split(' ')[0]}</span>
                      ~
                      <span id="formattedEndDate">${viewDto.campaign_end_date.split(' ')[0]}</span>
                    </p>
                  </div>

                  <div class="mb-3">
                    <p><span class="badge text-bg-dark">REWARD</span> ${viewDto.campaign_reward}</p>
                  </div>
                  <hr/>

                  <div class="mb-3">
                    ${viewDto.campaign_contents}
                  </div>
                  <br>
            </div>
        </div>
        <br>
        <div class="mb-3 col text-center">
            <p>의미있는 나눔,  함께 하면 배가 되어요😊</p>
            <a class="btn btn-dark" href="${viewDto.campaign_url}" role="button" style="min-width: 190px; max-width: 190px;">참여사이트 이동하기</a>
            <button type="button" id="btnShare" class="btn btn-dark" style="min-width: 190px; max-width: 190px;" onclick="clip()">공유하기</button>
            <br>
            <br>
            <a class="btn btn-outline-dark d-grid gap-2 col-6 mx-auto" href="${pageContext.request.contextPath}/campaign/${viewDto.campaign_type}" role="button">목록으로 이동</a>
            <br>
            <br>
            <button type="button" id="btnModify" class="btn btn-primary">수정</button>
            <button type="button" id="btnDelete" class="btn btn-primary">삭제</button>
        </div>
    </form>


<script>
$( document ).ready(function() {
    $("#btnModify").on("click",function(){
      $("#campaignForm").attr("action","<%=request.getContextPath()%>/campaign/modify");
      $("#campaignForm").submit();
    });

    $("#btnDelete").on("click",function(){
        $("#campaignForm").attr("action","<%=request.getContextPath()%>/campaign/delete");
        $("#campaignForm").submit();
        alert("삭제되었습니다");
    });
});


<%--
$("#btnDelete").click(() => {
  if (confirm("삭제하시겠습니까?")) {
    $.ajax({
      url: "<%=request.getContextPath()%>/campaign/delete",
      type: "POST",
      data: $("#myform").serialize(),
      success: function (response) {
        alert("삭제 성공했습니다.");
        window.location.href = "<%=request.getContextPath()%>/campain";
      },
      error: function (xhr, status, error) {
        alert("삭제 실패했습니다.");
        console.log(xhr.responseText);
      }
    });
  }
});

--%>

function clip(){
        var url = '';    // <a>태그에서 호출한 함수인 clip 생성
        var textarea = document.createElement("textarea");
        //url 변수 생성 후, textarea라는 변수에 textarea의 요소를 생성
        document.body.appendChild(textarea); //</body> 바로 위에 textarea를 추가(임시 공간이라 위치는 상관 없음)
        url = window.document.location.href;  //url에는 현재 주소값을 넣어줌
        textarea.value = url;  // textarea 값에 url를 넣어줌
        textarea.select();  //textarea를 설정
        document.execCommand("copy");   // 복사
        document.body.removeChild(textarea); //extarea 요소를 없애줌
        alert("링크가 복사되었어요! 이제 널리 알려주세요😊")  // 알림창
    }
</script>

<%@ include file="../../layout/footer.jsp" %>
