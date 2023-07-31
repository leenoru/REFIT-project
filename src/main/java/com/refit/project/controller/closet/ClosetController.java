package com.refit.project.controller.closet;

import com.refit.project.dto.closet.ClosetDto;
import com.refit.project.service.closet.ClosetService;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONArray;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedList;
import java.util.List;

@RestController
@RequestMapping("/api/closet")
@RequiredArgsConstructor
public class ClosetController {
    private final ClosetService closetService;

    @GetMapping("/{id}")
    public ResponseEntity<List<ClosetDto>> getListById(@PathVariable("id") Integer id) {
        List<ClosetDto> closets = closetService.getListByID(String.valueOf(id));
        return new ResponseEntity<>(closets, HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<Void> save(@RequestBody ClosetDto closetDto) {
        closetService.save(closetDto);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @PutMapping("/{closet_id}")
    public ResponseEntity<Void> update(@PathVariable("closet_id") Integer closet_id, @RequestBody ClosetDto closetDto) {
        closetDto.setId(closet_id);
        closetService.update(closetDto);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("/{closet_id}")
    public ResponseEntity<Void> delete(@PathVariable("closet_id") Long closet_id) {
        closetService.delete(closet_id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    /**
     * 클라이언트에서 multipart/form-data 형식으로 이미지 파일을 받아
     * 파일명 생성하여 서버 스토리지에 저장(이미지 URL 생성)
     * URL 들을 JSONArray 형태로 Flask 에 POST request
     * JSONArray 형태의 분류 결과 response 받아서 클라이언트에게 전달
     * @param upload: 이미지 파일들
     * @return ResponseEntity<JSONArray>: 분류 결과를 JSONArray 타입
     */
    @PostMapping("/save")
    public ResponseEntity<JSONArray> saveCloset(@RequestParam MultipartFile[] upload, HttpServletRequest request) throws Exception {
        List<String> urls = new LinkedList<>();
        // 서버 스토리지에 이미지 저장
        for(MultipartFile image : upload) {
            // "연월일_시분초_밀리초_파일명.확장자"로 파일이름생성
            // 파일경로는 webapp/resources/image/closet
            String filePath = request.getSession().getServletContext().getRealPath("/") // webapp 디렉토리 절대경로
                    + "resources" + File.separator + "image" + File.separator + "closet" + File.separator // 디렉토리까지 이동
                    + LocalDate.now().toString().replace("-", "") // 연월일
                    + "_" + LocalTime.now().format(DateTimeFormatter.ofPattern("HHmmss_SSS_")) // 시분초_밀리초
                    + StringUtils.cleanPath(image.getOriginalFilename());
            String fileName = LocalDate.now().toString().replace("-", "") // 연월일
                    + "_" + LocalTime.now().format(DateTimeFormatter.ofPattern("HHmmss_SSS_")) // 시분초_밀리초
                    + StringUtils.cleanPath(image.getOriginalFilename());
            // 이미지 경로 저장
            System.out.println(filePath);
            ClosetDto closetDto = new ClosetDto();
            closetDto.setCloth_path(fileName); // 단일 이미지일 경우, 첫 번째 이미지 경로 저장
            // 세션 id(=member.id)를 closet의 id에 저장
            HttpSession session = request.getSession();
            Integer id = (Integer) session.getAttribute("id");
            closetDto.setId(id);

            // DB에 저장
            closetService.save(closetDto);
            try {
                Files.copy(image.getInputStream(),
                        Paths.get(filePath)
                        , StandardCopyOption.REPLACE_EXISTING);
                urls.add(filePath);
                // 미구현: DB closet 테이블에 URL 추가하는 로직
            } catch (IOException e) {
                e.printStackTrace();
            }
            urls.add(filePath);
        }
        String redirectUrl = request.getContextPath() + "/member/profile";
        return ResponseEntity.status(HttpStatus.FOUND)
                .header("Location", redirectUrl)
                .body(null);
    }


}