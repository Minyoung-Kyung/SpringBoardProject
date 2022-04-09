package net.developia.spring03.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import lombok.Setter;
import net.developia.spring03.dao.BoardAttachDAO;
import net.developia.spring03.dao.BoardDAO;
import net.developia.spring03.dto.BoardAttachDTO;
import net.developia.spring03.dto.BoardDTO;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Setter(onMethod_ = @Autowired)
	private BoardDAO boardDAO;
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachDAO attachDAO;
	
	@Value("${pageSize}")
	private int pageSize;
	
	@Value("${blockSize}")
	private long blockSize;
	
	public BoardServiceImpl(BoardDAO boardDAO) {
		this.boardDAO = boardDAO;
	}

	@Override
	public void insertBoard(BoardDTO boardDTO) throws Exception {
		boardDAO.insertBoard(boardDTO);	
		
		if (boardDTO.getAttachList() == null || boardDTO.getAttachList().size() <= 0) {
			return;
		}
		
		boardDTO.getAttachList().forEach(attach -> {
			attach.setBno(boardDTO.getBno());
			attachDAO.attachInsert(attach);
		});
	}

	@Override
	public List<BoardDTO> getBoardList() throws Exception {
		return boardDAO.getBoardList();
	}
	
	@Override
	public BoardDTO getDetail(long bno) throws Exception {
		if (bno == -1) {
			throw new RuntimeException("잘못된 접근입니다.");
		}
		
		boardDAO.updateReadCount(bno); // 조회 수 업데이트
		BoardDTO boardDTO = boardDAO.getDetail(bno);
		
		if (boardDTO == null) {
			throw new RuntimeException(bno + "번 글이 존재하지 않습니다.");
		}
		
		return boardDTO;
	}

	@Override
	public void deleteBoard(BoardDTO boardDTO) throws Exception {
		if(boardDAO.deleteBoard(boardDTO) == 0) { // 삭제가 잘 되는 경우 1 
			throw new RuntimeException("해당하는 게시물이 없거나 비밀번호가 틀렸습니다.");
		}
	}

	@Override
	public void updateBoard(BoardDTO boardDTO) throws Exception {
		if(boardDAO.updateBoard(boardDTO) == 0) {
			throw new RuntimeException("해당하는 게시물이 없거나 비밀번호가 틀립니다.");
		}
	}

	@Override
	public List<BoardDTO> getBoardListPage(long pg) throws Exception {
		long startNum = (pg - 1) * pageSize + 1;
		long endNum = pg * pageSize;
		
		return boardDAO.getBoardListPage(startNum, endNum);
	}

	@Override
	public long getBoardCount() throws Exception {
		return boardDAO.getBoardCount();
	}

	@Override
	public List<BoardAttachDTO> getAttachList(Long bno) throws Exception {
		return attachDAO.getAttachList(bno);
	}

}