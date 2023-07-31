package com.refit.project.service.banner;

import com.refit.project.dao.banner.*;
import com.refit.project.dto.banner.*;
import lombok.*;
import org.springframework.stereotype.*;

import java.util.*;

@Service
@RequiredArgsConstructor
public class BannerService {
    private final BannerDao bannerDao;

    public List<BannerDto> getList() {
        try{
            System.out.println("bannerDao.getList()="+bannerDao.getList());
        }catch(Exception e){
            e.printStackTrace();
        }
        return bannerDao.getList();
    }
}
