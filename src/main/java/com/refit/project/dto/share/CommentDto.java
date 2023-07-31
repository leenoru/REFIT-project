package com.refit.project.dto.share;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class CommentDto {
    public Long id;
    public Long postId;
    public String comment;
    public String author;

    public Date created_at;
    public long unix_created_at;
    public int comment_author_id;

    public String nickName;

    public String timeAgo;

    public int countAll;

}