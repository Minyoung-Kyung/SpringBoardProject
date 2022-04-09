package net.developia.spring03.dto;

import java.io.Serializable;
import java.util.Date;
import lombok.Data;

@Data
public class BoardDTO implements Serializable {
	private int bno;
	private String title;
	private String name;
	private String content;
	private Date regdate;
	private int readcount;
	private String password;
}