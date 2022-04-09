<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>
<title>Insert title here</title>
<style>
body {
  margin: 2% 20% 5% 20%;
}
table.type10 {
  border-collapse: collapse;
  text-align: left;
  line-height: 1.5;
  border-top: 1px solid #ccc;
  border-bottom: 1px solid #ccc;
}
.tdStyle {
  width: 150px;
  padding: 10px;
  font-weight: bold;
  text-align: center;
  vertical-align: top;
  color: #fff;
  background: #e7708d;
  margin: 20px 10px;
}
.lastTdStyle {
  width: 350px;
  padding: 10px;
  vertical-align: top;
}
</style>
<script type="text/javascript" src="${contextPath}/resources/js/reply.js"></script>
<script type="text/javascript">
	$(document).ready(function () {
		var bnoValue = '<c:out value="${bno}"/>';
		var replyURL = $(".chat");
		
		showList(1);
		
		function showList() {
			replyService.getList({bno:bnoValue}, function(list) {
				var str = "";
				if (list==null || list.length==0){
					replyURL.html("");
					
					return;
				}
				
				for (var i = 0, len = list.length || 0; i < len; i++) {
					str += "<li class='left' data-rno='" + list[i].rno + "'>";
					str += "  <div><div class='header'><strong class='primary-font'>" +
					list[i].replyer + "</strong><button id='deleteReplyBtn' style='float: right;'>삭제</button>";
					str += "    <small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small></div>";
					str += "    <p>" + list[i].reply;
					str += "    </p> </div></li>";
				}
				replyURL.html(str);
			});
		}
		
		$("#addReplyBtn").on("click", function(e) {
			
			var reply = {
					reply : $("#reply").val(),
					replyer : $("#replyer").val(),
					bno : '<c:out value="${bno}"/>'
			};
			
			replyService.add(reply, function(result) {
				alert("댓글이 입력되었습니다.");

				$("#reply").val("");
				$("#replyer").val("");
				
				showList(1);
			});
		});
		
		$(document).on("click", "#deleteReplyBtn", function() {
			var rno = $("li").data("rno");
			
			replyService.remove(rno, function(count){
				console.log(count);
				
				if(count === "success") {
					alert("댓글이 삭제되었습니다.");
					
					showList(1);
				}
			}, function(err) {
				alert('ERROR...');
			});
		});
	});	
</script>
</head>
<body>
	<table border="1" class="type10">
		<h1 style="text-align: center;">게시물 상세보기</h1>
	<tr>
		<td class="tdStyle">번호</td>
		<td class="lastTdStyle">${vn}</td>
	</tr>
	
	<tr>
		<td class="tdStyle">제목</td>
		<td class="lastTdStyle">${boardDTO.title}</td>
	</tr>
	
	<tr>
		<td class="tdStyle">작성자</td>
		<td class="lastTdStyle">${boardDTO.name}</td>
	</tr>
	
	<tr>
		<td class="tdStyle">내용</td>
		<td class="lastTdStyle">${boardDTO.content}</td>
	</tr>
	
	<tr>
		<td class="tdStyle">작성일</td>
		<jsp:useBean id="now" class="java.util.Date" />
		<fmt:formatDate value="${now}" type="date" pattern="yyyyMMdd" var="nowDate"/>
		<fmt:formatDate value="${boardDTO.regdate}" type="date" pattern="yyyyMMdd" var="postDate" />
		<c:if test="${nowDate - postDate == 0}">
			<td class="lastTdStyle"><fmt:formatDate value="${boardDTO.regdate}" pattern="HH:mm:ss" type="time"/></td>
		</c:if>
		<c:if test="${nowDate - postDate != 0}">
			<td class="lastTdStyle"><fmt:formatDate value="${boardDTO.regdate}" pattern="yyyy-MM-dd" type="date"/></td>
		</c:if>
	</tr>
	
	
	<tr>
		<td class="tdStyle">조회수</td>
		<td class="lastTdStyle">${boardDTO.readcount}</td>
	</tr>
		</table><br/>
		<a href="../">리스트</a>
		<a href="update">수정</a>
		<a href="delete">삭제</a>
	
	<hr />
	
	<div class="row">
		<div class="col-lg-12">
			
			<div class="panel panel-default">
				<div class="panel-heading">
					<i class="fa fa-comments fa-fw"></i> 댓글
				</div>
			</div>
			
			<div class="panel-body">
				<ul class="chat">
					<li class="left clearfix" data-rno='12'>
						<div>
							<div class="header">
								<strong class="primary-font">작성자</strong>
								<small class="pull-right text-muted">댓글 작성일</small>
							</div>
							<p>내용</p>
						</div>
					</li>
				</ul>
			</div>
			
		</div>
	</div>

	<hr />
	
	<div class="replies" id="replies">
		<div>
		  	<label for="replyer">작성자</label><input type="text" id="replyer" name='replyer' value="">
		  <br/>
		  	<label for="reply">내용</label><input type="text" id="reply" name='repl' value="">
		  	<button id='addReplyBtn' class="btn btn-primary btn-xs pull-right">댓글 달기</button>
		</div>
	</div>
	
</body>
</html>