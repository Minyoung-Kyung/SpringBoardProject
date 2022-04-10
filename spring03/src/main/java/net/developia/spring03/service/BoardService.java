package net.developia.spring03.service;

import java.util.List;

import net.developia.spring03.dto.BoardAttachDTO;
import net.developia.spring03.dto.BoardDTO;

public interface BoardService {
	void insertBoard(BoardDTO boardDTO) throws Exception;
	
	List<BoardDTO> getBoardList() throws Exception;
	
	BoardDTO getDetail(long bno) throws Exception;

	int deleteBoard(BoardDTO boardDTO) throws Exception;

	int updateBoard(BoardDTO boardDTO) throws Exception;

	List<BoardDTO> getBoardListPage(long pg) throws Exception;

	long getBoardCount() throws Exception;
	
	List<BoardAttachDTO> getAttachList(Long bno) throws Exception;
}