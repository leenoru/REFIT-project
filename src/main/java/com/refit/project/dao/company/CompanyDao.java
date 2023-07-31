package com.refit.project.dao.company;

import com.refit.project.dto.company.*;

import java.util.*;

public interface CompanyDao {
    List<CompanyDto> searchCompaniesByLocation(String serviceLocation);
}
