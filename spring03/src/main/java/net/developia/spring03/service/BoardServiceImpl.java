package net.developia.spring03.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
	public List<BoardDTO> getBoardList(String type, String keyword) throws Exception {
		return boardDAO.getBoardList(type, keyword);
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

	@Transactional
	@Override
	public int deleteBoard(BoardDTO boardDTO) throws Exception {
		int deleteResult = boardDAO.deleteBoard(boardDTO); // 입력한 비밀번호가 일치하면 성공
		
		if (deleteResult == 1) {
			attachDAO.deleteAll(boardDTO.getBno()); // 테이블에 존재하는 해당 게시물의 파일 모두 삭제
		}
		
		return deleteResult;
	}

	@Transactional
	@Override
	public int updateBoard(BoardDTO boardDTO) throws Exception {		
		int modifyResult = boardDAO.updateBoard(boardDTO); // 입력한 비밀번호가 일치하면 성공
		
		if (modifyResult == 1 && boardDTO.getAttachList() != null && boardDTO.getAttachList().size() > 0) {
			attachDAO.deleteAll(boardDTO.getBno()); // 테이블에 존재하는 해당 게시물의 파일 모두 삭제
			
			boardDTO.getAttachList().forEach(attach -> {
				attach.setBno(boardDTO.getBno());
				attachDAO.attachInsert(attach); // 새로 수정한 파일 업로드
			});
		}
		
		return modifyResult;
	}

	@Override
	public List<BoardDTO> getBoardListPage(long pg, String type, String keyword) throws Exception {
		long startNum = (pg - 1) * pageSize + 1;
		long endNum = pg * pageSize;
		
		return boardDAO.getBoardListPage(startNum, endNum, type, keyword);
	}

	@Override
	public long getBoardCount(String type, String keyword) throws Exception {
		return boardDAO.getBoardCount(type, keyword);
	}

	@Override
	public List<BoardAttachDTO> getAttachList(Long bno) throws Exception {
		return attachDAO.attachListByBno(bno);
	}

}