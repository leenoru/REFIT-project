package com.refit.project.dao.collection;

import com.refit.project.dto.collection.*;
import lombok.*;
import org.mybatis.spring.*;
import org.springframework.stereotype.*;

import java.util.*;

@Repository
@RequiredArgsConstructor
public class BinDaoImpl implements BinDao {
    private final SqlSessionTemplate sm; // MyBatis 객체

    @Override
    public List<BinDto> getList() {
        return sm.selectList("Bin_getList");
    }

    @Override
    public List<BinDto> getBinAddresses() {
        // 마이바티스 네임스페이스.메소드명 식으로 사용하는거다
        // 이름 통일 해줄 것!
        return sm.selectList("BinMapper.Bin_getList");
    }

}
