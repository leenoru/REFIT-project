package com.refit.project.service.collection;

import com.refit.project.dao.collection.*;
import com.refit.project.dto.collection.*;
import lombok.*;
import org.springframework.stereotype.*;

import java.util.*;

@Service
@RequiredArgsConstructor // BinService라는 빈이 생성될때 final로 선언된 필드(BinDao)를 스프링이 알아서 주입해 줌
public class BinService {
    // 의존주입(Dependency Injection)
    // 1. 생성자 주입
    // 2. 필드주입 (권장)
    // 3. setter 주입 (기존)
    private final BinDao binDao;

    public List<BinDto> getBinAddresses() {
        return binDao.getBinAddresses();
    }
}

