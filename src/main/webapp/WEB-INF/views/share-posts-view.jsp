<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<%@ include file="../layout/header.jsp" %>
<br></br>
<br></br>
<div class="container container col-md-7">
<div class="container">
    <div class="card">
        <div class="card-body" style="display: flex; flex-direction: column;">
          <div style="display: flex; justify-content: space-between; align-items: flex-start;">
            <p style="margin: 0;">글쓴이 : <strong style="font-weight: bold; color: gray;">${postView.nickName}</strong></p>
            <a href="<%=request.getContextPath()%>/share/index">
              <button type="button" class="btn btn-outline-dark">목록</button>
            </a>
          </div>
          <h3 class="card-title" style="font-weight: bold;">${postView.title}</h3>
          ${postView.region}&nbsp;&nbsp;${postView.formattedCreatedAt}
          <hr>
          <div class="image-container">
            <c:forEach var="image" items="${postView.imageText2}">
              <img src="${image}" alt="" style="width: 260px; height: 280px; border-radius: 5%;">
            </c:forEach>
          </div>
          <br>
          <p class="card-text">${postView.content}</p>
        </div>
    </div>

    <c:if test="${postView.author_id eq sessionScope.id}">
        <div style="text-align: right;">
            <a href="/share/posts/update/${postView.id}" class="btn btn-outline-dark btn-sm">수정</a>
            <a href="/api/v1/delete/${postView.id}" class="btn btn-outline-dark btn-sm" onclick="confirmDeletePost(event)">삭제</a>
        </div>
    </c:if>


    <script>
       function confirmDeletePost(event) {
           event.preventDefault();
           const deleteUrl = event.target.getAttribute('href');
           const confirmation = confirm("게시글을 완전히 삭제할까요?");
           if (confirmation) {
               window.location.href = deleteUrl;
           }
       }
    </script>

</div>
    <c:if test="${sessionScope.id != null}">
    <div class="mt-4">
        <form action="/api/v1/saveComment/${postView.id}" method="post">

                <label for="comment" class="form-label"><strong>댓글 작성</strong></label>
                <div class="mb-3 d-flex justify-content-end">
                <textarea class="form-control" id="comment" name="comment" rows="3" placeholder="주제와 무관한 댓글, 타인의 권리를 침해하거나 명예를 훼손하는&#10;게시물은 별도의 통보 없이 제재를 받을 수 있습니다" required></textarea>
                <button type="submit" class="btn btn-dark">작성</button>
            </div>
        </form>
    </div>

    <script>
        $(document).ready(function() {
            $('textarea').on('focus', function() {
                $(this).attr('placeholder', '');
            }).on('blur', function() {
                $(this).attr('placeholder', '주제와 무관한 댓글, 타인의 권리를 침해하거나 명예를 훼손하는\n게시물은 별도의 통보 없이 제재를 받을 수 있습니다');
            });
        });
    </script>

    </c:if>
   <div class="mt-4">
       <c:choose>
           <c:when test="${empty commentList}">
               <h6>첫 댓글을 작성해주세요</h6>
           </c:when>
           <c:otherwise>
               <h6>댓글 ${commentList[0].countAll}개</h6>
           </c:otherwise>
       </c:choose>

<ul class="list-group">
    <c:forEach var="comment" items="${commentList}">
        <li class="form-control">
            <div class="d-flex align-items-start">
                <div class="flex-grow-1">
                    <strong>${comment.nickName}</strong>
                    <span style="font-size: small; color: gray;">${comment.timeAgo}</span><br>
                    ${comment.comment}
                </div>
            </div>
            <c:if test="${comment.comment_author_id eq sessionScope.id}">
                <div class="d-flex justify-content-end">
                    <a class="btn btn-outline-dark btn-sm" onclick="modifyView('modify-${comment.id}')">수정</a>
                    <a href="/api/v1/deleteComment/${comment.id}/${postView.id}" class="btn btn-outline-dark btn-sm" onclick="confirmDelete(event)">삭제</a>
                </div>
            </c:if>
        </li>
        <li class="form-control modifyViews" id="modify-${comment.id}" style="display: none;">
            <form action="/api/v1/updateComment/${comment.id}/${postView.id}" method="post">
                <div class="d-flex align-items-start">
                    <textarea class="form-control flex-grow-1 border-0" name="comment">${comment.comment}</textarea>
                    <div class="ml-3 d-flex">
                        <button type="button" class="btn btn-dark" onclick="modifyCancel('modify-${comment.id}')">취소</button>
                        <button type="submit" class="btn btn-outline-dark">저장</button>
                    </div>
                </div>
            </form>
        </li>
    </c:forEach>
</ul>


 <script>
    function modifyView(modifyId) {
        const modifyElement = document.getElementById(modifyId);
        const commentElement = modifyElement.previousElementSibling;
        commentElement.style.display = "none";
        modifyElement.style.display = "block";
    }

    function modifyCancel(modifyId) {
        const modifyElement = document.getElementById(modifyId);
        const commentElement = modifyElement.previousElementSibling;
        commentElement.style.display = "block";
        modifyElement.style.display = "none";
    }

    function confirmDelete(event) {
        event.preventDefault();
        const deleteUrl = event.target.getAttribute('href');
        const confirmation = confirm("댓글을 완전히 삭제할까요?");
        if (confirmation) {
            window.location.href = deleteUrl;
        }
    }
 </script>
</div>
</div>
<br></br>
<br></br>
<%@ include file="../layout/footer.jsp" %>