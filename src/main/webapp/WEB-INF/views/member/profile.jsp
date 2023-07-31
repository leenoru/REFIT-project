<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
<!DOCTYPE html>
<%@ include file="../../layout/header.jsp" %>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"
        integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div class="container" style="margin-top:50px;">
    <div class="container col-md-8">
        <h1 style="text-align: center; font-size:20px;">
            <span style="font-size: 24px; font-weight: bold; color: gray;">${sessionScope.nickname}</span> 님 환영합니다👋
        </h1>
        <br>
        <div style="width: 62%; margin: auto;">

                <div colspan="2">
                    <div style="margin: auto; width: 100%;">


                                <li class="form-control" style="text-align: left; display: flex; align-items: center;">
                                    <span style="margin-right: 10px;">닉네임</span>&nbsp;&nbsp;&nbsp;&nbsp;
                                    <p name="nicknameEdit" style="display: inline; margin: 0; font-weight: bold; margin-right: 10px;">${sessionScope.nickname}</p>
                                    &nbsp;&nbsp;<button class="btn btn-outline-success btn-sm" name="nicknameEdit" onclick="toggle('nicknameEdit');">닉네임 변경</button>
                                    <input type="text" name="nicknameEdit" id="modifiedNickname" style="display: none; font-weight: bold; margin-right: 10px;" value="${sessionScope.nickname}">
                                    <button class="btn btn-dark btn-sm" name="nicknameEdit" onclick="toggle('nicknameEdit');" style="display: none;">취소</button>
                                    <button class="btn btn-outline-success btn-sm" name="nicknameEdit" onclick="editNickname(modifiedNickname.value);" style="display: none;">저장</button>
                                </li>

                                <li class="form-control" style="text-align: left;">
                                비밀번호&nbsp;&nbsp;
                                <strong>******</strong>&nbsp;&nbsp;
                                &nbsp;&nbsp;&nbsp;&nbsp;<button type="button" class="btn btn-outline-success btn-sm" onclick="editPassword()">비밀번호 변경</button>
                                </li>



                        <div class="container" style="display: flex;">
                            <div>
                                <!--
                                <p name="nicknameEdit">${sessionScope.nickname}</p>
                                <input type="text" name="nicknameEdit" id="modifiedNickname" style="display: none;"
                                    value="${sessionScope.nickname}">
                                -->
                            </div>
                        </div>
                        <li class="form-control">

                            <div style="display: flex;">
                              <div style="text-align: left; width: 200px; font-weight: bold; color: gray;">카카오 로그인 연동</div>
                              <div style="text-align: center; width: 200px;">
                                <% if (session.getAttribute("kakao") == null) { %>
                                  <a href="https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=<spring:eval expression="@property['kakao.client_id']"/>&redirect_uri=<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/member/connectKakao&state=${sessionScope.id}">
                                    <span class="badge text-bg-primary">OFF</span>
                                  </a>
                                <% } else { %>
                                  <span class="badge text-bg-secondary">ON</span>
                                <% } %>
                              </div>
                            </div>
                            <br>
                            <div style="display: flex;">
                            <div style="text-align: left; width: 200px; font-weight: bold; color: gray;">네이버 로그인 연동</div>
                                <div style="text-align: center; width: 200px;">
                                    <%if (session.getAttribute("naver") == null) {%>
                                      <span class="badge text-bg-primary">OFF</span>
                                    <% } else { %>
                                      <span class="badge text-bg-secondary">ON</span>
                                    <% } %>
                                <div>
                            </div>
                                <%
                                    String redirectURI = URLEncoder.encode(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/member/connectNaver", "UTF-8");
                                    String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
                                    String state = session.getAttribute("id").toString();
                                    apiURL += "&redirect_uri=" + redirectURI;
                                    apiURL += "&state=" + state;
                                    apiURL += "&client_id=";
                                    session.setAttribute("state", state);
                                %>
                            </div>
                        </div>
                        <br>
                            <div style="display: flex;">
                              <div style="text-align: left; width: 200px; font-weight: bold; color: gray;">구글 로그인 연동</div>
                              <div style="text-align: center; width: 200px;">
                                <% if (session.getAttribute("google") == null) { %>
                                  <% redirectURI = URLEncoder.encode(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/member/connectGoogle", "UTF-8");
                                     apiURL = "https://accounts.google.com/o/oauth2/v2/auth?";
                                     apiURL += "&redirect_uri=" + redirectURI;
                                     apiURL += "&response_type=code";
                                     apiURL += "&state=" + session.getAttribute("id").toString();
                                     apiURL += "&scope=profile";
                                     apiURL += "&client_id=";
                                     session.setAttribute("state", state);
                                  %>
                                  <a href="<%=apiURL%><spring:eval expression="@property['google.client_id']"/>">
                                    <span class="badge text-bg-primary">OFF</span>
                                  </a>
                                <% } else { %>
                                  <span class="badge text-bg-secondary">ON</span>
                                <% } %>
                              </div>
                            </div>


                            <div style="width: 60%; text-align: left;">

                            </div>
                        </div>
                        </li>


                            <div></div>
                            <div style="display: flex; justify-content: flex-end;">
                                <button type="button" class="btn btn-outline-success btn-sm" onclick="quit()">회원탈퇴</button>
                            </div>


                    </div>
                </div>
<div class="container" style="margin-top:50px;">
    <div class="container col-md-8">
        <div>
            <div>
                <div colspan="2">
                    <h2 style="font-size:18px;">🥼 옷장</h2>
                </div>
            </div>
            <div>
                <div style="border: 1px solid #000000; width: 100%;" colspan="2">
                    <div id="closetTable"></div>
                </div>
            </div>
            <div>
                <div>
                    <img>
                </div>
            </div>
            <div>
                <div>
                    <ul class="image-preview"></ul>
                    <ul class="result-preview"></ul>
                </div>
            </div>
            <div>
                <div>
                    <form id="uploadForm" enctype="multipart/form-data" method="post" action="<%=request.getContextPath()%>/api/closet/save">
                        <input type="file" class="upload" id="upload" name="upload" accept="image/" required multiple>
                        <input type="submit">옷장 등록</input>
                    </form>
                </div>
            </div>
            <div style="text-align: right;">
                <div>
                    <button class="btn btn-outline-success">AI 매칭받기</button>
                </div>
            </div>
        </div>
    </div>
</div>
    </div>
</div>
</div>
</div>
<br>
<br>
<br>
<br>
<br>




<style>
  .btn {
    color: black; /* 초기 버튼 텍스트 색상 */
    background-color: white; /* 초기 버튼 배경색 */
    border: 1px solid black; /* 검은색 테두리 */
  }

  .btn:hover {
    color: white; /* 마우스 호버 시 텍스트 색상 */
    background-color: black; /* 마우스 호버 시 배경색 */
  }
</style>


<script>
    const toggle = (name) => {
        let element = document.getElementsByName(name);
        for (let e of element) {
            e.style.display = ((e.style.display != 'none') ? 'none' : 'block');
        }
    }
    const editNickname = (name) => {
        toggle('nicknameEdit');
        $.ajax({
            type: "POST",
            url: "<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/api/member/modify-nickname",
            data: {
                "id": ${sessionScope.id},
                "newName": name
            },
            success: function () {
                window.location.reload();
            },
            error: function (err) {
                console.log("에러발생", err);
            }
        });
    }
    const editPassword = () => {
        let popup = window.open("<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/member/editPasswordPopup", "비밀번호 수정", "width=500, height=200, location=no");
        // $.ajax({
        //     url: "member/editPassword",
        //     method: "post",
        //     data: formData,
        //     dataType: ""
        // })
    }
    const quit = () => {
        $.ajax({
            type: "POST",
            url: "<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>/api/member/quit",
            data: {
                "id": ${sessionScope.id}
            },
            success: function () {
                location.replace("<%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%><%=request.getContextPath()%>")
            },
            error: function (err) {
                console.log("에러발생", err);
            }
        })
    }
</script>

<script>
 $(document).ready(function() {
     // 세션에서 ID를 가져옵니다.
     var userId = <%= session.getAttribute("id") %>;
    $.ajax({
      type: "GET",
      url: "/api/closet/" + userId,
      success: function(data) {
      console.log("data");
      console.log(data);
        var closets = data;
        var closetData = "";
        closets.forEach(function(closet) {
          var imagePath = "${pageContext.request.contextPath}/resources/image/closet/" + closet.cloth_path;
          closetData += "<div style='padding: 10px; display: inline-block;'>";
          closetData += "<img src='" + imagePath + "' alt='이미지' style='width: 200px; height: 200px;' onclick='confirmDelete(" + parseInt(closet.closet_id) + ")'>";


          /*
          closetData += "<div>" + closet.cloth_category + "</div>";
          closetData += "<div>" + closet.cloth_subcategory + "</div>";
          */

          closetData += "</div>";

        });
        $('#closetTable').html(closetData);

      },
      error: function() {
        // 에러 처리 로직 작성
        console.log("옷장 내용을 가져오지 못했습니다.");
      }
    });
});
</script>

<script>
 // 나눔 삭제 sweetalert2 메시지 창
function confirmDelete(closetId) {
  Swal.fire({
    title: '의류를 옷장에서 제거하시겠습니까?',
    text: '의류를 나눔 하시겠습니까?',
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: '삭제',
    cancelButtonText: '취소',
    showDenyButton: true,
    denyButtonText: '나눔'
  }).then((result) => {
    if (result.isConfirmed) {
      deleteImage(closetId);
    } else if (result.isDenied) {
      openSharePrompt(closetId);
    }
  });
}

function openSharePrompt(closetId) {
  Swal.fire({
    title: '나눔하기',
    html:
      '<input id="titleInput" class="swal2-input" placeholder="제목">' +
      '<textarea id="contentInput" class="swal2-input" placeholder="내용"></textarea>',
    confirmButtonText: '저장',
    cancelButtonText: '취소',
    showCancelButton: true,
    showLoaderOnConfirm: true,
    preConfirm: () => {
      const title = Swal.getPopup().querySelector('#titleInput').value;
      const content = Swal.getPopup().querySelector('#contentInput').value;
      const data = {
        closetId: closetId,
        title: title,
        content: content
      };
      saveShareData(data, closetId);
    }
  });
}

function saveShareData(data, closetId) {
  $.ajax({
    type: 'POST',
    url: '/api/v1/posts',
    data: data,
    success: function(response) {
      // 데이터 저장이 성공한 경우
      Swal.fire('성공', '데이터가 저장되었습니다.', 'success');
    },
    error: function(xhr, status, error) {
      // 데이터 저장이 실패한 경우
      Swal.fire('오류', '데이터 저장에 실패했습니다.', 'error');
      console.error('데이터 저장에 실패했습니다:', error);
    }
  });
  deleteImage(closetId);
}

function deleteImage(closetId) {
  // 서버로 삭제 요청을 보냄
  $.ajax({
    type: 'DELETE',
    url: '/api/closet/' + closetId,
    success: function (response) {
      // 삭제가 성공한 경우 동작
      Swal.fire('성공', '이미지가 삭제되었습니다.', 'success');
      console.log('이미지가 삭제되었습니다.');
    },
    error: function (xhr, status, error) {
      // 삭제가 실패한 경우 동작
      Swal.fire('오류', '이미지 삭제에 실패했습니다.', 'error');
      console.error('이미지 삭제에 실패했습니다:', error);
    }
  });
}

</script>
<script>
    const uploadFiles = [];
    function getImageFiles(e) {
        const files = e.currentTarget.files;
        console.log(typeof files, files);
        document.querySelector('.image-preview').replaceChildren();
        [...files].forEach(file => {
            if (!file.type.match("image/.*")) {
                alert('이미지 파일만 업로드가 가능합니다.');
                return;
            }
            uploadFiles.push(file);
            const reader = new FileReader();
            reader.onload = (e) => {
                const preview = createElement(e, file);
                document.querySelector('.image-preview').appendChild(preview);
            };
            reader.readAsDataURL(file);
        });
    }; // 프리뷰 보여주기
    function createElement(e, file) {
        const li = document.createElement('li');
        const img = document.createElement('img');
        img.setAttribute('src', e.target.result);
        img.setAttribute('data-file', file.name);
        li.appendChild(img);
        return li;
    }
    function saveCloset() {
        /* Spring: 파일을 저장하고, 파일명 생성해서 리턴
           {
                index : url
            } -> Flask
            Flask: index url 이미지를 inference 하여 결과를 Spring 으로 리턴
            {
                index : result
            }
            Spring:
            Front:
        */
        let imageInput = $("#upload")[0];
        let formData = new FormData();
        formData.append("images", imageInput.files[0]);
        $.ajax({
            type: "POST",
            url: "<%=request.getContextPath()%>/api/closet/save",
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                let jsonArr = JSON.parse(response);
                for(idx in jsonArr) {
                    let preview = document.createElement('li');
                    let res = JSON.parse(idx);
                    preview.appendChild(res['category_l1']);
                    preview.appendChild(res['category_l2']);
                    document.querySelector('.result-preview').appendChild(preview);
                }
            }
        });
    };
    const upload = document.querySelector('.upload');
    upload.addEventListener('change', getImageFiles);
</script>

<%@ include file="../../layout/footer.jsp" %>