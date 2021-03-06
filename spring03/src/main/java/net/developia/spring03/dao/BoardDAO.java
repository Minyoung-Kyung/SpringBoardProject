package net.developia.spring03.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import net.developia.spring03.dto.BoardDTO;

public interface BoardDAO {
	void insertBoard(BoardDTO boardDTO) throws Exception;
	
	BoardDTO getDetail(long bno) throws Exception;
	
	void updateReadCount(long bno) throws Exception;

	int deleteBoard(BoardDTO boardDTO) throws Exception;

	int updateBoard(BoardDTO boardDTO) throws Exception;
	
	List<BoardDTO> getBoardListPage(@Param("startNum")long startNum,@Param("endNum") long endNum,@Param("type") String type,@Param("keyword") String keyword) throws Exception;

	long getBoardCount(@Param("type") String type,@Param("keyword") String keyword) throws Exception;
}