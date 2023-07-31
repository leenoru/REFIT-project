package com.refit.project.dao.banner;

import com.refit.project.dto.banner.*;
import lombok.*;
import org.mybatis.spring.*;
import org.springframework.stereotype.*;

import java.util.*;

@Repository
@RequiredArgsConstructor
public class BannerDaoImpl implements BannerDao{
    private final SqlSessionTemplate sm; // MyBatis 객체
    @Override
    public List<BannerDto> getList() {
        return sm.selectList("BannerMapper.Banner_getList");
    }
}
