package com.refit.project.dao.share;

import com.refit.project.controller.share.Duration;
import com.refit.project.dto.share.CommentDto;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository("commentDao")
@RequiredArgsConstructor
public class CommentDao {
    //대충 상속받은 인터페이스를 찾아서 객체를 전달
    private final SqlSessionTemplate sm; //mybatis 객체


    public List<CommentDto> getList(Long postId) {
        List<CommentDto> dtoList = sm.selectList("Comment_getList", postId);
        for (CommentDto dto : dtoList) {

            dto.setTimeAgo(Duration.getDuration(dto.getUnix_created_at()));
        }

        return dtoList;
    }

    public CommentDto commentView(Long id) {
        CommentDto dto = sm.selectOne("Comment_getView", id);
        return dto;
    }




    public void save(CommentDto dto) {
        sm.insert("Comment_save", dto);
    }


    public void update(CommentDto dto) {
        sm.update("Comment_update", dto);

    }

    public void delete(Long id) {
        System.out.println("db 삭제 전입니다.");
        sm.delete("Comment_delete", id);
        System.out.println("db 삭제 했습니다.");
    }

}
