package net.developia.spring03.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardDTO implements Serializable {
	private Long bno;
	private String title;
	private String name;
	private String content;
	private Date regdate;
	private Long readcount;
	private String password;
	
	private List<BoardAttachDTO> attachList;
	
	private String type;
	private String keyword;
	
	public String[] getTypeArr() {
	   return type == null? new String[] {}: type.split("");
	}
}