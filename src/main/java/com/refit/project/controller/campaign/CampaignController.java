package com.refit.project.controller.campaign;

import com.google.gson.Gson;
import com.refit.project.common.FileUploadUtil;
import com.refit.project.dto.campaign.CampaignDto;
import com.refit.project.service.campaign.CampaignService;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class CampaignController {

    @Autowired
    private final CampaignService campaignService;

    @RequestMapping("/campaign/reward")
    public String getRewardCampaign(Model model) {
        List<CampaignDto> rewardList = campaignService.getCampaignList("reward");
        System.out.println(rewardList);
        model.addAttribute("rewardList", rewardList);
        return "campaign/reward_list";
    }

    @RequestMapping("/campaign/donation")
    public String getDonationCampaign(Model model) {
        List<CampaignDto> donationList = campaignService.getCampaignList("donation");
        System.out.println(donationList);
        model.addAttribute("donationList", donationList);
        return "campaign/donation_list";
    }

    @RequestMapping("/campaign/profit")
    public String getProfitCampaign(Model model) {
        List<CampaignDto> profitList = campaignService.getCampaignList("profit");
        System.out.println(profitList);
        model.addAttribute("donationList", profitList);
        return "campaign/donation_list";
    }


    @RequestMapping(value="/campaign/write")
    String campaign_write(Model model, CampaignDto campaignDto) {
        model.addAttribute("writeDto", new CampaignDto());
        return "campaign/campaign_write";
    }

    @RequestMapping(value = "/campaign/save", produces = "application/json; charset=UTF-8")
    @ResponseBody // 다른 페이지로 이동하지 않음
    String save(MultipartHttpServletRequest multi, CampaignDto dto, HttpServletRequest request)
    {
        String absolutePath = request.getSession().getServletContext().getRealPath("/resources/image/");
        System.out.println("********************************");
        List<MultipartFile> multiList = new ArrayList<MultipartFile>();
        multiList.add(multi.getFile("inputThumbnailFile"));

        List<String> fileNameList = new ArrayList<String>();
        String path = absolutePath + "thumbnail";
        FileUploadUtil.setFilePath(path);
        FileUploadUtil.upload(multiList, fileNameList);

        dto.setThumbnail_file(fileNameList.get(0));
        Gson gson = new Gson();
        dto.setCloth_subcategory(Arrays.stream(multi.getParameterValues("inlineCheckbox"))
                .collect(JSONArray::new, JSONArray::add, JSONArray::addAll).toJSONString());
        dto.setCampaign_type(multi.getParameter("selectBox"));

        System.out.println("campaignController" + "save" +absolutePath);
        System.out.println(multi.getParameter("selectBox"));
        System.out.println(dto.getCampaign_name());
        System.out.println(dto.getCampaign_type());
        System.out.println(dto.getCampaign_reward());
        System.out.println(dto.getCampaign_contents());

        campaignService.campaignInsert(dto);
        JSONObject map = new JSONObject();
        map.put("result", "success");
        return map.toString(); //ajax로 호출해서 파일 저장하고 DB에 저장까지
    }

    @RequestMapping(value="/campaign/{campaign_id}")
    String campaign_view(@PathVariable("campaign_id")int campaign_id, Model model, CampaignDto dto)
    {
        dto.setCampaign_id(campaign_id);
        CampaignDto resultDto = campaignService.getCampaignView(dto);
        model.addAttribute("viewDto", resultDto);
        return "campaign/campaign_view";
    }

    @RequestMapping(value="/campaign/modify")
    String campaign_modify(Model model, Integer campaign_id)
    {
        CampaignDto paramDto = new CampaignDto();
        paramDto.setCampaign_id(campaign_id);
        CampaignDto resultDto = campaignService.getCampaignView(paramDto);
        model.addAttribute("writeDto", resultDto);
        model.addAttribute("campaign_id", campaign_id);
        return "campaign/campaign_write";
    }

    @RequestMapping(value = "/campaign/update", produces = "application/json; charset=UTF-8")
    @ResponseBody
    String campaign_update(MultipartHttpServletRequest multi, CampaignDto dto, HttpServletRequest request) {

        String absolutePath = request.getSession().getServletContext().getRealPath("/resources/image/");
        System.out.println("********************************");
        List<MultipartFile> multiList = new ArrayList<MultipartFile>();
        multiList.add(multi.getFile("inputThumbnailFile"));

        List<String> fileNameList = new ArrayList<String>();
        String path = absolutePath + "thumbnail";
        FileUploadUtil.setFilePath(path);
        FileUploadUtil.upload(multiList, fileNameList);

        dto.setThumbnail_file(fileNameList.get(0));
        Gson gson = new Gson();
        dto.setCloth_subcategory(Arrays.stream(multi.getParameterValues("inlineCheckbox"))
                .collect(JSONArray::new, JSONArray::add, JSONArray::addAll).toJSONString());
        dto.setCampaign_type(multi.getParameter("selectBox"));

        System.out.println("campaignController" + "save" +absolutePath);
        System.out.println(multi.getParameter("selectBox"));
        System.out.println(dto.getCampaign_name());
        System.out.println(dto.getCampaign_type());
        System.out.println(dto.getCampaign_reward());
        System.out.println(dto.getCampaign_contents());
        System.out.println(dto.getThumbnail_file());

        campaignService.campaignUpdate(dto);
        JSONObject map = new JSONObject();
        map.put("result", "success");
        return map.toString(); //ajax로 호출해서 파일 저장하고 DB에 저장까지
    }

    @RequestMapping("/campaign/delete")
    public String campaign_delete(@RequestParam("campaign_id")Integer campaign_id, CampaignDto dto, @RequestParam("campaign_type") String campaign_type) {
        dto.setCampaign_id(campaign_id);
        String destination = "/campaign/" + dto.getCampaign_type();
        campaignService.campaignDelete(dto);
        System.out.println("CampaignController" + "campaign_delete" + destination);
        return "forward:" + destination;
    }

//    // 수거업체 지도 노출
//    @GetMapping("/collection/search")
//    public List<CampaignDto> searchProfitCampaign(@RequestParam("serviceLocation") String serviceLocation) {
//        System.out.println("검색 요청받은 serviceLocation: " + serviceLocation);
//
//        List<CampaignDto> companies;
//        if (serviceLocation != null && !serviceLocation.isEmpty()) {
//            companies = campaignService.getRewardCampaignList(serviceLocation);
//        } else {
//            System.out.println("검색 요청이 실패했습니다.");
//            companies = new ArrayList<>(); // 빈 리스트 반환 또는 예외 처리 등의 처리를 수행할 수 있습니다.
//        }
//        return companies;
//    }
}
