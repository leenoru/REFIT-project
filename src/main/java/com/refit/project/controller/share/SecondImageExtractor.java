package com.refit.project.controller.share;

import java.util.ArrayList;
import java.util.List;

public class SecondImageExtractor {

    public static List<String> extractImageText(String content) {
        // 이미지 시작 및 종료 태그
        String imgStartTag = "src=\"";
        String imgEndTag = "\" data";

        List<String> imageTextList = new ArrayList<>();

        int startIndex = content.indexOf(imgStartTag);
        int endIndex = content.indexOf(imgEndTag, startIndex);

        while (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
            // 이미지 텍스트 추출
            String imageText = content.substring(startIndex + imgStartTag.length(), endIndex);

            // 이미지 텍스트 디코딩
            // byte[] imageData = Base64.getDecoder().decode(imageText);

            // 추출한 이미지 텍스트를 리스트에 추가
            imageTextList.add(imageText);

            // 다음 이미지 텍스트를 찾기 위해 인덱스 업데이트
            startIndex = content.indexOf(imgStartTag, endIndex);
            endIndex = content.indexOf(imgEndTag, startIndex);
        }

        return imageTextList;
    }

}