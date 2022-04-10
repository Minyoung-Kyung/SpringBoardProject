package net.developia.spring03.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import net.developia.spring03.dto.ReplyDTO;
import net.developia.spring03.service.ReplyService;

@RequestMapping("/replies/")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {

	@Autowired
    private ReplyService replyService;
    
    @PostMapping(value= "/new",
    		consumes = "application/json",
    		produces = {MediaType.TEXT_PLAIN_VALUE})
    public ResponseEntity<String> replyInsert(@RequestBody ReplyDTO replyDTO) throws Exception {
    	int insertCount = replyService.replyInsert(replyDTO);
    	
    	return insertCount == 1
    			? new ResponseEntity<>("success", HttpStatus.OK)
    					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    @GetMapping(value="/pages/{bno}",
    		produces = {MediaType.APPLICATION_JSON_UTF8_VALUE })
    public ResponseEntity<List<ReplyDTO>> getReplyList(@PathVariable("bno") Long bno) throws Exception {
		log.info("getReplyList ...... bno: " + bno);
    	
    	return new ResponseEntity<>(replyService.getReplyList(bno), HttpStatus.OK);
    }
    
    @GetMapping(value = "/{rno}",
    		produces = {MediaType.APPLICATION_XML_VALUE,
    				MediaType.APPLICATION_JSON_UTF8_VALUE})
    public ResponseEntity<ReplyDTO> replyRead(@PathVariable("rno") Long rno) throws Exception {
    	return new ResponseEntity<>(replyService.replyRead(rno), HttpStatus.OK);
    }
    
    @DeleteMapping(value="/{rno}", produces= {MediaType.TEXT_PLAIN_VALUE})
    public ResponseEntity<String> replyDelete(@PathVariable("rno") Long rno) throws Exception {
    	return replyService.replyDelete(rno) == 1
    			? new ResponseEntity<>("success", HttpStatus.OK)
    					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    @RequestMapping(method= {RequestMethod.PUT, RequestMethod.PATCH},
    		value="/{rno}",
    		consumes="application/json",
    		produces= {MediaType.TEXT_PLAIN_VALUE})
    public ResponseEntity<String> replyUpdate(@RequestBody ReplyDTO replyDTO,
    		@PathVariable("rno") Long rno) throws Exception {
    	replyDTO.setRno(rno);
    	
    	return replyService.replyUpdate(replyDTO) == 1
    			? new ResponseEntity<>("success", HttpStatus.OK)
    					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

}