package com.refit.project.service.closet;

import com.refit.project.dao.closet.ClosetDao;
import com.refit.project.dto.closet.ClosetDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ClosetService {
    private final ClosetDao closetDao;
    public List<ClosetDto> getListByID(String id) {
        return closetDao.getListByID(id);
    }
    public void save(ClosetDto dto) {
        closetDao.save(dto);
    }
    public void update(ClosetDto dto) {
        closetDao.update(dto);
    }
    public void delete(Long closet_id) {
        closetDao.delete(closet_id);
    }
}
