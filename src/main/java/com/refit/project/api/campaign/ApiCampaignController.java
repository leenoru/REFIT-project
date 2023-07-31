package com.refit.project.api.campaign;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.refit.project.dto.closet.ClosetDto;
import com.refit.project.service.closet.ClosetService;
import lombok.RequiredArgsConstructor;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.entity.mime.MultipartEntityBuilder;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Base64;
import org.json.JSONObject;
import java.io.*;

import org.apache.hc.core5.http.io.entity.StringEntity;
@RestController
@RequestMapping("/api/campaign")
@RequiredArgsConstructor
public class ApiCampaignController {

    @Autowired
    private ClosetService closetService;
    private ClosetDto closetDto;

    //컨트롤러가 JSP를 refresh하거나 다른 JSP로 이동하지 않고 결과를 리턴함
    @ResponseBody
    //url:webcamControl POST 방식 요청만 실행
    //랜덤한 마스크 위치를 리턴 할 컨트롤러
    @RequestMapping(value = "/doMatching", method = {RequestMethod.POST})

    //JSON 형태의 문자열을 리턴 할 것이므로 리턴 타입은 String
    //@RequestBody String img_data : 파일 내용과 같이 큰 사이즈의 데이터를 저장할 변수
    public String doMatching(@RequestBody String data, HttpServletRequest request) throws Exception {

        //webcam.jsp에서 전송한 내용 출력
        //System.out.println("data="+data);
        //webcam.jsp에서 전송한 내용에서 이미지만 리턴하기 위해서 문자열을 JSON 객체로 변환
        JSONObject dataObject = new JSONObject(data);
        //dataObject에서 키가 img_data인 값(업로드 이미지) 를 리턴

        String cloth_data = ((String) dataObject.get("img_data"));
        System.out.println("img_data="+cloth_data);

        //cloth_data 에서 data: 문자열 삭제
        cloth_data = cloth_data.replace("data:", "");
        //접속 할 Rest 서버의 url 설정
        HttpPost httpPost = new HttpPost("http://3.35.207.53:5000/predict");
        //전송할 데이터 타입 설정
        httpPost.addHeader("Content-Type", "application/json");
        //리턴 받을 데이터 타입 설정
        httpPost.setHeader("Accept", "application/json");
        //옷 이미지 저장
        StringEntity stringEntity = new StringEntity(cloth_data);
        //Rest Server로 전송할 객체 생성
        httpPost.setEntity(stringEntity);


        //Rest 서버의 함수를 호출할 객체 생성
        CloseableHttpClient httpclient = HttpClients.createDefault();
        //Rest 서버의 함수를 호출하고 리턴값을 가져올 객체 생성
        CloseableHttpResponse response2 = httpclient.execute(httpPost);

        //response2.getEntity() : Rest Server의 리턴값을 가져옴
        //Charset.forName("UTF-8") : Rest Server의 리턴값을 UTF-8로 인코딩

        //EntityUtils.toString(); : Rest Server의 리턴값을 String 으로 변환해서 flask_message 변수에 저장
        String flask_message = EntityUtils.toString(response2.getEntity(), Charset.forName("UTF-8"));
        System.out.println("flask_message="+flask_message);
        //플라스크 실행 결과를 JSON으로 변환 할 객체
        org.json.simple.parser.JSONParser parser = new org.json.simple.parser.JSONParser();
        //flask 실행 결과를 Object 로 변환
        Object obj = parser.parse( flask_message );
        //플라스크 실행 결과를 JSON으로 변환
        org.json.simple.JSONObject jsonObj = (org.json.simple.JSONObject) obj;
        //대 분류 리턴
        String clothCategory = (String)jsonObj.get("efficientnet_category");
        //소 분류 리턴
        String clothSubcategory = (String) jsonObj.get("resnet_category");

        //이미지를 배열로 변환
        byte[] cloth_data_arr  = Base64.getDecoder().decode(cloth_data.replace("image/jpeg;base64,",""));
        //이미지를 저장할 변수
        String filePath = request.getServletContext().getRealPath("/resources/image/closet");
        System.out.println("filePath="+filePath);
        //현재 날짜와 시간
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss_SSS");
        //파일명 앞에 현재 날짜와 시간 저장
        String fileName=sdf.format(new Date(System.currentTimeMillis())) + "_" +"closet.jpeg";
        System.out.println("filename="+fileName);
        //파일 저장
        OutputStream stream = new FileOutputStream(new File(filePath,fileName));
        stream.write(cloth_data_arr);
        //로그인 정보 가져 오기
        HttpSession session = request.getSession();
        //int userid= (Integer)session.getAttribute("id");
        //데이터베이스에 데이터 저장
        ClosetDto closetDto = new ClosetDto();
        closetDto.setCloth_path(fileName);
        closetDto.setCloth_category(clothCategory);
        closetDto.setCloth_subcategory(clothSubcategory);
        //closetDto.setId(userid);
        closetDto.setId(1);
        closetService.save(closetDto);
        System.out.println("data save");
        //분류 결과 리턴
        return flask_message;
    }
}

//    @RequestMapping(value="/doMatching" , method = { RequestMethod.POST})
//    public String doMatching(@RequestParam("upload") MultipartFile[] clothesImg, HttpServletRequest request) throws Exception {
////        String filePath = System.getProperty("user.dir") + File.separator + "src" + File.separator + "main" + File.separator
////                + "webapp" + File.separator + "resources" + File.separator + "image" + File.separator + "closet" + File.separator;
//        System.out.println("doMatching call");
//        String filePath = request.getServletContext().getRealPath("/resources/image/closet");
//        System.out.println("ApiCampaignController:doMatching:filePath="+filePath);
//        // 폴더 생성
//        File uploadDir = new File(filePath);
//        if (!uploadDir.exists()) {
//            uploadDir.mkdirs();
//        }
//
//        System.out.println('1');
//        // 서버 스토리지에 이미지 저장 clothImgSaved()
//        List<String> savedFilePath = new ArrayList<>();
//        if (clothesImg!=null && clothesImg.length>0) {
//            for (MultipartFile clothImg : clothesImg) {
//                String photoImg = null;
//                Base64.Encoder encoder = Base64.getEncoder();
//                byte[] photoEncode = encoder.encode(clothImg.getBytes());
//                photoImg = new String(photoEncode, "UTF8");
//
//                //접속 할 Rest 서버의 url 설정
//                HttpPost httpPost = new HttpPost("http://3.35.207.53/predict");
//                //전송할 데이터 타입 설정
//                httpPost.addHeader("Content-Type", "application/json");
//                //리턴 받을 데이터 타입 설정
//                httpPost.setHeader("Accept", "application/json");
//                //업로드한 이미지 저장
//                StringEntity stringEntity = new StringEntity(photoImg);
//                //Rest Server로 전송할 객체 생성
//                httpPost.setEntity(stringEntity);
//
//
//                //Rest 서버의 함수를 호출할 객체 생성
//                CloseableHttpClient httpclient = HttpClients.createDefault();
//                //Rest 서버의 함수를 호출하고 리컨값을 가져올 객체 생성
//                CloseableHttpResponse response2 = httpclient.execute(httpPost);
//
//                //response2.getEntity() : Rest Server의 리턴값을 가져옴
//                //Charset.forName("UTF-8") : Rest Server의 리턴값을 UTF-8로 인코딩
//
//                //EntityUtils.toString(); : Rest Server의 리턴값을 String 으로 변환해서 predict_message 변수에 저장
//                String predict_message = EntityUtils.toString(response2.getEntity(), Charset.forName("UTF-8"));
//                System.out.println("predict_message="+predict_message);
//
//            }
//        }
////            // "연월일_시분초_밀리초_파일명.확장자"로 파일이름생성
////            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss_SSS");
////            String originalFileName = clothImg.getOriginalFilename();
////
////            String savedFileName = sdf.format(new Date(System.currentTimeMillis())) + "_" +
////                    originalFileName.substring(0, originalFileName.lastIndexOf(".")) + "."
////                    + originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
////
////            File targetFile = new File(filePath + savedFileName);
////
////
////
////            // 파일을 업로드
////            try {
////                clothImg.transferTo(targetFile);
////                // 파일 경로 저장
////                savedFilePath.add(targetFile.getAbsolutePath());
////            } catch (Exception e) {
////                e.printStackTrace();
////            }
////        }
////        System.out.println(2);
////
////        //flask 파일 전송 및 결과 받기 getFlaskResponse()
////        CloseableHttpClient httpclient = HttpClients.createDefault();
////        //접속 할 Rest 서버의 url 설정
////        HttpPost httpPost = new HttpPost("http://3.35.207.53/predict");
////        //전송할 데이터 타입 설정
////        httpPost.addHeader("Content-Type", "multipart/form-data");
////        //리턴 받을 데이터 타입 설정
////        httpPost.setHeader("Accept", "application/json");
////
////        MultipartEntityBuilder builder = MultipartEntityBuilder.create();
////
////        //파일 생성 및 담기
////        int fileIndex = 0;
////        for (String savedFilepath : savedFilePath) {
////            File file = new File(savedFilepath);
////            builder.addBinaryBody("file" + fileIndex, file, ContentType.DEFAULT_BINARY, file.getName());
////            fileIndex++;
////        }
////
////        //Rest Server로 전송할 객체 생성
////        HttpEntity httpEntity = builder.build();
////        httpPost.setEntity(httpEntity);
////
////        //Flask 서버로부터 받아온 응답을 처리
////        //execute(httpPost) 메서드를 사용해 HTTP 요청을 전송하고, 결과를 CloseableHttpResponse 객체에 저장 후 인코딩
////        CloseableHttpResponse response = httpclient.execute(httpPost);
////        String responseBody = EntityUtils.toString(response.getEntity(), Charset.forName("UTF-8"));
////
////        System.out.println(3);
////        //DB에 저장
////        JsonArray jsonArray = new JsonParser().parse(responseBody).getAsJsonArray();
////
////        for (JsonElement jsonElement : jsonArray) {
////
////
////            JsonObject jsonObject = jsonElement.getAsJsonObject();
////            String clothPath = jsonObject.get("file_name").getAsString();
////            String clothCategory = jsonObject.get("cloth_category").getAsString();
////            String clothSubcategory = jsonObject.get("cloth_subcategory").getAsString();
////
////            ClosetDto closetDto = new ClosetDto();
////            closetDto.setCloth_path(clothPath);
////            closetDto.setCloth_category(clothCategory);
////            closetDto.setCloth_subcategory(clothSubcategory);
////
////            closetService.save(closetDto);
////        }
////        System.out.println(4);
////        }
//        return "redirect:/campaign/AI/doMatching";
//    }
//}