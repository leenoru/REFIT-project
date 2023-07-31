package com.refit.project.dao.collection;

import com.refit.project.dto.collection.*;

import java.util.*;

public interface BinDao {
    List<BinDto> getList();
    List<BinDto> getBinAddresses();
}
