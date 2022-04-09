package net.developia.spring03.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.log4j.Log4j;
import net.developia.spring03.dto.BoardDTO;
import net.developia.spring03.service.BoardService;

@Log4j
@Controller
@RequestMapping("board/{pg}/{bno}")
public class BoardDetailController {
	
	private BoardService boardService;
	
	public BoardDetailController(BoardService boardService) {
		this.boardService = boardService;
	}

	@GetMapping(value="/")
	public String detail(@PathVariable("pg") long pg, 
						@PathVariable("bno") long bno, 
						@RequestParam long vn, // virtual number
						Model model) {
		try {
			BoardDTO boardDTO = boardService.getDetail(bno);

			model.addAttribute("boardDTO", boardDTO);
			model.addAttribute("vn", vn);
			return "board.detail";
		} catch (RuntimeException e) { // 예외 사항에 대한 catch 처리
			model.addAttribute("msg", e.getMessage());
			model.addAttribute("url", "../"); // 게시글 목록 화면으로 이동 
			return "result";
		} catch (Exception e) { 
			model.addAttribute("msg", "상세보기 에러");
			model.addAttribute("url", "../");
			return "result";
		} 
	}
	
	@GetMapping("delete")
	public String delete(@PathVariable long bno, Model model) {
		return "board.delete";
	}
	
	@PostMapping("delete")
	public ModelAndView delete(@ModelAttribute BoardDTO boardDTO) {
		log.info(boardDTO.toString());
		ModelAndView mav = new ModelAndView("result");
		try {
			boardService.deleteBoard(boardDTO);
			mav.addObject("msg", boardDTO.getBno() + "번 게시물이 삭제되었습니다.");
			mav.addObject("url", "../../1/");
		} catch (Exception e) {
			mav.addObject("msg", e.getMessage());
			mav.addObject("url", "javascript:history.back();");
		}
		return mav;
	}
	
	@GetMapping("update")
	public String update(@PathVariable long bno, Model model) {
		try {
			BoardDTO boardDTO = boardService.getDetail(bno);
			model.addAttribute("boardDTO", boardDTO);
			return "board.update";
		} catch (Exception e) {
			model.addAttribute("msg", "해당하는 게시물이 없거나 시스템 에러입니다.");
			model.addAttribute("url", "../../1/");
			return "result";
		}
	}
	
	@PostMapping("update")
	public String updateBoard(@ModelAttribute BoardDTO boardDTO,
		Model model) {
		
		log.info(boardDTO.toString());
		try {
			boardService.updateBoard(boardDTO);
			model.addAttribute("msg", boardDTO.getBno() + "번 게시물이 수정되었습니다.");
			model.addAttribute("url", "./"); // 수정 성공 후 수정된 내용 보여주기 (root로 이동)
			return "result";
		} catch (Exception e) {
			model.addAttribute("msg", e.getMessage());
			model.addAttribute("url", "javascript:history.back();");
			return "result";
		}
	}
	
}