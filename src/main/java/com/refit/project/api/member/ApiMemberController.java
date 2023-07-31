package com.refit.project.api.member;

import com.refit.project.dto.member.*;
import com.refit.project.service.member.*;
import lombok.*;
import org.springframework.stereotype.*;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.*;
import java.util.*;

@RestController
@RequestMapping("/api/member")
@RequiredArgsConstructor
public class ApiMemberController {

    private final MemberService memberService;

    @GetMapping("/sendFindEmail")
    public String sendFindEmail (@RequestParam("email") String email) {
        MemberDTO res = memberService.findByEmail(email);
        if (res == null) {
            return "0";
        } else {
            return memberService.findEmail(email);
        }
    }

    @PostMapping("/sendTempPassword")
    public void sendTempPassword (@RequestParam("email") String email) {
        memberService.tempPassword(email);
    }

    @GetMapping("/sendRegisterEmail")
    public String sendRegisterEmail (@RequestParam("email") String email) {
        return memberService.registerEmail(email);
    }

    @PostMapping("/modify-nickname")
    public void modifyNickname (@RequestParam("newName") String nickname, @RequestParam("id") String id, HttpSession session) {
        session.setAttribute("nickname", nickname);
        memberService.modifyNickname(nickname, id);
    }

    @PostMapping("/modify-password")
    public void modifyPassword (@RequestParam("password") String password, @RequestParam("id") String id) {
        memberService.modifyPassword(password, id);
    }

    @PostMapping("/passwordCheck")
    public String passwordCheck (@RequestParam("id") String id, @RequestParam("password") String password) {
        return memberService.passwordCheck(id, password) ? "1" : "0";
    }

    //이메일 인증
    @GetMapping("/emailCheck")
    @ResponseBody
    public String emailCheck(String email) {
        return memberService.findEmail(email) == null ? "0" : "1";
    }

    @PostMapping("/quit")
    public void quit (@RequestParam("id") String id, HttpSession session) {
        memberService.quit(Long.parseLong(id));
        session.invalidate();
    }

}
