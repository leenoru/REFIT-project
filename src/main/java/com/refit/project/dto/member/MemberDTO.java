package com.refit.project.dto.member;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberDTO {
    private Integer id;
    private String email;
    private String password;
    private String nickname;
    private String kakao;
    private String naver;
    private String google;
}