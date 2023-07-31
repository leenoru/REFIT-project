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
public class AIController {

    private final CampaignService campaignService;

    @Autowired
    public AIController(CampaignService campaignService) {
        this.campaignService = campaignService;
    }

    @RequestMapping(value="/campaign/AI" , method = {RequestMethod.GET, RequestMethod.POST})
    public String aiMatching() {
        return "campaign/AIMatching";
    }

    @RequestMapping(value = "/campaign/AI/doMatching", method = RequestMethod.GET)
    public String aiDoMatching(Model model, @RequestParam String subCategories) {

        System.out.println(10);
        System.out.println(subCategories);

        // 쉼표로 구분된 문자열을 분리하고 리스트로 변환
        String[] strArray = subCategories.split(",");
        List<String> clothingSubcategories = Arrays.asList(strArray);

        // 중복 제거
        Set<String> uniqueSubcategories = new LinkedHashSet<>(clothingSubcategories);
        clothingSubcategories = new ArrayList<>(uniqueSubcategories);

        System.out.println(clothingSubcategories);

        // 타입별 정렬된 캠페인 목록 가져오기
        List<CampaignDto> matchingRewardList = campaignService.getAiCampaignListBySubcategories("reward", clothingSubcategories);
        List<CampaignDto> matchingProfitList = campaignService.getAiCampaignListBySubcategories("profit", clothingSubcategories);
        List<CampaignDto> matchingDonationList = campaignService.getAiCampaignListBySubcategories("donation", clothingSubcategories);

        // 모델 객체에 데이터 저장
        model.addAttribute("matchingRewardList", matchingRewardList);
        model.addAttribute("matchingProfitList", matchingProfitList);
        model.addAttribute("matchingDonationList", matchingDonationList);
        model.addAttribute("clothingSubcategories", clothingSubcategories);

        // 결과 페이지로 리다이렉트
        return "campaign/doMatching";
    }
}
