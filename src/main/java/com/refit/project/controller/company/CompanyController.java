package com.refit.project.controller.company;

import com.refit.project.dto.campaign.CampaignDto;
import com.refit.project.service.campaign.CampaignService;
import lombok.*;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/collection")
@RequiredArgsConstructor
public class CompanyController {

    private final CampaignService campaignService;
    @GetMapping("/search")
    public List<CampaignDto> searchCompanies(@RequestParam("serviceLocation") String serviceLocation) {
        System.out.println("검색 요청받은 serviceLocation: " + serviceLocation);

        List<CampaignDto> companies;
        if (serviceLocation != null && !serviceLocation.isEmpty()) {
            companies = campaignService.getRewardCampaignList(serviceLocation);
        } else {
            System.out.println("검색 요청이 실패했습니다.");
            companies = new ArrayList<>(); // 빈 리스트 반환 또는 예외 처리 등의 처리를 수행할 수 있습니다.
        }
        return companies;
    }
}

