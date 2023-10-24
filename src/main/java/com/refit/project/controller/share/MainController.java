package com.refit.project.controller.share;

import com.refit.project.dto.share.BoardDto;
import com.refit.project.service.share.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 메인 페이지 컨트롤러
 */
@Controller
@RequiredArgsConstructor
public class MainController {

    private final BoardService boardService;

    /**
     * 메인 페이지 나눔 게시판 영역
     * @param model 나눔 게시글 정보 담길 model
     * @return 메인 페이지 view
     */
    @GetMapping("/")
    public String main(Model model) {
        List<BoardDto> MainShareList = boardService.getMainList();
        model.addAttribute("MainShareList", MainShareList);
        return "main";
    }

    /**
     * 의류 수거함 지도 영역
     * @return 의류 수거함 view
     */
    @GetMapping("/collection")
    public String collection() {
        return "collection";
    }
}