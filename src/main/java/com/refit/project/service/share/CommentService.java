package com.refit.project.service.share;

import com.refit.project.dao.share.CommentDao;
import com.refit.project.dto.share.CommentDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentDao commentDao;
    public List<CommentDto> getList(Long postId) {
        return commentDao.getList(postId);

    }

    public CommentDto commentView(Long id) {
        return commentDao.commentView(id);
    }
    public void save(CommentDto dto) {
        long currentTimestamp = Instant.now().getEpochSecond();
        dto.setUnix_created_at(currentTimestamp);
        commentDao.save(dto);
    }


    public void update(CommentDto dto) {
        commentDao.update(dto);
    }

    public void delete(Long id) {
        commentDao.delete(id);
    }
}
