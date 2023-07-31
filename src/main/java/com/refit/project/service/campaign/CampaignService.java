package com.refit.project.service.campaign;

import com.refit.project.dao.campaign.CampaignDao;
import com.refit.project.dao.company.CompanyDao;
import com.refit.project.dto.campaign.CampaignDto;
import com.refit.project.dto.company.CompanyDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("campaignService")
public class CampaignService {

    @Autowired
    CampaignDao campaignDao;

    // 캠페인 리스트 조회
    public List<CampaignDto> getCampaignList(String type) {
        return campaignDao.getCampaignList(type);
    }

    // 캠페인 상세페이지 조회
    public CampaignDto getCampaignView(CampaignDto dto) {
        return campaignDao.getCampaignView(dto);
    }

    // 캠페인 추가
    public void campaignInsert(CampaignDto dto) {
        campaignDao.campaignInsert(dto);
    }

    // 캠페인 수정
    public void campaignUpdate(CampaignDto dto) {
        campaignDao.campaignUpdate(dto);
    }

    // 캠페인 삭제
    public void campaignDelete(CampaignDto dto) {
        campaignDao.campaignDelete(dto);
    }

    // 수거업체 지도 조회
    public List<CampaignDto> getRewardCampaignList(String serviceLocation) {
        return campaignDao.getRewardCampaignList(serviceLocation);
    }

    //AI 매칭완료 페이지
    public List<CampaignDto> getAiCampaignListBySubcategories(String type, List<String> clothingSubcategories) {
        System.out.println(type);
        System.out.println(clothingSubcategories);
        return campaignDao.getAiCampaignListBySubcategories(type, clothingSubcategories);
    }
}
