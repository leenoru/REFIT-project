package com.refit.project.dto.campaign;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CampaignDto {
    private Integer campaign_id; //캠페인 번호
    private String campaign_name; // 캠페인 명
    private String campaign_company; // 캠페인 기업명
    private String thumbnail_file; // 썸네일 이미지 경로
    private String campaign_contents; // 캠페인 상세 내용
    private String campaign_reward; // 캠페인 혜택(쿠폰, 포인트)
    private String campaign_start_date; // 캠페인 시작일
    private String campaign_end_date; // 캠페인 종료일
    private String conditions; // 수거 조건
    private String cloth_subcategory; // 의류 카테고리 소분류
    private String created_at; // 생성시간
    private String campaign_type; // 캠페인 유형(리워드/소득공제/수익 등)
    private String campaign_area; // 캠페인 지역
    private String campaign_url; // 버튼이동 URL
}
