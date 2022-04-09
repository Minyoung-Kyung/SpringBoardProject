package net.developia.spring03.dto;

import java.io.Serializable;

import lombok.Data;

@Data
public class ReplyDTO implements Serializable  {
    private Long rno;
    private Long bno;
    
    private String reply;
    private String replyer;
    private String replyDate;
    private String updateDate;
}
