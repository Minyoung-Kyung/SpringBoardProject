package net.developia.spring03.dto;

import java.io.Serializable;

import lombok.Data;

@Data
public class BoardAttachDTO implements Serializable {
	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean fileType;
	private Long bno;
}