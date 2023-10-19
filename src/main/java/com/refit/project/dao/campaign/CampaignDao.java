package com.refit.project.dao.campaign;

import com.refit.project.dto.campaign.CampaignDto;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.*;


@Repository("campaignDao") //데이터 액세스 객체 DAO(Data Access Object)로 지정 및 빈 지정 등록
@RequiredArgsConstructor // final로 선언된 필드만 주입, 생성자에만 적용할 수 있음, 순환 참조 문제 방지(<=> @Autowired)
public class CampaignDao {

    private final SqlSessionTemplate sm; //SqlSessionTemplate은 mybatis의 SqlSession을 래핑한 스프링 빈

    // 캠페인 리스트 조회
    public List<CampaignDto> getCampaignList(String type) {
        return sm.selectList("CampaignMapper.Campaign_List", type); //namespace.selectObjects
    }

    // 캠페인 상세페이지 조회
    public CampaignDto getCampaignView(CampaignDto dto) {
        return sm.selectOne("CampaignMapper.Campaign_View", dto);
    }

    // 캠페인 추가 등록
    public void campaignInsert(CampaignDto dto) {
        sm.insert("CampaignMapper.Campaign_Insert", dto); //insert로 return할 것이 없음(void로 작성)
    }

    // 캠페인 수정
    public void campaignUpdate(CampaignDto dto) {
        sm.update("CampaignMapper.Campaign_Update", dto); //update로 return할 것이 없음(void로 작성)
    }

    // 캠페인 삭제
    public void campaignDelete(CampaignDto dto) {
        sm.delete("CampaignMapper.Campaign_Delete", dto); //delete로 return할 것이 없음(void로 작성)
    }

    // 수거업체 지도 조회
    public List<CampaignDto> getRewardCampaignList(String serviceLocation) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("serviceLocation", serviceLocation);
        return sm.selectList("CampaignMapper.getRewardCampaignByLocation", paramMap);
    }

    // AI 매칭완료 캠페인 리스트 조회
    public List<CampaignDto> getAiCampaignListBySubcategories(String type, List<String> clothingSubcategories) {
        System.out.println(clothingSubcategories);

        //중복을 제거를 위한 HashSet을 사용, 중복 제거 새로운 Set 객체인 uniqueSubcategories를 생성
        Set<String> uniqueSubcategories = new HashSet<>(clothingSubcategories);
        //MyBatis foreach문 지원 태그를 사용하기 위한 과정, 전달받은 collection 인자로 List or Array 형태만 가능
        List<String> distinctClothingSubcategories = new ArrayList<>(uniqueSubcategories);
        System.out.println(distinctClothingSubcategories);

//        String categories = "";
//        for (String category : distinctClothingSubcategories) {
//            categories = categories + "(?=.*" + category + ")";
//        }
//        System.out.println(categories);
//        (?=.*clothCusbcategory)

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("type", type);
        paramMap.put("clothSubcategories", distinctClothingSubcategories);

        return sm.selectList("CampaignMapper.getAiCampaignListBySubcategories", paramMap);
    }

}
