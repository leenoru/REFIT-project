package com.refit.project.controller.share;

import com.refit.project.dto.share.BoardDto;

public class FirstImageExtractor {

    public static BoardDto extractImageText(BoardDto dto) {
        // 이미지 시작 및 종료 태그
        String imgStartTag = "<img";
        String imgEndTag = "\">";

        String content = dto.getOriginalContent();
        StringBuilder imageTexts = new StringBuilder();

        int startIndex = content.indexOf(imgStartTag);
        while (startIndex != -1) {
            int endIndex = content.indexOf(imgEndTag, startIndex) + imgEndTag.length();

            if (endIndex != -1) {
                // 이미지 텍스트 추출
                String imageText = content.substring(startIndex, endIndex);
                imageTexts.append(imageText).append(", ");
            }

            startIndex = content.indexOf(imgStartTag, startIndex + 1);
        }

        String imageTextsString = imageTexts.toString().trim();
        if (imageTextsString.endsWith(",")) {
            imageTextsString = imageTextsString.substring(0, imageTextsString.length() - 1);
        }

        dto.setImageText(imageTextsString);

        // 이미지 텍스트 제거 후 남은 content 데이터 추출
        String remainingContent = content.replaceAll("<img[^>]*>", "");
        dto.setContent(remainingContent);

        return dto;
    }
}
