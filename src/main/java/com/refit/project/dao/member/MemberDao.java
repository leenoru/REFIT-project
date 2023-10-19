package com.refit.project.dao.member;

import com.refit.project.dto.member.MemberDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.*;

@Repository
@RequiredArgsConstructor
public class MemberDao {
    private final SqlSessionTemplate sql;

    /**
     * 회원가입
     * @param memberDTO
     */
    public int register(MemberDTO memberDTO) { return sql.insert("Member.register", memberDTO); }

    /**
     * 이메일로 사용자 찾기
     * @param loginEmail
     */
    public MemberDTO findByEmail(String loginEmail) { return sql.selectOne("Member.findByEmail", loginEmail); }

    /**
     * 카카오 ID로 사용자 찾기
     * @param kakaoId
     */
    public MemberDTO findByKakao(String kakaoId) { return sql.selectOne("Member.findByKakao", kakaoId); }

    /**
     * 네이버 ID로 사용자 찾기
     * @param naverId
     */
    public MemberDTO findByNaver(String naverId) { return sql.selectOne("Member.findByNaver", naverId); }

    /**
     * 구글 ID로 사용자 찾기
     * @param googleId
     * @return
     */
    public MemberDTO findByGoogle(String googleId) { return sql.selectOne("Member.findByGoogle", googleId); }

    /**
     * 카카오 연동하기
     * @param id
     * @param kakaoId
     */
    public void connectKakao(String id, String kakaoId) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", Long.parseLong(id));
        map.put("kakao", kakaoId);
        sql.update("Member.connectKakao", map);
    }

    /**
     * 네이버 연동하기
     * @param id
     * @param naverId
     */
    public void connectNaver(String id, String naverId) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", Long.parseLong(id));
        map.put("naver", naverId);
        sql.update("Member.connectNaver", map);
    }

    /**
     * 구글 연동하기
     * @param state
     * @param googleId
     */
    public void connectGoogle(String state, String googleId) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", Long.parseLong(state));
        map.put("google", googleId);
        sql.update("Member.connectGoogle", map);
    }

    /**
     * 사용자 삭제
     * @param id
     */
    public void delete(Long id) { sql.delete("Member.delete", id); }

    /**
     * 비밀번호 조회
     * @param id
     */
    public String getPassword(String id) { return sql.selectOne("Member.getPassword", Long.parseLong(id));}

    /**
     * 닉네임 변경
     * @param nickname
     * @param id
     */
    public void modifyNickname(String nickname, String id) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("nickname", nickname);
        map.put("id", Long.parseLong(id));
        sql.update("Member.modifyNickname", map);
    }

    /**
     * 비밀번호 변경
     * @param password
     * @param id
     */
    public void modifyPassword(String password, Integer id) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("password", password);
        map.put("id", id);
        sql.update("Member.modifyPassword", map);
    }

}









