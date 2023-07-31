package com.refit.project.service.share;

import com.refit.project.dao.share.BoardDao;
import com.refit.project.dto.share.BoardDto;
import com.refit.project.dto.share.PageDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class BoardService {

    private final BoardDao boardDao;
    private final int pageLimit = 12; //한 페이지당 보여줄 글 갯수
    private final int blockLimit = 3; //하단에 보여줄 페이지 번호 갯수

    public List<BoardDto> getMainList(){
       return boardDao.getMainList();
    }
    public List<BoardDto> getList(int page) {

        int pageStart = (page - 1) * pageLimit;

        Map<String, Integer> pagingParams = new HashMap<>();
        pagingParams.put("start", pageStart);
        pagingParams.put("limit", pageLimit);

        List<BoardDto> pagingList = boardDao.getList(pagingParams);
        return pagingList;

    }

    public List<BoardDto> getSearchedList(int page, String keyword) {

        BoardDto dto = new BoardDto();
        int pageStart = (page - 1) * pageLimit;

        dto.setKeyword(keyword);
        dto.setStart(pageStart);
        dto.setLimit(pageLimit);

        List<BoardDto> pagingList = boardDao.getSearchedList(dto);
        return pagingList;

    }

    public PageDto pagingParam(int page) {
        // 전체 글 갯수 조회
        int boardCount = boardDao.boardCount();
        // 전체 페이지 갯수 계산(10/3=3.33333 => 4)
        int maxPage = (int) (Math.ceil((double) boardCount / pageLimit));
        // 시작 페이지 값 계산(1, 4, 7, 10, ~~~~)
        int startPage = (((int)(Math.ceil((double) page / blockLimit))) - 1) * blockLimit + 1;
        // 끝 페이지 값 계산(3, 6, 9, 12, ~~~~)
        int endPage = startPage + blockLimit - 1;
        if (endPage > maxPage) {
            endPage = maxPage;
        }
        PageDto pageDTO = new PageDto();
        pageDTO.setPage(page);
        pageDTO.setMaxPage(maxPage);
        pageDTO.setStartPage(startPage);
        pageDTO.setEndPage(endPage);
        return pageDTO;
    }

    public PageDto searchedPagingParam(int page, List<BoardDto> searchedListAll) {
        // 검색된 전체 글 갯수 조회
        int boardCount = searchedListAll.size();
        // 전체 페이지 갯수 계산(10/3=3.33333 => 4)
        int maxPage = (int) (Math.ceil((double) boardCount / pageLimit));
        // 시작 페이지 값 계산(1, 4, 7, 10, ~~~~)
        int startPage = (((int)(Math.ceil((double) page / blockLimit))) - 1) * blockLimit + 1;
        // 끝 페이지 값 계산(3, 6, 9, 12, ~~~~)
        int endPage = startPage + blockLimit - 1;
        if (endPage > maxPage) {
            endPage = maxPage;
        }
        PageDto pageDTO = new PageDto();
        pageDTO.setPage(page);
        pageDTO.setMaxPage(maxPage);
        pageDTO.setStartPage(startPage);
        pageDTO.setEndPage(endPage);
        return pageDTO;
    }
    public List<BoardDto> getSearchedListAll(String keyword) {
        return boardDao.getSearchedListAll(keyword);
    }

    public BoardDto getView(Long id) {
        return boardDao.getView(id);
    }

    public void save(BoardDto dto) {

        long currentTimestamp = Instant.now().getEpochSecond();
        dto.setUnix_created_at(currentTimestamp);
        boardDao.save(dto);
    }

    public void update(BoardDto dto) {
        boardDao.update(dto);
    }

    public void delete(Long id) {
        boardDao.delete(id);
    }

}