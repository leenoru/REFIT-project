<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<%@ include file="../layout/header.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
<br></br>
<br></br>
    <div class="container">
   <table>
       <td>
           <h2 style="font-weight: 10px;">새 주인을 찾고 있어요</h2>
       </td>
       <td style="width: 73%;">
           <div class="search-box" style="text-align: right;">
               <form action="<%=request.getContextPath()%>/share/index/search" method="get">
                   <input type="text" name="keyword" placeholder="어떤 옷을 찾으시나요?" style="width: 300px;" onfocus="clearPlaceholder(this)" onblur="restorePlaceholder(this)">
                   <button type="submit" class="btn btn-outline-success"><i class="bi bi-search"></i> 찾기</button>
               </form>

               <script>
                   function clearPlaceholder(element) {
                       element.placeholder = "";
                   }

                   function restorePlaceholder(element) {
                       element.placeholder = "어떤 옷을 찾으시나요?";
                   }
               </script>
           </div>
       </td>
   </table>
   <hr align="center" style="width: 92.8%; color: black; border-width: 2px;">
   <br style="margin-bottom: 5px;">
   <c:if test="${sessionScope.id != null}">
       <table>
           <td style="width: 9.3%; text-align: right;">
               <div>
                   <a href="<%=request.getContextPath()%>/share/posts/save" class="btn btn-outline-success" style="width: 110px;">글쓰기</a>
               </div>
           </td>
       </table>
   </c:if>
    </table>
  <br>
        <table class="table">

      <style>
          td {
              transition: transform 0.2s ease-in-out; /* 이동 애니메이션 속도와 방식을 조정합니다 */
          }
      </style>

      <script>
          function moveCodeBlock(event) {
              var codeBlock = event.currentTarget;
              codeBlock.style.transform = "translateY(-5px)"; // 위로 5px 이동
          }

          function resetCodeBlock(event) {
              var codeBlock = event.currentTarget;
              codeBlock.style.transform = "translateY(0)"; // 원래 위치로 복원
          }
      </script>

      <c:forEach var="board" items="${dtoList}" varStatus="status">
          <c:if test="${status.index % 5 == 0}">
              <tr>
          </c:if>
          <td onmouseover="moveCodeBlock(event)" onmouseout="resetCodeBlock(event)">
              <a href="<%=request.getContextPath()%>/share/posts/view/${board.id}">
                  <img src="${board.imageText2[0]}" alt="" style="width: 160px; height: 160px; border-radius: 5%;">
              </a>
              <br></br>
              <style>
                  a {
                      color: #000; /* 원하는 색상으로 변경하세요 */
                      text-decoration: none; /* 링크 텍스트에 밑줄을 제거합니다 */
                  }
              </style>
              <a href="<%=request.getContextPath()%>/share/posts/view/${board.id}">
                  ${board.title}
                  <br/>
              </a>
              <span style="font-size: smaller; color: gray;">
                  ${board.region} | ${board.formattedCreatedAt}
              </span>
          </td>
          <c:if test="${status.index % 5 == 4 or status.last}">
              </tr>
          </c:if>
      </c:forEach>

          <c:if test="${empty dtoList}">
              <tr>
                  <td colspan="5" style="text-align: center; font-size: 20px; padding: 10px;">
                      해당하는 게시글이 없습니다.
                  </td>
              </tr>
          </c:if>
        </table>
    </div>

    <div class="centered-div">
        <c:choose>
            <%-- 현재 페이지가 1페이지면 이전 글자만 보여줌 --%>
            <c:when test="${paging.page <= 1}">

            </c:when>
            <%-- 1페이지가 아닌 경우에는 [이전]을 클릭하면 현재 페이지보다 1 작은 페이지 요청 --%>
            <c:otherwise>
                <c:choose>
                    <%-- 검색어가 있을 경우와 없을 경우에 따라 다른 URL 적용 --%>
                    <c:when test="${not empty dtoList.get(0).keyword}">
                        <a href="<%=request.getContextPath()%>/share/index/search?keyword=${dtoList.get(0).keyword}&page=${paging.page-1}">[이전]</a>
                    </c:when>
                    <c:otherwise>
                        <a href="<%=request.getContextPath()%>/share/index?page=${paging.page-1}">[이전]</a>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>

        <%-- for(int i=startPage; i<=endPage; i++) --%>
        <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i" step="1">
            <c:choose>
                <%-- 요청한 페이지에 있는 경우 현재 페이지 번호는 텍스트만 보이게 --%>
                <c:when test="${i eq paging.page}">
                    <span>${i}</span>
                </c:when>
                <c:otherwise>
                    <c:choose>
                        <%-- 검색어가 있을 경우와 없을 경우에 따라 다른 URL 적용 --%>
                        <c:when test="${not empty dtoList.get(0).keyword}">
                            <a href="<%=request.getContextPath()%>/share/index/search?keyword=${dtoList.get(0).keyword}&page=${i}">${i}</a>
                        </c:when>
                        <c:otherwise>
                            <a href="<%=request.getContextPath()%>/share/index?page=${i}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:choose>
            <c:when test="${paging.page >= paging.maxPage}">

            </c:when>
            <c:otherwise>
                <c:choose>
                    <%-- 검색어가 있을 경우와 없을 경우에 따라 다른 URL 적용 --%>
                    <c:when test="${not empty dtoList.get(0).keyword}">
                        <a href="<%=request.getContextPath()%>/share/index/search?keyword=${dtoList.get(0).keyword}&page=${paging.page+1}">[다음]</a>
                    </c:when>
                    <c:otherwise>
                        <a href="<%=request.getContextPath()%>/share/index?page=${paging.page+1}">[다음]</a>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </div>



<%@ include file="../layout/footer.jsp" %>