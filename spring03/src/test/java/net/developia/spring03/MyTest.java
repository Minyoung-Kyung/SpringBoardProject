package net.developia.spring03;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;
import static org.junit.Assert.assertNotNull;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.log4j.Log4j;
import net.developia.spring03.dto.BoardDTO;

@Log4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:**/*-context.xml"})
public class MyTest {
	
	@BeforeClass
	public static void testBeforeClass() {
		log.info("@BeforeClass : 테스트 시작시 최초 1번 실행");
	}
	
	@AfterClass
	public static void testAfterClass() {
		log.info("@AfterClass : 테스트 종료시 마지막 1번 실행");
	}
	
	@Before
	public void testBefore() {
		log.info("@Before : 각 메소드가 실행되기 전 실행");
	}
	
	@After
	public void testAfter() {
		log.info("@After : 각 메소드가 실행된 후 실행");
	}
	
	@Test
	public void testBoardDTO() {
		BoardDTO boardDTO = new BoardDTO();
		boardDTO.setBno((long) 1);
		boardDTO.setTitle("제목");
		boardDTO.setName("이름");
		boardDTO.setPassword("1111");
		log.info(boardDTO.toString());
		
		assertNotNull(boardDTO);
	}
	
	@Test(timeout=2000)
	public void testTimeout() {
		BoardDTO boardDTO = new BoardDTO();
		try {
			Thread.sleep(1500);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		boardDTO.setBno((long) 1);
		boardDTO.setTitle("제목");
		boardDTO.setName("이름");
		boardDTO.setPassword("1111");
		log.info(boardDTO.toString());
		
		assertNotNull(boardDTO);
	}
	
	@Test
	@Ignore
	public void createBoardDTO2() {
		log.info("실행하지 않음");
	}
	
	@Test
	public void testAdd() {
		TestCalculator tc = new TestCalculator();
		assertEquals(tc.add(334, 333), 667);
	}
}
