package com.refit.project.dao.campaign;

import com.refit.project.dto.campaign.CampaignDto;
import com.refit.project.dto.company.CompanyDto;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.*;


@Repository("campaignDao") //데이터 액세스 객체로 지정 및 빈 지정 등록
public class CampaignDao {

    @Autowired
    SqlSessionTemplate sm; //mybatis 객체

    // 캠페인 리스트 조회
    public List<CampaignDto> getCampaignList(String type) {
        return sm.selectList("campaign.Campaign_List", type);
    }

    // 캠페인 상세페이지 조회
    public CampaignDto getCampaignView(CampaignDto dto) {
        return sm.selectOne("Campaign_View", dto);
    }

    // 캠페인 추가
    public void campaignInsert(CampaignDto dto) {
        sm.insert("Campaign_Insert", dto); //void로 return을 쓰지 않는다
    }

    // 캠페인 수정
    public void campaignUpdate(CampaignDto dto) {
        sm.update("Campaign_Update", dto);
    }

    // 캠페인 삭제
    public void campaignDelete(CampaignDto dto) {
        sm.delete("Campaign_Delete", dto);
    }

    // 수거업체 지도검색
    public List<CampaignDto> getRewardCampaignList(String serviceLocation) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("serviceLocation", serviceLocation);
        return sm.selectList("campaign.getRewardCampaignByLocation", paramMap);
    }

    // AI 매칭완료 캠페인 리스트 조회
    public List<CampaignDto> getAiCampaignListBySubcategories(String type, List<String> clothingSubcategories) {
        Map<String, Object> parameters = new HashMap<>();

        System.out.println(clothingSubcategories);
        Set<String> uniqueSubcategories = new HashSet<>(clothingSubcategories);
        List<String> distinctClothingSubcategories = new ArrayList<>(uniqueSubcategories);
        System.out.println(distinctClothingSubcategories);

        String categories = "";
        for (String category : distinctClothingSubcategories) {
            categories = categories + "(?=.*" + category + ")";
        }

        System.out.println(categories);

        parameters.put("type", type);
        parameters.put("clothSubcategories", distinctClothingSubcategories);

        return sm.selectList("campaign.getAiCampaignListBySubcategories", parameters);
        //    (?=.*clothCusbcategory)
    }

}
