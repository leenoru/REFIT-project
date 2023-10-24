<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<%@ include file="../../layout/header.jsp" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">


<div class="container" style="margin-top:50px;">
    <div class="container container col-md-8">
        <div class="d-flex justify-content-between align-items-center">
            <h1 style="font-size:18px;">💎 새 주인을 찾고 있어요</h2>
                <c:if test="${sessionScope.id != null}">
                    <div>
                        <a href="<%=request.getContextPath()%>/share/posts/save" class="btn btn-outline-dark" style="width: 110px;">글쓰기</a>
                    </div>
                </c:if>
        </div>
        <hr/>
        <div class="search-box mb-3" style="text-align: right;">
            <form action="<%=request.getContextPath()%>/share/index/search" method="get">
                <input type="text" name="keyword" placeholder="어떤 옷을 찾으시나요?" style="width: 300px;" class="form-control" confocus="clearPlaceholder(this)" onblur="restorePlaceholder(this)">
                <button type="submit" class="btn btn-dark"><i class="bi bi-search"></i> 찾기</button>
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
    </div>

    <div class="container container col-md-8"">
        <br>
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

        <c:choose>
            <c:when test="${empty dtoList}">
                <br></br>
                <br></br>
                <p style="text-align: center; font-size: 20px;">게시글이 없습니다.</p>
                <br></br>
                <br></br>
                <br></br>
            </c:when>

            <c:otherwise>
                <style>
                    .board-item {
                        display: inline-block;
                        margin-right: 20px;
                        margin-bottom: 20px;
                    }
                </style>
                <table>
                    <tr>
                        <c:forEach var="board" items="${dtoList}" varStatus="status">
                            <td onmouseover="moveCodeBlock(event)" onmouseout="resetCodeBlock(event)">
                                <div class="board-item">
                                    <a href="<%=request.getContextPath()%>/share/posts/view/${board.id}">
                                        <img src="${board.imageText2[0]}" alt="" style="width: 195px; height: 195px; border-radius: 5%;">
                                    </a>
                                    <br></br>
                                    <a href="<%=request.getContextPath()%>/share/posts/view/${board.id}" style="color: #000; text-decoration: none;">
                                        <span style="display: inline-block; max-width: 195px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                            ${board.title}
                                        </span>
                                        <br>
                                    </a>
                                    <span style="font-size: smaller; color: gray;">
                                        ${board.region} | ${board.formattedCreatedAt}
                                    </span>
                                </div>
                            </td>
                            <c:if test="${status.index % 4 == 3 or status.last}">
                                </tr><tr>
                            </c:if>
                        </c:forEach>
                    </tr>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <br></br>

    <!-- 전체 페이지 수가 1보다 큰 경우에만 페이징 처리를 수행 -->
    <div class="centered-div" style="text-align: center;">
        <c:if test="${paging.maxPage > 1}">
            <c:choose>
                <%-- 현재 페이지가 1페이지 이하인 경우에는 이전 버튼을 표시하지 않아야 하므로, 이 경우에는 아무것도 표시하지 않음 --%>
                <c:when test="${paging.page <= 1}">
                </c:when>

                <%-- 현재 페이지가 1페이지가 아닌 경우에는 [이전] Previous을 표시하며 이를 클릭하면 현재 페이지보다 1 작은 페이지 요청 --%>
                <c:otherwise>
                    <c:choose>
                        <%-- 검색어가 있을 경우와 없을 경우에 따라 다른 URL 적용 --%>
                        <c:when test="${not empty dtoList and not empty dtoList.get(0).keyword}">
                            <a href="<%=request.getContextPath()%>/share/index/search?keyword=${dtoList.get(0).keyword}&page=${paging.page-1}">
                            <button type="button" class="btn btn-outline-dark" style="padding-top: 1px; padding-bottom: 1px;">Previous</button></a>
                            &nbsp;&nbsp;
                        </c:when>

                        <c:when test="${not empty dtoList}">
                            <a href="<%=request.getContextPath()%>/share/index?page=${paging.page-1}">
                            <button type="button" class="btn btn-outline-dark" style="padding-top: 1px; padding-bottom: 1px;">Previous</button></a>
                            &nbsp;&nbsp;
                        </c:when>
                    </c:choose>
                </c:otherwise>
            </c:choose>

            <%-- for(int i=startPage; i<=endPage; i++) --%>
            <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i" step="1">
                <c:choose>
                    <%-- 요청한 페이지에 있는 경우 현재 페이지 번호는 텍스트만 보이게 disabled 속성을 통한 비활성화--%>
                    <c:when test="${i eq paging.page}">
                        <button type="button" class="btn btn-secondary" disabled style="padding-top: 1px; padding-bottom: 1px;">${i}</button>
                        &nbsp;&nbsp;
                    </c:when>

                    <c:otherwise>
                        <c:choose>
                            <%-- 검색어가 있을 경우와 없을 경우에 따라 다른 URL 적용 --%>
                            <c:when test="${not empty dtoList and not empty dtoList.get(0).keyword}">
                                <a href="<%=request.getContextPath()%>/share/index/search?keyword=${dtoList.get(0).keyword}&page=${i}">
                                <button type="button" class="btn btn-outline-dark" style="padding-top: 1px; padding-bottom: 1px;">${i}</button></a>
                                &nbsp;&nbsp;
                            </c:when>

                            <c:when test="${not empty dtoList}">
                                <a href="<%=request.getContextPath()%>/share/index?page=${i}">
                                <button type="button" class="btn btn-outline-dark" style="padding-top: 1px; padding-bottom: 1px;">${i}</button></a>
                                &nbsp;&nbsp;
                            </c:when>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:choose>
                <c:when test="${paging.page >= paging.maxPage}">
                    <%-- 현재 페이지가 마지막 페이지인 경우 다음 버튼을 표시하지 않음 --%>
                </c:when>

                <c:otherwise>
                    <%-- 현재 페이지가 마지막 페이지가 아닌 경우 다음 버튼(next)을 표시 --%>
                    <c:choose>
                        <%-- 검색어가 있을 경우와 없을 경우에 따라 다른 URL 적용 --%>
                        <c:when test="${not empty dtoList and not empty dtoList.get(0).keyword}">
                            <a href="<%=request.getContextPath()%>/share/index/search?keyword=${dtoList.get(0).keyword}&page=${paging.page+1}">
                            <button type="button" class="btn btn-outline-dark" style="padding-top: 1px; padding-bottom: 1px;">Next</button></a>
                            &nbsp;&nbsp;
                        </c:when>

                        <c:when test="${not empty dtoList}">
                            <a href="<%=request.getContextPath()%>/share/index?page=${paging.page+1}">
                            <button type="button" class="btn btn-outline-dark" style="padding-top: 1px; padding-bottom: 1px;">Next</button></a>
                            &nbsp;&nbsp;
                        </c:when>
                    </c:choose>
                </c:otherwise>
            </c:choose>
        </c:if>
    </div>
</div>

<style>
    form {
        display: flex;
        justify-content: flex-end;
    }
</style>
<br></br>
<br></br>
<%@ include file="../../layout/footer.jsp" %>