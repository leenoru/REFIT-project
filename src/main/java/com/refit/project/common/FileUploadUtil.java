package com.refit.project.common;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/* 파일 업로드 유틸로 컨트롤러에서 사용*/
public class FileUploadUtil {
    static String filePath;

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
    /**
     * 업로드된 파일의 이름을 생성합
     * @param multipartFile 업로드된 파일
     * @return 업로드된 파일의 이름
     */
    public static String getFileName(MultipartFile multipartFile) {
        // 업로드된 파일의 원래 이름 가져옴
        String originalFileName = multipartFile.getOriginalFilename();
        // 업로드된 파일의 확장자(extension)를 가져옴(substring()을 통해 "." 이후 1(첫 번째)이후 모든 문자열 반환)
        String extension = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
        // 날짜와 시간을 포맷하는 포맷 객체를 생성
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss_SSS");
        // 날짜와 시간을 포함하는 고유한 파일 이름을 생성
        // sdf.format(new Date(System.currentTimeMillis()))은 현재 날짜와 시간을 포맷한 문자열을 반환
        // originalFileName.substring(0, originalFileName.lastIndexOf("."))은 originalFileName의 0번째부터 . 이전에 있는 문자열을 반환
        String savedFileName = sdf.format(new Date(System.currentTimeMillis())) + "_" +
                originalFileName.substring(0, originalFileName.lastIndexOf(".")) + "." + extension;
        // yyyyMMdd_HHmmss_SSS_originalFileName.extension 반환
        return savedFileName;
    }

    /**
     * 파일을 업로드
     * @param fileList     업로드할 파일 목록
     * @param fileNameList 업로드된 파일의 새로운 이름 목록
     */
    public static void upload(List<MultipartFile> fileList, List<String> fileNameList) {
        //filePath에 지정된 경로의 파일 객체를 생성
        File file = new File(filePath);
        // 파일 업로드를 위한 파일(디렉토리)가 존재하지 않으면 디렉토리 생성
        if (!file.exists()) {
            file.mkdir();
        }

        // 파일을 업로드
        // fileList가 null이 아닌 경우와 파일 개수가 0개 이상인 경우 실행
        if (fileList != null && fileList.size() > 0) {
            // 컨트롤러를 통해 전달 받은 파일 타입인 MultipartFile에 맞추어 반복문 실행
            for (MultipartFile multipartFile : fileList) {
                // multipartFile의 원래 파일 이름의 길이가 0인 경우(파일 이름이 없는 걍우)
                if (multipartFile.getOriginalFilename().length() == 0) {
                    // fileNameList에 빈 문자열을 추가
                    fileNameList.add("");
                    // for 루프의 다음 반복으로 이동
                    continue;
                }

                // multipartFile의 원래 파일 이름을 가져옴
                // getFileName 메서드에 따라 "yyyyMMdd_HHmmss_SSS"를 추가하여 파일명 변경
                String filename = getFileName(multipartFile);
                // fileNameList에 변경된 filename을 추가
                fileNameList.add(filename);
                // filePath(저장 경로)와 filename을 결합한 새로운 파일 이름 생성, File.separator : 파일 구분자(Windows에서는 \, Linux와 macOS에서는 /)
                String newFileName = String.format("%s" + File.separator + "%s", filePath, filename);

                // multipartFile을 새로운 파일 이름인 newFileName에 따라 지정된 경로에 업로드
                try {
                    multipartFile.transferTo(new File(newFileName));
                } catch (Exception e) {
                    // 예외는 콘솔에 출력
                    e.printStackTrace();
                }
            }
        }
    }
}
