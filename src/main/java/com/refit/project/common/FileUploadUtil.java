package com.refit.project.common;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/* 파일 업로드 유틸로 컨트롤러에서 사용*/
public class FileUploadUtil {
    static String filePath = "C:\\REFIT\\REFIT\\src\\main\\webapp\\resources\\image\\thumbnail";

    public static String getFilePath() {
        return filePath;
    }

    public static void setFilePath(String filePath) {
        FileUploadUtil.filePath = filePath;
    }

    /**
    * 새로운 파일명 생성(동일한 파일명 덮어 씌워짐 방지)
    * 대안 1번 image1(1).jpg, image2(2).jpg 방식
    * 대안 2번 오늘 날짜와 시간 밀리초 + 랜덤값쓰는 방식
    * 채택 2번 "yyyyMMdd_HHmmss_SSS" 형식 채택
    */
    public static String getFileName(MultipartFile multipartFile) {
        String originalFileName = multipartFile.getOriginalFilename();
        String extension = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss_SSS");
        String savedFileName = sdf.format(new Date(System.currentTimeMillis())) + "_" +
                originalFileName.substring(0, originalFileName.lastIndexOf(".")) + "." + extension;
        return savedFileName;
    }

    /**
     * 파일을 업로드
     * @param fileList     업로드할 파일 목록
     * @param fileNameList 업로드된 파일의 새로운 이름 목록
     */
    public static void upload(List<MultipartFile> fileList, List<String> fileNameList) {
        // 파일 업로드를 위한 디렉토리가 존재하지 않으면 생성
        File file = new File(filePath);
        if (!file.exists()) {
            file.mkdir();
        }

        // 파일을 업로드
        if (fileList != null && fileList.size() > 0) {
            for (MultipartFile multipartFile : fileList) {
                if (multipartFile.getOriginalFilename().length() == 0) {
                    fileNameList.add("");
                    continue;
                }

                String filename = getFileName(multipartFile);
                fileNameList.add(filename);

                String newFileName = String.format("%s" + File.separator + "%s", filePath, filename);
                try {
                    multipartFile.transferTo(new File(newFileName));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
