package com.refit.project.dto.share;


import lombok.Getter;
import lombok.Setter;

import java.io.File;
import java.util.Date;
import java.util.List;

@Getter
@Setter
public class BoardDto  {
    private int id;
    private String title="";
    private String content="";

    private String imageText="";
    private Date created_at;
    private long unix_created_at;
    private String formattedCreatedAt;

    private int author_id;

    private String region;

    private String nickName;

    private String keyword;

    private int start;
    private int limit;

    private List<String> imageText2;

    private String originalContent;


    @Override
    public String toString() {
        return "BoardDto{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", imageText='" + imageText + '\'' +
                ", created_at=" + created_at +
                ", unix_created_at=" + unix_created_at +
                ", formattedCreatedAt='" + formattedCreatedAt + '\'' +
                ", author_id=" + author_id +
                '}';
    }
}