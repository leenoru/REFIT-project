package com.refit.project.service.member;

import com.fasterxml.jackson.annotation.*;
import com.fasterxml.jackson.core.type.*;
import com.fasterxml.jackson.databind.*;
import com.refit.project.dto.member.MemberDTO;
import com.refit.project.dao.member.MemberDao;
import lombok.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.mail.javamail.*;
import org.springframework.security.crypto.password.*;
import org.springframework.stereotype.Service;
import org.springframework.util.*;
import org.springframework.web.client.*;

import javax.mail.*;
import javax.mail.internet.*;
import java.io.*;
import java.net.*;
import java.util.*;

@Service
@RequiredArgsConstructor
public class MemberService {

    @Value("#{property['kakao.client_id']}")
    private String kakaoClientId; // 카카오 API KEY

    @Value("#{property['naver.client_id']}")
    private String naverClientId; // 네이버 API KEY

    @Value("#{property['naver.client_secret']}")
    private String naverClientSecret; // 네이버 API Secret

    @Value("#{property['google.client_id']}")
    private String googleClientId; // 구글 API KEY

    @Value("#{property['google.client_secret']}")
    private String googleClientSecret; // 구글 API Secret

    @Value("#{property['email.account']}")
    private String setFrom; // SMTP sender

    private final JavaMailSender mailSender; // 메일 전송
    private final MemberDao memberDao;
    private final RestTemplate restTemplate; // REST 템플릿 객체
    private final PasswordEncoder passwordEncoder; // Spring Security 패스워드 암호화 객체

    private ObjectMapper objectMapper = new ObjectMapper(); // JSON 매핑 객체

    /**
     * 회원가입
     *
     * @return 1: 가입성공, 0: 가입실패
     */
    public int register(String email, String password, String nickname, String kakao, String naver, String google) {
        MemberDTO memberDTO = new MemberDTO();
        memberDTO.setEmail(email);
        if (password != null) memberDTO.setPassword(passwordEncoder.encode(password));
        memberDTO.setNickname(nickname == null ? generateString(10) : nickname);
        memberDTO.setKakao(kakao);
        memberDTO.setNaver(naver);
        memberDTO.setGoogle(google);
        return memberDao.register(memberDTO);
    }

    /**
     * 회원가입 인증 이메일 전송
     *
     * @param email: 수신자
     * @return 인증코드
     */
    public String registerEmail(String email) {
        String authKey = generateString(6);
        String title = "회원 가입 인증 이메일입니다."; // 메일 제목
        String content = "홈페이지를 방문해주셔서 감사합니다."
                + "<br><br>"
                + "인증 번호는 " + authKey + "입니다."
                + "<br>해당 인증번호를 인증번호 확인란에 기입해주세요."; // 메일 내용
        mailSend(setFrom, email, title, content);
        return authKey;
    }

    //====로그인=====================================================================================

    /**
     * 이메일로 로그인
     *
     * @param memberDTO
     */
    public MemberDTO loginByEmail(MemberDTO memberDTO) {
        MemberDTO member = memberDao.findByEmail(memberDTO.getEmail());
        if (member != null && passwordEncoder.matches(memberDTO.getPassword(), member.getPassword())) {
            return member;
        } else return null;
    }

    /**
     * 이메일로 사용자 찾기
     *
     * @param email
     */
    public MemberDTO findByEmail(String email) {
        return memberDao.findByEmail(email);
    }

    /**
     * 카카오 ID 가져오기
     *
     * @param code
     * @return kakaoId
     */
    public String getKakaoId(String code) {
        try {
            // code 로 AccessToken 받아오기
            URL url = new URL("https://kauth.kakao.com/oauth/token");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            // POST 요청을 위해 기본값이 false인 setDoOutput을 true로
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            // POST 요청에 필요로 요구하는 파라미터 스트림을 통해 전송
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter((conn.getOutputStream())));
            StringBuilder sb = new StringBuilder();
            sb.append("grant_type=authorization_code");
            sb.append("&client_id=" + kakaoClientId);
//            sb.append("&redirect_uri="+"http://localhost:8080/main");
            sb.append("&code=" + code);
            bw.write(sb.toString());
            bw.flush();

//            ObjectMapper objectMapper = new ObjectMapper(); // jackson objectmapper 객체 생성
            // JSON String -> Map
            Map<String, Object> jsonMap = objectMapper.readValue(readBody(conn.getInputStream()), new TypeReference<Map<String, Object>>() {
            });
            String accessToken = jsonMap.get("access_token").toString();
            bw.close();
            // AccessToken 으로 카카오서버에서 id 가져오기
            Map<String, String> requestHeaders = new HashMap<>();
            requestHeaders.put("Authorization", "Bearer " + accessToken);
//            objectMapper = new ObjectMapper(); // jackson objectmapper 객체 재생성
            // JSON String -> Map
            jsonMap = objectMapper.readValue(get("https://kapi.kakao.com/v2/user/me", requestHeaders), new TypeReference<Map<String, Object>>() {
            });
            return jsonMap.get("id").toString();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * 카카오 ID 로 사용자 찾기
     *
     * @param kakaoId
     * @return
     */
    public MemberDTO findByKakao(String kakaoId) {
        MemberDTO memberDTO = memberDao.findByKakao(kakaoId);
        System.out.println(memberDTO);
        return memberDTO;
    }

    /**
     * 네이버 ID 가져오기
     *
     * @param code
     * @param state
     * @return naverId
     */
    public String getNaverId(String code, String state) {
        try {
            URL url = new URL("https://nid.naver.com/oauth2.0/token?grant_type=authorization_code"
                    + "&client_id=" + naverClientId
                    + "&client_secret=" + naverClientSecret
                    + "&code=" + code
                    + "&state=" + state);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
            String inputLine = "";
            String result = "";
            while ((inputLine = br.readLine()) != null) {
                result += inputLine;
            }
            br.close();
            // JSON String -> Map
//            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, Object> jsonMap = objectMapper.readValue(result, new TypeReference<Map<String, Object>>() {
            });
            Map<String, String> requestHeaders = new HashMap<>();
            requestHeaders.put("Authorization", "Bearer " + jsonMap.get("access_token").toString());
            jsonMap = objectMapper.readValue(get("https://openapi.naver.com/v1/nid/me", requestHeaders), new TypeReference<Map<String, Object>>() {
            });
            String response = jsonMap.get("response").toString();
            return response.substring(4, response.length() - 1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * 네이버 ID 로 사용자 찾기
     *
     * @param naverId
     */
    public MemberDTO findByNaver(String naverId) {
        return memberDao.findByNaver(naverId);
    }

    /**
     * 구글 ID 가져오기
     *
     * @param redirectUri
     * @param code
     * @param state
     * @return googleId
     */
    public String getGoogleId(String redirectUri, String code, String state) {
        GoogleLoginRequest requestParams = GoogleLoginRequest.builder()
                .clientId(googleClientId)
                .clientSecret(googleClientSecret)
                .code(code)
                .redirectUri(redirectUri)
                .grantType("authorization_code")
                .build();
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<GoogleLoginRequest> httpRequestEntity = new HttpEntity<>(requestParams, headers);
            ResponseEntity<String> apiResponseJson = restTemplate.postForEntity("https://oauth2.googleapis.com" + "/token", httpRequestEntity, String.class);
            objectMapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            Map<String, Object> jsonMap = objectMapper.readValue(apiResponseJson.getBody(), new TypeReference<Map<String, Object>>() {
            });
//            String accessToken = jsonMap.get("access_token").toString();
            headers = new HttpHeaders();
//            headers.add("Authorization", "Bearer " + accessToken);
            headers.add("Authorization", "Bearer " + jsonMap.get("access_token").toString());
            HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(headers);
            apiResponseJson = restTemplate.exchange("https://www.googleapis.com/oauth2/v1/userinfo", HttpMethod.GET, request, String.class);
            jsonMap = objectMapper.readValue(apiResponseJson.getBody(), new TypeReference<Map<String, Object>>() {
            });
            return jsonMap.get("id").toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * 구글 ID 로 사용자 찾기
     *
     * @param googleId
     */
    public MemberDTO findByGoogle(String googleId) {
        return memberDao.findByGoogle(googleId);
    }

    /**
     * 비밀번호찾기 인증 이메일 전송
     *
     * @param email: 수신자
     * @return 인증코드
     */
    public String findEmail(String email) {
        String authKey = generateString(6); // 인증 코드
        String title = "비밀번호 찾기 인증 이메일입니다.";
        String content = "홈페이지를 방문해주셔서 감사합니다."
                + "<br><br>"
                + "인증 번호는 " + authKey + "입니다."
                + "<br>해당 인증번호를 인증번호 확인란에 기입해주세요.";
        mailSend(setFrom, email, title, content);
        return authKey;
    }

    /**
     * 임시 비밀번호
     *
     * @param email
     */
    public void tempPassword(String email) {
        String newPassword = generateString(8);
        memberDao.modifyPassword(passwordEncoder.encode(newPassword), memberDao.findByEmail(email).getId());
        editPasswordEmail(email, newPassword);
    }

    /**
     * 임시 비밀번호 메일 전송
     *
     * @param email
     * @param newPassword
     */
    private void editPasswordEmail(String email, String newPassword) {
        String title = "임시비밀번호 이메일입니다.";
        String content = "임시비밀번호는 " + newPassword + "입니다."
                + "<br>임시비밀번호를 이용해 로그인해주세요.";
        mailSend(setFrom, email, title, content);
    }

    //====연동======================================================================================

    /**
     * 카카오 연동
     *
     * @param id
     * @param kakaoId
     */
    public void connectKakao(String id, String kakaoId) {
        memberDao.connectKakao(id, kakaoId);
    }

    /**
     * 네이버 연동
     *
     * @param id
     * @param naverId
     */
    public void connectNaver(String id, String naverId) {
        memberDao.connectNaver(id, naverId);
    }

    /**
     * 구글 연동
     *
     * @param state
     * @param googleId
     */
    public void connectGoogle(String state, String googleId) {
        memberDao.connectGoogle(state, googleId);
    }


    //====마이페이지=================================================================================

    /**
     * 닉네임 변경
     *
     * @param nickname
     * @param id
     */
    public void modifyNickname(String nickname, String id) {
        memberDao.modifyNickname(nickname, id);
    }

    /**
     * 비밀번호 변경
     *
     * @param password
     * @param id
     */
    public void modifyPassword(String password, String id) {
        memberDao.modifyPassword(passwordEncoder.encode(password), Integer.parseInt(id));
    }

    /**
     * 회원탈퇴
     *
     * @param id
     */
    public void quit(Long id) {
        memberDao.delete(id);
        // 미구현: DB closet table 유저의 옷장 엔터티들 제거
        // 미구현: 로컬 스토리지에 이미지들도 같이 제거
    }

    //====API======================================================================================

    /**
     * 비밀번호 확인
     *
     * @param id
     * @param password
     */
    public boolean passwordCheck(String id, String password) {
        return passwordEncoder.matches(password, memberDao.getPassword(id));
    }

    @Data
    @Builder
    public static class GoogleLoginRequest {

        private String clientId;    // 애플리케이션의 클라이언트 ID
        private String redirectUri; // Google 로그인 후 redirect 위치
        private String clientSecret;    // 클라이언트 보안 비밀
        private String responseType;    // Google OAuth 2.0 엔드포인트가 인증 코드를 반환하는지 여부
        private String scope;   // OAuth 동의범위
        private String code;
        private String accessType;  // 사용자가 브라우저에 없을 때 애플리케이션이 액세스 토큰을 새로 고칠 수 있는지 여부
        private String grantType;
        private String state;
        private String includeGrantedScopes;    // 애플리케이션이 컨텍스트에서 추가 범위에 대한 액세스를 요청하기 위해 추가 권한 부여를 사용
        private String loginHint;   // 애플리케이션이 인증하려는 사용자를 알고 있는 경우 이 매개변수를 사용하여 Google 인증 서버에 힌트를 제공
        private String prompt;  // default: 처음으로 액세스를 요청할 때만 사용자에게 메시지가 표시

    }

    /**
     * HTTP GET
     *
     * @param apiUrl:         요청 URL
     * @param requestHeaders: 헤더
     * @return response body 를 String 으로
     */
    public static String get(String apiUrl, Map<String, String> requestHeaders) {
        HttpURLConnection con = connect(apiUrl);
        try {
            con.setRequestMethod("GET");
            for (Map.Entry<String, String> header : requestHeaders.entrySet()) {
                con.setRequestProperty(header.getKey(), header.getValue());
            }
            int responseCode = con.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
                return readBody(con.getInputStream());
            } else { // 에러 발생
                return readBody(con.getErrorStream());
            }
        } catch (IOException e) {
            throw new RuntimeException("API 요청과 응답 실패", e);
        } finally {
            con.disconnect();
        }
    }

    /**
     * HTTP 연결 생성
     *
     * @param apiUrl
     * @return
     */
    private static HttpURLConnection connect(String apiUrl) {
        try {
            URL url = new URL(apiUrl);
            return (HttpURLConnection) url.openConnection();
        } catch (MalformedURLException e) {
            throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
        } catch (IOException e) {
            throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
        }
    }

    /**
     * 입력스트림 읽기
     *
     * @param body: 입력스트림
     * @return String
     */
    private static String readBody(InputStream body) {
        BufferedReader lineReader = new BufferedReader(new InputStreamReader(body));
        try {
            StringBuilder responseBody = new StringBuilder();
            String line;
            while ((line = lineReader.readLine()) != null) {
                responseBody.append(line);
            }
            return responseBody.toString();
        } catch (IOException e) {
            throw new RuntimeException("API 응답을 읽는데 실패했습니다.", e);
        }
    }

    /**
     * 랜덤 문자열 생성
     *
     * @param length: 길이
     * @return 랜덤 문자열
     */
    public String generateString(int length) {
        Random random = new Random(); // 48 : 0, 123 : z
        return random.ints(48, 122 + 1)
                .filter(i -> (i <= 57 || i >= 65) && (i <= 90 || i >= 97))
                .limit(length)
                .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
                .toString();
    }

    /**
     * 메일 전송
     *
     * @param setFrom: 송신자
     * @param email:   수신자
     * @param title:   메일 제목
     * @param content: 메일 내용
     */
    private void mailSend(String setFrom, String email, String title, String content) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setFrom(setFrom);
            helper.setTo(email);
            helper.setSubject(title);
            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

}
