package com.refit.project.controller.share;

import com.refit.project.dto.campaign.CampaignDto;
import com.refit.project.dto.share.BoardDto;
import com.refit.project.dto.share.PageDto;
import com.refit.project.service.campaign.CampaignService;
import com.refit.project.service.share.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final BoardService boardService;

    @GetMapping("/")
    public String main(Model model) {

        List<BoardDto> MainShareList = boardService.getMainList();

        model.addAttribute("MainShareList", MainShareList);
        return "main";
    }

    @GetMapping("/collection")
    public String collection() {
        return "collection";
    }
}
