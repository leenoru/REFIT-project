package com.refit.project.controller.share;

import com.refit.project.dto.share.BoardDto;
import com.refit.project.dto.share.CommentDto;
import com.refit.project.dto.share.PageDto;
import com.refit.project.service.share.BoardService;
import com.refit.project.service.share.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class ShareController {


    private final BoardService boardService;
    private final CommentService commentService;


    @GetMapping("/share/index")
    public String getList(Model model, @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        List<BoardDto> pagingList = boardService.getList(page);
        PageDto pageDto = boardService.pagingParam(page);

        model.addAttribute("dtoList", pagingList);
        model.addAttribute("paging", pageDto);
        return "share-index";
    }

    @GetMapping("/share/index/search")
    public String getSearchedList(Model model, @RequestParam(value = "page", required = false, defaultValue = "1") int page, @RequestParam("keyword") String keyword) {
        List<BoardDto> pagingList = boardService.getSearchedList(page, keyword);
        //검색한 총 게시글 불러오기
        List<BoardDto> searchedListAll = boardService.getSearchedListAll(keyword);

        PageDto pageDto = boardService.searchedPagingParam(page, searchedListAll);

        model.addAttribute("dtoList", pagingList);
        model.addAttribute("paging", pageDto);
        return "share-index";
    }

    @GetMapping("share/posts/save")
    public String save() {
        return "share-posts-save";
    }

    @PostMapping("/api/v1/posts")
    public String saveApi(Model model, BoardDto dto, HttpSession session) {
        dto.setAuthor_id((Integer) session.getAttribute("id"));
        //본문 텍스트와 이미지 텍스트 분리 작업
        BoardDto dto1 = FirstImageExtractor.extractImageText(dto);

        boardService.save(dto1);
        return "redirect:/share/index";
    }

    @GetMapping("share/posts/view/{id}")
    public String getView(Model model, @PathVariable Long id) {
        model.addAttribute("postView", boardService.getView(id));
        model.addAttribute("commentList", commentService.getList(id));

        return "share-posts-view";
    }


    @GetMapping("share/posts/update/{id}")
    public String update(Model model, @PathVariable Long id) {
        model.addAttribute("postUpdate", boardService.getView(id));
        return "share-posts-update";
    }

    @PostMapping("/api/v1/update/{id}")
    public String updateApi(@PathVariable Long id, BoardDto dto) {
        dto.setId(Math.toIntExact(id));
        BoardDto dto1 = FirstImageExtractor.extractImageText(dto);
        boardService.update(dto1);
        return "redirect:/share/posts/view/{id}";
    }

    @GetMapping("/api/v1/delete/{id}")
    public String delete(@PathVariable Long id) {
        boardService.delete(id);
        return "redirect:/share/index";
    }

    @PostMapping("/api/v1/saveComment/{postId}")
    public String saveCommentApi(@PathVariable Long postId, CommentDto dto, HttpSession session) {
        dto.setComment_author_id((Integer) session.getAttribute("id"));
        dto.setPostId(postId);
        commentService.save(dto);
        return "redirect:/share/posts/view/{postId}";
    }

    @GetMapping("/share/comments/update/{commentId}")
    public String updateComment(Model model, @PathVariable Long commentId) {
        model.addAttribute("commentView", commentService.commentView(commentId));
        return "test2";
    }

    @PostMapping("/api/v1/updateComment/{commentId}/{postId}")
    public String updateCommentApi(@PathVariable Long commentId, Long postId, CommentDto dto){
        dto.setId(commentId);
        commentService.update(dto);
        return "redirect:/share/posts/view/{postId}";
    }

    @GetMapping("/api/v1/deleteComment/{commentId}/{postId}")
    public String deleteCommentApi(@PathVariable Long commentId, Long postId, CommentDto dto){
        dto.setId(commentId);
        commentService.delete(commentId);
        return "redirect:/share/posts/view/{postId}";
    }

}

