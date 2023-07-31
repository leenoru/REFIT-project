package com.refit.project.dao.company;

import com.refit.project.dto.company.*;
import lombok.*;
import org.mybatis.spring.*;
import org.springframework.stereotype.*;

import java.util.*;

@Repository
@RequiredArgsConstructor
public class CompanyDaoImpl implements CompanyDao {
    private final SqlSessionTemplate sm;

    @Override
    public List<CompanyDto> searchCompaniesByLocation(String serviceLocation) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("serviceLocation", serviceLocation);
        return sm.selectList("CompanyMapper.getCompaniesByServiceLocation", paramMap);
    }
}

