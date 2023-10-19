package com.refit.project.dto.campaign;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter //Get 요청의 경우 JSON 데이터가 아닌 Query Parameter, setter 혹은 ControllerAdvice 선언
@ToString // 디버깅 및 로깅 사용
public class CampaignDto {
    private Integer campaign_id; //캠페인 번호
    private String campaign_name; // 캠페인 이름
    private String campaign_company; // 캠페인 진행 기업명
    private String thumbnail_file; // 썸네일 이미지 경로
    private String campaign_contents; // 캠페인 상세 내용
    private String campaign_reward; // 캠페인 노출 혜택
    private String campaign_start_date; // 캠페인 시작일
    private String campaign_end_date; // 캠페인 종료일
    private String conditions; // 수거 조건
    private String cloth_subcategory; // 의류 카테고리 소분류
    private String created_at; // 캠페인 생성 시간
    private String campaign_type; // 업로드될 캠페인 유형(리워드/소득공제/수익 등)
    private String campaign_area; // 캠페인 지역
    private String campaign_url; // 버튼 클릭 시 이동 URL
}
