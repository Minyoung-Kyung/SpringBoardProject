package net.developia.spring03.service;

import java.util.List;

import net.developia.spring03.dto.BoardAttachDTO;
import net.developia.spring03.dto.BoardDTO;

public interface BoardService {
	void insertBoard(BoardDTO boardDTO) throws Exception;
	
	List<BoardDTO> getBoardList(String type, String keyword) throws Exception;
	
	BoardDTO getDetail(long bno) throws Exception;

	int deleteBoard(BoardDTO boardDTO) throws Exception;

	int updateBoard(BoardDTO boardDTO) throws Exception;

	List<BoardDTO> getBoardListPage(long pg, String type, String keyword) throws Exception;

	long getBoardCount(String type, String keyword) throws Exception;
	
	List<BoardAttachDTO> getAttachList(Long bno) throws Exception;
}