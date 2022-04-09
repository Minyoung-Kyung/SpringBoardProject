package net.developia.spring03.controller;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("rest")
public class MethodTestController {
	
	@GetMapping(produces="plain/text;charset=utf8")
	// value 가 없는 경우 /에 매핑. 즉 rest/ 에 매핑된다.
	public String getAction() {
		log.info("Get Action 수행 중...");
		return "Get Action 수행 중...";
	}
	
	@PostMapping(produces="plain/text;charset=utf8")
	// 한글 깨짐을 방지하기 위한 produces 처리
	public String postAction() {
		log.info("POST Action 수행 중...");
		return "POST Action 수행 중...";
	}
	
	@PutMapping(value="/", produces=MediaType.TEXT_PLAIN_VALUE)
	public String putAction() {
		log.info("PUT Action 수행 중...");
		return "PUT Action 수행 중...";
	}
	
	@DeleteMapping(value="/", produces=MediaType.TEXT_PLAIN_VALUE)
	public String deleteAction() {
		log.info("DELETE Action 수행 중...");
		return "DELETE Action 수행 중...";
	}
	
}