package net.developia.spring03.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import net.developia.spring03.dto.ReplyDTO;

public interface ReplyDAO {
	int replyInsert(ReplyDTO replyDTO) throws Exception;
	
	ReplyDTO replyRead(Long rno) throws Exception;
	
	int replyDelete(Long rno) throws Exception;
	
	int replyUpdate(ReplyDTO replyDTO) throws Exception;
	
	List<ReplyDTO> getReplyList(@Param("bno") Long bno) throws Exception;

	long getReplyCount(@Param("bno") Long bno) throws Exception;
}