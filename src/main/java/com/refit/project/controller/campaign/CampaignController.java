package com.refit.project.controller.campaign;

import com.google.gson.Gson;
import com.refit.project.common.FileUploadUtil;
import com.refit.project.dto.campaign.CampaignDto;
import com.refit.project.service.campaign.CampaignService;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
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
@RequiredArgsConstructor // 생성자 주입
public class CampaignController {

    private final CampaignService campaignService;

    // 리워드형 캠페인 리스트 조회
    @RequestMapping("/campaign/reward") //(<=>@GetMapping)
    public String getRewardCampaign(Model model) {    //Model : 뷰에 데이터를 전달하는 데 사용되는 객체
        List<CampaignDto> rewardList = campaignService.getCampaignList("reward");
        System.out.println(rewardList);
        //addAttribute() 메서드를 사용하여 뷰에 속성을 추가, key(속성을 사용할 때 쓰는 이름)와 value(뷰에 전달할 데이터)를 매개변수로 받음
        model.addAttribute("rewardList", rewardList); //rewardList 속성에 reward 타입의 캠페인 목록을 저장
        return "campaign/reward_list"; // view로 응답 전달
    }

    // 기부형 캠페인 리스트 조회
    @RequestMapping("/campaign/donation")
    public String getDonationCampaign(Model model) {
        List<CampaignDto> donationList = campaignService.getCampaignList("donation");
        System.out.println(donationList);
        model.addAttribute("donationList", donationList);
        return "campaign/donation_list";
    }

    // 수익형 캠페인 리스트 조회
    @RequestMapping("/campaign/profit")
    public String getProfitCampaign(Model model) {
        List<CampaignDto> profitList = campaignService.getCampaignList("profit");
        System.out.println(profitList);
        model.addAttribute("donationList", profitList);
        return "campaign/donation_list";
    }

    // 캠페인 상세페이지 조회
    @RequestMapping("/campaign/{campaign_id}")
    public String campaign_view(@PathVariable("campaign_id")int campaign_id, Model model, CampaignDto dto)
    {
        dto.setCampaign_id(campaign_id);
        CampaignDto resultDto = campaignService.getCampaignView(dto);
        model.addAttribute("viewDto", resultDto);
        return "campaign/campaign_view";
    }

    // 캠페인 추가 등록
    @RequestMapping("/campaign/write")
    public String campaign_write(Model model, CampaignDto campaignDto) {
        model.addAttribute("writeDto", new CampaignDto());
        return "campaign/campaign_write";
    }

    // 캠페인 추가 등록 시 파일 업로드 및 내용 등록
    /** MultipartHttpServletRequest는 Multipart/'form'-data로 전송된 요청을 처리하는 데 사용되는 인터페이스
        Multipart/form-data는 '파일' 업로드와 함께 '텍스트 데이터'를 전송할 때 사용되는 HTTP 요청 방식으로
        Multipart/form-data로 전송된 데이터는 HTTP 요청 본문에 포함됨
        MultipartHttpServletRequest는 HTTP 요청 본문에 포함된 데이터를 추출하여 처리할 수 있는 인터페이스
        아래 코드에서는 getFile() 메서드를 사용하여 inputThumbnailFile 이름의 파일을 가져옴 */
    @RequestMapping(value = "/campaign/save", produces = "application/json; charset=UTF-8")
    @ResponseBody // 다른 페이지로 이동하지 않고 응답처리
    String save(MultipartHttpServletRequest multi, CampaignDto dto, HttpServletRequest request)
    {
        // 파일을 저장할 폴더의 경로
        // 프로젝트 폴더의 `resources/image/` 폴더의 실제 경로 가져오기, 서블릿 컨텍스트의 RealPath
        String absolutePath = request.getSession().getServletContext().getRealPath("/resources/image/");
        System.out.println("********************************");

        List<MultipartFile> multiList = new ArrayList<MultipartFile>();
        multiList.add(multi.getFile("inputThumbnailFile"));

        List<String> fileNameList = new ArrayList<String>();
        String path = absolutePath + "thumbnail";

        // FileUploadUtil 클래스를 통한 파일 업로드
        FileUploadUtil.setFilePath(path);
        FileUploadUtil.upload(multiList, fileNameList);

        // dto에 파일명이 변경된 파일 리스트 중 첫번째(썸네일)파일명 담기
        dto.setThumbnail_file(fileNameList.get(0));

        // Gson : Java 객체와 JSON 데이터를 서로 변환할 수 있는 라이브러리(JSONArray는 Gson 객체의 toJson() 메서드를 사용하여 JSON 문자열로 변환)
        Gson gson = new Gson();
        // 입력된 서브카테고리를 dto에 JSON 문자열로 저장
        dto.setCloth_subcategory(
                // inlineCheckbox 이름의 체크박스에서 선택한 값(체크박스의 value 값)을 배열로 가져오기
                // Arrays.stream() 메서드를 사용하여 배열을 스트림으로 변환(stream은 배열, 컬렉션, 파일 등의 데이터를 스트림으로 변환 가능)
                // collect() 메서드를 사용하여 스트림을 JSONArray 객체로 변환(collect() 메서드를 사용하여 스트림의 요소를 원하는 방식으로 수집)
                // toJSONString() 메서드를 사용하여 JSONArray 객체를 JSON 문자열로 변환
                // CampaignDto 객체의 cloth_subcategory 속성에 JSON 문자열을 설정
                Arrays.stream(multi.getParameterValues("inlineCheckbox"))
                .collect(JSONArray::new, JSONArray::add, JSONArray::addAll).toJSONString());

        // dto에 selectBox를 통해 입력된 캠페인 타입 담기(HTML 태그 중 name 혹은 id일 getParameter를 통해 입력된 값을 가져올 수 있음)
        dto.setCampaign_type(multi.getParameter("selectBox"));

        // 디버깅 용도
        System.out.println("campaignController" + "save :" +absolutePath);
        System.out.println(multi.getParameter("selectBox"));
        System.out.println(dto.getCampaign_name());
        System.out.println(dto.getCampaign_type());
        System.out.println(dto.getCampaign_reward());
        System.out.println(dto.getCampaign_contents());

        // 값을 담은 dto를 campaignService를 통해 데이터베이스에 저장
        campaignService.campaignInsert(dto);

        // 캠페인 등록 성공 응답 반환
        //ajax로 호출해서 파일 저장하고 DB에 저장까지 모든 과정
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("result", "success");
        return jsonObject.toString();
    }

    // 캠페인 수정
    @RequestMapping("/campaign/modify")
    String campaign_modify(Model model, Integer campaign_id)
    {
        CampaignDto paramDto = new CampaignDto();
        paramDto.setCampaign_id(campaign_id);
        CampaignDto resultDto = campaignService.getCampaignView(paramDto);
        model.addAttribute("writeDto", resultDto);
        model.addAttribute("campaign_id", campaign_id);
        return "campaign/campaign_write";
    }

    // 캠페인 수정 등록 (캠페인 추가 등록 시 파일 업로드 및 내용 등록과 동일)
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
}
