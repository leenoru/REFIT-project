package com.refit.project.controller.member;

import com.refit.project.dto.member.*;
import com.refit.project.service.member.*;
import lombok.*;
import org.springframework.stereotype.*;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.*;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    // 회원가입 뷰
    @GetMapping("/register")
    public String registerEmail() { return "member/register"; }

    // 이메일 회원가입
    @PostMapping("/registerEmail")
    public String registerEmail(@ModelAttribute MemberDTO memberDTO) {
        memberService.register(memberDTO.getEmail(), memberDTO.getPassword(), memberDTO.getNickname(), null, null, null);
        return "member/login";
    }

    /**
     * 카카오 회원가입
     * @param code : 카카오 로그인 코드
     * @param session : 세션
     * @return  회원가입 성공시 DB에 회원정보 저장, 로그인페이지로 이동
     *          회원가입 실패
     *          1. 이미 가입된 회원
     *              메시지를 띄워주고 로그인페이지로 이동
     */
    @GetMapping("/registerKakao")
    public String registerKakao(@RequestParam String code, HttpSession session) throws Exception {
        String kakaoId = memberService.getKakaoId(code);
        MemberDTO result = memberService.findByKakao(kakaoId);
        if(result != null) {
            session.setAttribute("msg", "이미 가입된 사용자입니다.");
            session.setAttribute("url", "/member/login");
            return "member/alert";
        } else {
            memberService.register(null, null, null, kakaoId, null, null);
            return "member/login";
        }
    }

    /**
     * 네이버 회원가입
     * @param code
     * @param state
     * @param session
     * @return
     */
    @GetMapping("/registerNaver")
    public String registerNaver(@RequestParam String code, @RequestParam String state, HttpSession session) throws Exception {
        String naverId = memberService.getNaverId(code, state);
        MemberDTO result = memberService.findByNaver(naverId);
        if(result != null) {
            session.setAttribute("msg", "이미 가입된 사용자입니다.");
            session.setAttribute("url", "/member/login");
            return "member/alert";
        } else {
            memberService.register(null, null, null, null, naverId, null);
            return "member/login";
        }
    }

    /**
     * 구글 회원가입
     * @param code
     * @param state
     * @param request
     * @return
     */
    @GetMapping("/registerGoogle")
    public String registerGoogle(@RequestParam String code, @RequestParam String state, HttpServletRequest request) throws Exception {
        String googleId = memberService.getGoogleId(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/member/registerGoogle", code, state);
        MemberDTO result = memberService.findByGoogle(googleId);
        if(result != null) {
            request.getSession().setAttribute("msg", "이미 가입된 사용자입니다.");
            request.getSession().setAttribute("url", "/member/login");
            return "member/alert";
        } else {
            memberService.register(null, null, null, null, null, googleId);
            return "member/login";
        }
    }

    // 로그인 뷰
    @GetMapping("/login")
    public String loginForm() { return "member/login"; }

    /**
     * 이메일 로그인
     * @param memberDTO
     * @param session
     */
    @PostMapping("/loginEmail")
    public String login(MemberDTO memberDTO, HttpSession session) {
        MemberDTO loginResult = memberService.loginByEmail(memberDTO);
        if (loginResult != null) {
            // 존재하는 경우 -> 로그인 성공
            // -> 닉네임, id를 세션에 set하고 메인페이지로 이동
            session.setAttribute("nickname", loginResult.getNickname());
            session.setAttribute("id", loginResult.getId());
            if(loginResult.getKakao() != null) session.setAttribute("kakao", "yes");
            if(loginResult.getNaver() != null) session.setAttribute("naver", "yes");
            if(loginResult.getGoogle() != null) session.setAttribute("google", "yes");
            return "redirect:/";
        } else {
            // 존재하지 않는 경우 -> 다시 로그인하라고 돌려보냄
            session.setAttribute("msg", "이메일/비밀번호가 일치하지 않습니다.");
            session.setAttribute("url", "/member/login");
            return "member/alert";
        }
    }

    /**
     * 카카오 로그인
     * @param code : 카카오 로그인 코드
     * @param session : 세션
     * @return  로그인 성공시 세션에 닉네임과 ID 등록, 메인페이지로 이동
     *          로그인 실패
     *          1. 가입되지 않은 회원
     *              메시지를 띄워주고 가입페이지로 이동
     */
    @GetMapping("/kakaoLogin")
    public String kakaoLoginGet(@RequestParam String code, HttpSession session) throws Exception {
        String kakaoId = memberService.getKakaoId(code);
        MemberDTO loginResult = memberService.findByKakao(kakaoId); // 카카오 ID 로 DB에서 사용자 조회
        if (loginResult != null) {  // 가입된 회원
            session.setAttribute("nickname", loginResult.getNickname());
            session.setAttribute("id", loginResult.getId());
            if(loginResult.getKakao() != null) session.setAttribute("kakao", "yes");
            if(loginResult.getNaver() != null) session.setAttribute("naver", "yes");
            if(loginResult.getGoogle() != null) session.setAttribute("google", "yes");
            return "redirect:/";
        } else {                    // 가입되지 않은 회원
            session.setAttribute("msg", "가입되지 않은 사용자입니다.");
            session.setAttribute("url", "/member/register");
            return "member/alert";
        }
    }

    /**
     * 네이버 로그인
     * @param code
     * @param state
     * @param session
     */
    @GetMapping("/naverLogin")
    public String naverLoginGet(@RequestParam String code, @RequestParam String state, HttpSession session) throws Exception {
        String naverId = memberService.getNaverId(code, state);
        MemberDTO loginResult = memberService.findByNaver(naverId);
        if (loginResult != null) {  // 가입된 회원
            session.setAttribute("nickname", loginResult.getNickname());
            session.setAttribute("id", loginResult.getId());
            if(loginResult.getKakao() != null) session.setAttribute("kakao", "yes");
            if(loginResult.getNaver() != null) session.setAttribute("naver", "yes");
            if(loginResult.getGoogle() != null) session.setAttribute("google", "yes");
            return "redirect:/";
        } else {                    // 가입되지 않은 회원
            session.setAttribute("msg", "가입되지 않은 사용자입니다.");
            session.setAttribute("url", "/member/register");
            return "member/alert";
        }
    }

    /**
     * 구글 로그인
     * @param code
     * @param state
     * @param request
     */
    @GetMapping("/googleLogin")
    public String googleLoginGet(@RequestParam String code, @RequestParam String state, HttpServletRequest request) throws Exception {
        String googleId = memberService.getGoogleId(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/member/registerGoogle", code, state);
        MemberDTO loginResult = memberService.findByGoogle(googleId);
        if (loginResult != null) {  // 가입된 회원
            request.getSession().setAttribute("nickname", loginResult.getNickname());
            request.getSession().setAttribute("id", loginResult.getId());
            if(loginResult.getKakao() != null) request.getSession().setAttribute("kakao", "yes");
            if(loginResult.getNaver() != null) request.getSession().setAttribute("naver", "yes");
            if(loginResult.getGoogle() != null) request.getSession().setAttribute("google", "yes");
            return "redirect:/";
        } else {                    // 가입되지 않은 회원
            request.getSession().setAttribute("msg", "가입되지 않은 사용자입니다.");
            request.getSession().setAttribute("url", "/member/register");
            return "member/alert";
        }
    }

    // 로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    /**
     * 카카오 연동하기
     * @param code : 카카오 로그인 코드
     * @param state : 기존 로그인된 회원의 id
     * @param session : 세션
     * @return  연동 성공시 DB에 업데이트, 마이페이지로 이동
     *          연동 실패
     *          1. 이미 가입된 카카오 계정
     *              미구현(카카오 로그아웃 시키고, ) 메시지를 띄워주고, 마이페이지로 이동
     */
    @GetMapping("/connectKakao")
    public String connectKakao(@RequestParam String code, @RequestParam String state, HttpSession session) throws Exception {
        String kakaoId = memberService.getKakaoId(code);
        MemberDTO result = memberService.findByKakao(kakaoId);
        if(result != null) {
            session.setAttribute("msg", "이미 가입된 사용자입니다.");
            session.setAttribute("url", "/member/profile");
            return "member/alert";
        } else {
            memberService.connectKakao(state, kakaoId);
            session.setAttribute("kakao", "yes");
            return "member/profile";
        }
    }

    /**
     * 네이버 연동하기
     * @param code
     * @param state
     * @param session
     */
    @GetMapping("/connectNaver")
    public String connectNaver(@RequestParam String code, @RequestParam String state, HttpSession session) throws Exception {
        String naverId = memberService.getNaverId(code, state);
        MemberDTO result = memberService.findByNaver(naverId);
        if(result != null) {
            session.setAttribute("msg", "이미 가입된 사용자입니다.");
            session.setAttribute("url", "/member/profile");
            return "member/alert";
        } else {
            memberService.connectNaver(state, naverId);
            session.setAttribute("naver", "yes");
            return "member/profile";
        }
    }

    /**
     * 구글 연동하기
     * @param code
     * @param state
     * @param request
     */
    @GetMapping("/connectGoogle")
    public String connectGoogle(@RequestParam String code, @RequestParam String state, HttpServletRequest request) throws Exception {
        String googleId = memberService.getGoogleId(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/member/registerGoogle", code, state);
        MemberDTO result = memberService.findByGoogle(googleId);
        if(result!= null) {
            request.getSession().setAttribute("msg", "이미 가입된 사용자입니다.");
            request.getSession().setAttribute("url", "/member/profile");
            return "member/alert";
        } else {
            memberService.connectGoogle(state, googleId);
            request.getSession().setAttribute("google", "yes");
            return "member/profile";
        }
    }

    // 마이페이지 뷰
    @GetMapping("/profile")
    public String mypage(HttpSession session) { return "member/profile"; }

    // 비밀번호 변경 팝업
    @GetMapping("/editPasswordPopup")
    public String modifyPassword() { return "member/editPasswordPopup"; }

    // 비밀번호 찾기 팝업
    @GetMapping("/findPasswordPopup")
    public String findPassword() { return "member/findPasswordPopup"; }
}
