package com.refit.project.dao.closet;

import com.refit.project.dto.closet.ClosetDto;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository("closetDao")
@RequiredArgsConstructor
public class ClosetDao {
    private final SqlSessionTemplate sm; //mybatis 객체
    public List<ClosetDto> getListByID(String id) {
        return sm.selectList("ClosetMapper.getListByID", id);
    }
    public void save(ClosetDto dto) {
        sm.insert("ClosetMapper.Closet_save", dto);
    }
    public void update(ClosetDto dto) {
        sm.update("ClosetMapper.Closet_update", dto);
    }
    public void delete(Long closet_id) {
        sm.delete("ClosetMapper.Closet_delete", closet_id);
    }
}
