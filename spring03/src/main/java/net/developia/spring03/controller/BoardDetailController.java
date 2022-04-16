package net.developia.spring03.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.log4j.Log4j;
import net.developia.spring03.dto.BoardAttachDTO;
import net.developia.spring03.dto.BoardDTO;
import net.developia.spring03.service.BoardService;

@Log4j
@Controller
@RequestMapping("board/{pg}/{bno}")
public class BoardDetailController {
	
	private BoardService boardService;
	
	@Value("${uploadDir}")
	private String uploadFolder;
	
	public BoardDetailController(BoardService boardService) {
		this.boardService = boardService;
	}

	@GetMapping(value="/")
	public String detail(@PathVariable("pg") long pg, 
						@PathVariable("bno") long bno, 
						@RequestParam long vn, // virtual number (list.jsp에서 받아온 가상 번호)
						Model model) {
		try {
			BoardDTO boardDTO = boardService.getDetail(bno);

			model.addAttribute("boardDTO", boardDTO);
			model.addAttribute("vn", vn); // detail.jsp로 전달
			return "board.detail";
		} catch (RuntimeException e) { // 예외 사항에 대한 catch 처리
			model.addAttribute("msg", e.getMessage());
			model.addAttribute("url", "../"); // 게시물 목록으로 이동 
			return "result";
		} catch (Exception e) { 
			model.addAttribute("msg", "상세보기 에러");
			model.addAttribute("url", "../"); // 게시물 목록으로 이동
			return "result";
		} 
	}
	
	@GetMapping(value="getAttachList", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachDTO>> getAttachList(Long bno) throws Exception {
		log.info("getAttachList : " + bno);
		return new ResponseEntity<>(boardService.getAttachList(bno), HttpStatus.OK);
	}
	
	@GetMapping("/{vn}/delete")
	public String delete(@PathVariable("bno") long bno, @PathVariable("vn") long vn, Model model) {
		model.addAttribute("vn", vn);
		return "board.delete";
	}
	
	@PostMapping("/{vn}/delete")
	public String delete(@ModelAttribute BoardDTO boardDTO, @PathVariable("vn") long vn, Model model) {
		log.info(boardDTO.toString());
		try {
			List<BoardAttachDTO> attachList = boardService.getAttachList(boardDTO.getBno());
			
			if (boardService.deleteBoard(boardDTO) == 1) {
				deleteFiles(attachList); // uploadFolder 내에 존재하는 섬네일과 원본 파일도 삭제
				model.addAttribute("msg", vn + "번 게시물이 삭제되었습니다.");
				model.addAttribute("url", "../../../1/"); // 게시물 목록으로 이동
			} else {
				model.addAttribute("msg","비밀번호가 틀리거나 오류가 발생했습니다.");
				model.addAttribute("url", "../?vn=" + vn); // 게시물 삭제로 이동
			}
			return "result";
		}catch (Exception e) {
			model.addAttribute("msg", e.getMessage());
			model.addAttribute("url", "javascript:history.back();");
			return "result";
		}
	}
	
	@GetMapping("/{vn}/update")
	public String update(@PathVariable("pg") long pg, @PathVariable("bno") long bno, @PathVariable("vn") long vn, Model model) {
		try {
			BoardDTO boardDTO = boardService.getDetail(bno);
			model.addAttribute("boardDTO", boardDTO);
			return "board.update";
		} catch (Exception e) {
			model.addAttribute("msg", "해당하는 게시물이 없거나 시스템 에러입니다.");
			model.addAttribute("url", "../../../1/"); // 게시물 목록으로 이동
			return "result";
		}
	}
	
	@PostMapping("/{vn}/update")
	public String updateBoard(@PathVariable("bno") long bno, @PathVariable("vn") long vn, @ModelAttribute BoardDTO boardDTO,
		Model model) {
		log.info(boardDTO.toString());
		try {
			log.info(boardDTO.getAttachList());
			
			if(boardDTO.getAttachList() != null) {
				boardDTO.getAttachList().forEach(attach -> log.info(attach));
			}
			
			if (boardService.updateBoard(boardDTO) == 1) {
				model.addAttribute("msg", vn + "번 게시물이 수정되었습니다.");
			} else {
				model.addAttribute("msg","비밀번호가 틀리거나 오류가 발생했습니다.");
			}

			model.addAttribute("url", "../?vn=" + vn); // 게시물 상세보기로 이동
			return "result";
		} catch (Exception e) {
			model.addAttribute("msg", e.getMessage());
			model.addAttribute("url", "javascript:history.back();");
			return "result";
		}
	}
	
	private void deleteFiles(List<BoardAttachDTO> attachList) {
		if (attachList == null || attachList.size() == 0) {
			return;
		}
		
		log.info("delete attach files .....");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get(uploadFolder + attach.getUploadPath() + "/" + attach.getUuid() + "_" + attach.getFileName());
				
				Files.deleteIfExists(file);
				
				if (Files.probeContentType(file).startsWith("image")) {
					Path thumNail = Paths.get(uploadFolder + attach.getUploadPath() + "/s_" + attach.getUuid() + "_" + attach.getFileName());
					
					Files.delete(thumNail);
				}
			} catch (Exception e) {
				log.error("delete file error : " + e.getMessage());
				e.printStackTrace();
			}
		});
	}
	
}