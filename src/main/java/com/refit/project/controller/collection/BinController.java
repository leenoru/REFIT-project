package com.refit.project.controller.collection;

import com.refit.project.dto.collection.*;
import com.refit.project.service.collection.*;
import lombok.*;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/bins")
@RequiredArgsConstructor
public class BinController {

    private final BinService binService;

    // GET은 받아오기, POST는 보내기
    // 의류수거함의 주소들을 받아올건데 POST라고 되어있었다.
    @GetMapping("/address")
    public List<BinDto> getBinAddresses() {
        return binService.getBinAddresses();
    }
}

