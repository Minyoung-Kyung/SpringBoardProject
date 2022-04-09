package net.developia.spring03.service;

import java.util.List;

import net.developia.spring03.dto.ReplyDTO;

public interface ReplyService {
	int replyInsert(ReplyDTO replyDTO) throws Exception;
	
	ReplyDTO replyRead(Long rno) throws Exception;
	
	int replyDelete(Long rno) throws Exception;
	
	int replyUpdate(ReplyDTO replyDTO) throws Exception;
	
	List<ReplyDTO> getReplyList(Long bno) throws Exception;
	
	long getReplyCount(Long bno) throws Exception;
}

