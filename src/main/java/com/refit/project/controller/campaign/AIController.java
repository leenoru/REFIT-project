package com.refit.project.controller.campaign;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.refit.project.dto.campaign.CampaignDto;
import com.refit.project.service.campaign.CampaignService;
import lombok.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
@RequiredArgsConstructor
public class AIController {

    private final CampaignService campaignService;

    /**
     * AI 매칭 시작 페이지
     * @return AI 매칭 시작 페이지, 이미지 업로드를 위한 페이지(view)로 이동
     */
    @RequestMapping(value="/campaign/AI" , method = {RequestMethod.GET, RequestMethod.POST})
    public String aiMatching() {
        return "campaign/AIMatching";
    }

    /**
     * AI 매칭 결과 페이지
     * @param subCategories 플라스크서버 AI로 부터 매칭 완료된 서브카테고리 ex) 상의,하의
     * @return AI 매칭 결과를 보여주는 페이지(view)로 이동
     */
    @RequestMapping(value = "/campaign/AI/doMatching", method = RequestMethod.GET)
    public String aiDoMatching(Model model, @RequestParam String subCategories) {

        System.out.println(subCategories);

        // subCategories 변수의 값을 쉼표로 구분하여 문자열 배열로 변환
        // split() 메서드는 주어진 문자열을 특정 문자로 구분하여 배열로 변환
        String[] strArray = subCategories.split(",");
        // 문자열 배열을 리스트로 변환([상의, 하의, 신발])
        List<String> clothingSubcategories = Arrays.asList(strArray);

        // 리스트에서 중복된 요소를 제거(LinkedHashSet은 중복된 요소를 허용하지 않는 컬렉션)
        Set<String> uniqueSubcategories = new LinkedHashSet<>(clothingSubcategories);
        // 중복 요소가 제거된 리스트를 다시 생성
        clothingSubcategories = new ArrayList<>(uniqueSubcategories);

        System.out.println(clothingSubcategories);

        // 타입별 정렬된 캠페인 목록 가져오기
        List<CampaignDto> matchingRewardList = campaignService.getAiCampaignListBySubcategories("reward", clothingSubcategories);
        List<CampaignDto> matchingProfitList = campaignService.getAiCampaignListBySubcategories("profit", clothingSubcategories);
        List<CampaignDto> matchingDonationList = campaignService.getAiCampaignListBySubcategories("donation", clothingSubcategories);

        // 모델 객체에 각 캠페인 유형 별 데이터 저장
        model.addAttribute("matchingRewardList", matchingRewardList);
        model.addAttribute("matchingProfitList", matchingProfitList);
        model.addAttribute("matchingDonationList", matchingDonationList);
        // 분류한 카테고리
        model.addAttribute("clothingSubcategories", clothingSubcategories);

        // 결과 페이지로 리다이렉트
        return "campaign/doMatching";
    }
}
