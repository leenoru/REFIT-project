package com.refit.project.controller.banner;

import com.refit.project.dto.banner.*;
import com.refit.project.service.banner.*;
import lombok.*;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/banner")
@RequiredArgsConstructor
public class BannerController {
    private final BannerService bannerService;
    @GetMapping("/info")
    public List<BannerDto> getList() {
        return bannerService.getList();
    }
}
