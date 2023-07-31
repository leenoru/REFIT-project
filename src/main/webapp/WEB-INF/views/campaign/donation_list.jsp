<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<%@ include file="../../layout/header.jsp" %>

<div class="container" style="margin-top:50px; margin-right: auto;">
         <div class="container row-cols-md-2">
            <h1 style="font-size:18px;">💌 진행중인 기부 캠페인을 확인하세요!</h1>
            <br>
            <c:forEach var="item" items="${donationList}">
                <div class="card" style="width: 18rem; float:left; margin-right:30px; margin-bottom:30px; min-width: 280px; max-width: 280px; min-height: 390px; max-height: 390px;" >
                  <a href="${pageContext.request.contextPath}/campaign/${item.campaign_id}"><img src="${pageContext.request.contextPath}/resources/image/thumbnail/${item.thumbnail_file}" class="card-img-top" alt="..."></a>
                  <div class="card-body">
                    <p class="card-text" style="font-size:11px;">리핏 x ${item.campaign_company}</p>
                    <p class="card-text" >${item.campaign_name}</p>
                  <div class="card-text">
                    <p style="font-size:13px;">기간 :
                      <span id="formattedStartDate" style="font-size:13px;">${item.campaign_start_date.split(' ')[0]}</span>
                      ~
                      <span id="formattedEndDate" style="font-size:13px;">${item.campaign_end_date.split(' ')[0]}</span>
                    </p>
                  </div>
                    <p class="card-text" style="font-size:13px; line-height : 1;"><span class="badge text-bg-dark">REWARD</span> ${item.campaign_reward}</p>
                    <a href="${pageContext.request.contextPath}/campaign/${item.campaign_id}" class="btn btn-dark">자세히보기</a>
                  </div>
                </div>
            </c:forEach>
         </div>
</div>

<style>
.card-img-top {
    height: 10rem;
    object-fit : cover;
}
</style>



</body>
</html>