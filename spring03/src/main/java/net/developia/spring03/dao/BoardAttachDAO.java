package net.developia.spring03.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import net.developia.spring03.dto.BoardAttachDTO;

public interface BoardAttachDAO {
	public void attachInsert(BoardAttachDTO attachDTO);
	
	public void attachDelete(String uuid);

	public List<BoardAttachDTO> attachListByBno(@Param("bno") Long bno);
	
	public void deleteAll(Long bno);
}