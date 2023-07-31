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

    @RequestMapping(value = "/uploadSummernoteImageFile", produces = "application/json; charset=utf8")
    @ResponseBody
    public String uploadSummernoteImageFile(@RequestParam("file") MultipartFile file, HttpServletRequest request, CampaignDto dto) {
        JsonObject jsonObject = new JsonObject();

        String root = request.getSession().getServletContext().getRealPath("resources");
        String fileRoot = root + "/image/campaign/";

        File folder = new File(fileRoot);
        if (!folder.exists()) {
            folder.mkdirs();
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss_SSS");
        String originalFileName = file.getOriginalFilename();
        String savedFileName = sdf.format(new Date(System.currentTimeMillis())) + "_" +
                originalFileName.substring(0, originalFileName.lastIndexOf(".")) + "."
                + originalFileName.substring(originalFileName.lastIndexOf(".") + 1);

        // String renamePath = folder + "\\" + savedFileName;

        File targetFile = new File(fileRoot + savedFileName);

        try {
            InputStream fileStream = file.getInputStream();
            FileUtils.copyInputStreamToFile(fileStream, targetFile); // 파일 저장
            jsonObject.addProperty("url", request.getContextPath() + "/resources/image/campaign/" + savedFileName); // contextroot + resources
            // 저장할 내부 폴더명
            jsonObject.addProperty("responseCode", "success");

        } catch (IOException e) {
            FileUtils.deleteQuietly(targetFile); // 저장된 파일 삭제
            jsonObject.addProperty("responseCode", "error");
            e.printStackTrace();
        }
        String a = jsonObject.toString();
        return a;
    }
}
