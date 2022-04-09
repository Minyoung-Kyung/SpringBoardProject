package net.developia.spring03.dto;

import lombok.Data;

@Data
public class ReplyDTO {
    private Long rno;
    private Long bno;
    
    private String reply;
    private String replyer;
    private String replyDate;
    private String updateDate;
}
