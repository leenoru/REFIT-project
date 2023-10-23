package com.refit.project.service.campaign;

import com.refit.project.dao.campaign.CampaignDao;
import com.refit.project.dto.campaign.CampaignDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("campaignService")
@RequiredArgsConstructor // Service라는 빈이 생성될때 final로 선언된 필드(CampaignDao)를 스프링이 알아서 주입해 줌
public class CampaignService {

    private final CampaignDao campaignDao;

    /** 캠페인 리스트 조회
     * @param type 캠페인 유형
     * @return 캠페인 유형에 해당하는 캠페인 리스트
     */
    public List<CampaignDto> getCampaignList(String type) {
        return campaignDao.getCampaignList(type);
    }

    /** 캠페인 상세페이지 조회
     * @param dto 조회할 캠페인 정보를 담고 있는 dto
     * @return 조회할 캠페인 정보
     */
    public CampaignDto getCampaignView(CampaignDto dto) {
        return campaignDao.getCampaignView(dto);
    }

    /** 캠페인 추가 등록
     * @param dto 등록할 캠페인 정보를 담고 있는 dto
     */
    public void campaignInsert(CampaignDto dto) {
        campaignDao.campaignInsert(dto);
    }

    /** 캠페인 수정
     * @param dto 수정할 캠페인 정보를 담고 있는 dto
     */
    public void campaignUpdate(CampaignDto dto) {
        campaignDao.campaignUpdate(dto);
    }

    /** 캠페인 삭제
     * @param dto 삭제할 캠페인 정보를 담고 있는 dto
     */
    public void campaignDelete(CampaignDto dto) {
        campaignDao.campaignDelete(dto);
    }

    /** 수거업체 지도 조회
     * @param serviceLocation 수거 지역
     * @return 지역에 맞는 수거업체(리워드형) 캠페인리스트
     */
    public List<CampaignDto> getRewardCampaignList(String serviceLocation) {
        return campaignDao.getRewardCampaignList(serviceLocation);
    }

    /** AI 매칭 결롸 캠페인 리스트 조회
     * @param type 캠페인 유형 (reward, profit, donation)
     * @param clothingSubcategories AI 매칭 결과로 추출한 의류 카테고리 소분류 리스트
     * @return AI 매칭 결과에 따라 조회한 캠페인 리스트
     */
    public List<CampaignDto> getAiCampaignListBySubcategories(String type, List<String> clothingSubcategories) {
        System.out.println(type);
        System.out.println(clothingSubcategories);
        return campaignDao.getAiCampaignListBySubcategories(type, clothingSubcategories);
    }
}
