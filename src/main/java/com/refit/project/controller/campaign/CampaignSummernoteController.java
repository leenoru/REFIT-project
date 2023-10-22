package com.refit.project.controller.campaign;

import com.google.gson.JsonObject;
import com.refit.project.dto.campaign.CampaignDto;
import lombok.RequiredArgsConstructor;
import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

@Controller
@RequiredArgsConstructor
public class CampaignSummernoteController {
    // 써머노트는 이미지 파일을 업로드할 때 onImageUpload() 콜백 함수를 사용
    // onImageUpload() 콜백 함수, 업로드 이미지 파일의 정보를 JSON 객체로 반환(url, responseCode 등)
    @RequestMapping(value = "/uploadSummernoteImageFile", produces = "application/json; charset=utf8")
    @ResponseBody
    public String uploadSummernoteImageFile(@RequestParam("file") MultipartFile file, HttpServletRequest request, CampaignDto dto) {
        // JSON 객체 생성
        JsonObject jsonObject = new JsonObject();
        // 파일이 저장될 경로 지정
        String root = request.getSession().getServletContext().getRealPath("resources");
        String fileRoot = root + "/image/campaign/";
        // 해당 경로에 폴더(파일)가 없을 시 폴더 생성
        File folder = new File(fileRoot);
        if (!folder.exists()) {
            folder.mkdirs();
        }
        // 저장될 파일 명 앞에 올 날짜(파일명 중복 방지)
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss_SSS");
        // 업로드된 파일의 원래 이름
        String originalFileName = file.getOriginalFilename();
        // 20231022_130000_000_test.jpg
        String savedFileName = sdf.format(new Date(System.currentTimeMillis())) + "_" +
                // 파일명
                originalFileName.substring(0, originalFileName.lastIndexOf(".")) + "."
                // 확장자
                + originalFileName.substring(originalFileName.lastIndexOf(".") + 1);

        // 업로드된 파일이 저장될 파일 객체 생성
        File targetFile = new File(fileRoot + savedFileName);

        try {
            // 업로드된 파일의 내용을 스트림으로 반환
            InputStream fileStream = file.getInputStream();
            // FileUtils의 메서드를 통해 스트림을 targetFile 객체(경로)에 파일로 생성(복사)
            FileUtils.copyInputStreamToFile(fileStream, targetFile);
            // JSON에 url, responseCode 속성 추가
            jsonObject.addProperty("url", request.getContextPath() + "/resources/image/campaign/" + savedFileName);
            jsonObject.addProperty("responseCode", "success");

        } catch (IOException e) {
            // 저장된 파일 삭제
            FileUtils.deleteQuietly(targetFile);
            // 에러 응답 반환
            jsonObject.addProperty("responseCode", "error");
            e.printStackTrace();
        }
        // JSON 객체를 문자열로 변환 및 반환(클라이언트에서 JSON 문자열을 파싱하여 처리 위함)
        String data = jsonObject.toString();
        return data;
    }
}
