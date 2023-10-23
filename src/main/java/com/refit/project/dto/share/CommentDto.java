package com.refit.project.dto.share;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class CommentDto {
    public Long id; // 댓글 ID
    public Long postId; // 게시물 ID
    public String comment; // 댓글 내용
    public String author; // 댓글 작성자
    public Date created_at; // 댓글 생성일
    public long unix_created_at; // 댓글 생성일 (unix timestamp)
    public int comment_author_id; // 댓글 작성자 ID
    public String nickName; // 댓글 작성자 닉네임
    public String timeAgo; // 댓글 생성일부터 현재까지의 시간 경과
    public int countAll; // 댓글의 총 개수
}