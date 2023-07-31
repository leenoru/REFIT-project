package com.refit.project.dao.share;

import com.refit.project.controller.share.Duration;
import com.refit.project.controller.share.SecondImageExtractor;
import com.refit.project.dto.share.BoardDto;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository("boardDao")
@RequiredArgsConstructor
public class BoardDao {

    private final SqlSessionTemplate sm; //mybatis 객체
    public List<BoardDto> getMainList(){
        List<BoardDto> MainList = sm.selectList("Board_GetMainList");
        System.out.println("db에 갔다 왔습니다.");
        for (BoardDto dto : MainList) {
            List<String> imageTexts = SecondImageExtractor.extractImageText(dto.getImageText());
            dto.setImageText2(imageTexts);
        }
        System.out.println("이미지 추출했습니다.");
        return MainList;
    }

    public List<BoardDto> getList(Map<String, Integer> pagingParams) {
        List<BoardDto> dtoList = sm.selectList("Board_GetList", pagingParams);
//        System.out.println(dtoList.get(0).getContent());

        for (BoardDto dto : dtoList) {

            dto.setFormattedCreatedAt(Duration.getDuration(dto.getUnix_created_at()));

            List<String> imageTexts = SecondImageExtractor.extractImageText(dto.getImageText());
            dto.setImageText2(imageTexts);


        }
//        System.out.println("이미지 텍스트 : " + dtoList.get(4).getImageText());
        return dtoList;
    }

    public List<BoardDto> getSearchedList(BoardDto boardDto) {

        List<BoardDto> dtoList = sm.selectList("Board_GetSearchedList", boardDto);

        for (BoardDto dto : dtoList) {

            dto.setFormattedCreatedAt(Duration.getDuration(dto.getUnix_created_at()));

            List<String>  imageTexts = SecondImageExtractor.extractImageText(dto.getImageText());
            dto.setImageText2(imageTexts);
        }
        return dtoList;
    }

    public List<BoardDto> getSearchedListAll(String keyword) {
        List<BoardDto> dtoList = sm.selectList("Board_GetSearchedListAll", keyword);

        return dtoList;
    }

    public BoardDto getView(Long id) {
        BoardDto dto = sm.selectOne("Board_getView", id);
        dto.setFormattedCreatedAt(Duration.getDuration(dto.getUnix_created_at()));

        List<String> imageTexts = SecondImageExtractor.extractImageText(dto.getImageText());

        dto.setImageText2(imageTexts);
        return dto;
    }
    public void save(BoardDto dto) {
        sm.insert("Board_save", dto);
    }
    public void update(BoardDto dto) {
        sm.update("Board_update", dto);
    }

    public void delete(Long id) {
        sm.delete("Board_delete", id);
    }

    public int boardCount() {
        return sm.selectOne("Board_boardCount");
    }
}