package com.refit.project.dto.share;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@ToString // 디버깅 용도, 콘솔에 필드와 매칭되는 값 출력
public class BoardDto  {
    private int id; // 게시글 ID
    private String title=""; // 게시글 제목
    private String content=""; // 게시글 내용
    private Date created_at; // 생성일
    private long unix_created_at; // 생성일 (unix timestamp), 정렬, 검색
    private int author_id; // 작성자 ID
    private String region; // 나눔 지역
    private String nickName; // 작성자 닉네임
    private String imageText=""; // 이미지 데이터
    private String originalContent; // 원본 내용
    private String formattedCreatedAt; // 생성 날짜 (포맷팅된 형식)
    private String keyword; // 게시물 검색 키워드
    private int start; // 게시물 목록 조회 시작 인덱스
    private int limit; // 한 페이지당 게시글 수
    private List<String> imageText2; // 이미지 텍스트 목록

}