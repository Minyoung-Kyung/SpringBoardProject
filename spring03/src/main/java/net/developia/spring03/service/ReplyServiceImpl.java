package net.developia.spring03.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import net.developia.spring03.dao.ReplyDAO;
import net.developia.spring03.dto.ReplyDTO;

@Service
@Log4j
public class ReplyServiceImpl implements ReplyService{ // 자동 주입
	
	@Setter(onMethod_ = @Autowired)
	private ReplyDAO replyDAO;

	@Override
	public int replyInsert(ReplyDTO replyDTO) throws Exception {
		return replyDAO.replyInsert(replyDTO);
	}

	@Override
	public ReplyDTO replyRead(Long rno) throws Exception {
		return replyDAO.replyRead(rno);
	}

	@Override
	public int replyDelete(Long rno) throws Exception {
		return replyDAO.replyDelete(rno);
	}

	@Override
	public int replyUpdate(ReplyDTO replyDTO) throws Exception {
		return replyDAO.replyUpdate(replyDTO);
	}

	@Override
	public List<ReplyDTO> getReplyList(Long bno) throws Exception {
		return replyDAO.getReplyList(bno);
	}

	@Override
	public long getReplyCount(Long bno) throws Exception {
		return replyDAO.getReplyCount(bno);
	}

}
