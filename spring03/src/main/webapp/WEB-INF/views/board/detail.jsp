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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-3.1.1.min.js" integrity="sha384-3ceskX3iaEnIogmQchP8opvBy3Mi7Ce34nWjpBIwVTHfGYWQS9jwHDVRnpKKHJg7" crossorigin="anonymous"></script>
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
.uploadResult{
	width: 100%;
	background-color: #f8f9fa;
}
.uploadResult ul{
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}
.uploadResult ul li{
	list-style: none;
	padding: 10px;
	align-content: center;
	text-align: center;
}
.uploadResult ul li img{
	width: 100px;
}
.uploadResult ul li span{
	color: black;
}
bigPictureWrapper{
	position: absolute;
	display: none;
	top: 0%;
	width: 543px;
	height: 543px;
	background-color: gray;
	z-index: 100;
	background: rgba(255,255,255,0.5);
}
input {
	margin: 5px 5px 5px 5px;
}
</style>
<script type="text/javascript" src="${contextPath}/resources/js/reply.js"></script>
<script type="text/javascript">
	$(document).ready(function () {
		var bnoValue = '<c:out value="${bno}"/>';
		var pg = '<c:out value="${pg}"/>';
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
					str += "<li class='left' id='reply' data-rno='" + list[i].rno + "'>";
					str += "  <div><div class='header'><strong class='primary-font'>" +
					list[i].replyer + "</strong><button id='deleteReplyBtn' style='float: right;'>??????</button>";
					str += "    <small>" + replyService.displayTime(list[i].replyDate) + "</small></div>";
					str += "    <p>" + list[i].reply;
					str += "    </p> </div></li>";
				}
				replyURL.html(str);
			});
		}
		
		$("#addReplyBtn").on("click", function(e) {
			var reply = {
				reply : $("input[id='reply']").val(),
				replyer : $("input[id='replyer']").val(),
				bno : '<c:out value="${bno}"/>'
			};
			
			replyService.add(reply, function(result) {
				alert("????????? ?????????????????????.");

				$("input[id='replyer']").val("");
				$("input[id='reply']").val("");
				
				showList(1);
			});
		});
		
		$(document).on("click", "#deleteReplyBtn", function() {
			var rno = $("li[id='reply']").data("rno");
			
			replyService.remove(rno, function(count){
				console.log(count);
				
				if(count === "success") {
					alert("????????? ?????????????????????.");
					
					showList(1);
				}
			}, function(err) {
				alert('ERROR...');
			});
		});
		
		(function(){
			$.getJSON("${contextPath}/board/${pg}/${bno}/getAttachList", {bno: bnoValue}, function(arr){
				console.log(arr);
				
				var str = "";
				
				$(arr).each(function(i, attach){
					
					if(attach.fileType){
						var fileCallPath = encodeURIComponent(attach.uploadPath+ "/s_"+attach.uuid+"_"+ attach.fileName);
						
						var fileLink = fileCallPath.replace(new RegExp(/\\/),"/");
						
						str += "<li data-path='"+attach.uploadPath+"'";
						str += " data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'data-type='"+attach.fileType+"'"
						str += "><div>";
						str += "<img src='${contextPath}/board/1/display?fileName="+fileCallPath+"'>";
						str += "</div>";
						str += "</li>";
					}else{
						var fileCallPath = encodeURIComponent(attach.uploadPath+"/"+attach.uuid+"_"+attach.fileName);
						
						var fileLink = fileCallPath.replace(new RegExp(/\\/),"/");
						
						str += "<li data-path='"+attach.uploadPath+"'";
						str += " data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'data-type='"+attach.fileType+"'"
						str += "><div>";
						str += "<span>"+attach.fileName+"</span>";
						str += "<img src='${contextPath}/resources/img/attach.png'></a>";
						str += "</div>";
						str += "</li>";
					}
					
				});
				
				$(".uploadResult ul").html(str);
			});
		})();
		
		$(".uploadResult").on("click", "li", function(e){
			console.log("view image");
			
			var liObj = $(this);
			
			var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
			
			if(liObj.data("type")){
				showImage(path.replace(new RegExp(/\\/),"/"));
			}else{
				self.location = "${contextPath}/board/1/download?fileName="+path;
			}
		});
		
		function showImage(fileCallPath) {
			$(".bigPictureWrapper").css("display", "flex").show();
			
			$(".bigPictureWrapper").html("<img src='${contextPath}/board/1/display?fileName="+fileCallPath+"'>")
									.animate({width:'543px', height:'543px'}, 1000);
		}
		
		$(".bigPictureWrapper").on("click", function(e){
			$(".bigPictureWrapper").animate({width:'0px', height: '0px'}, 1000);
			setTimeout(()=> {
				$(this).hide();
			}, 1000);
		})
	});	
</script>
</head>
<body>
	<h1 style="text-align: center;">????????? ????????????</h1>
	<table border="1" class="type10">
	<tr>
		<td class="tdStyle">??????</td>
		<td class="lastTdStyle">${vn}</td>
	</tr>
	
	<tr>
		<td class="tdStyle">??????</td>
		<td class="lastTdStyle">${boardDTO.title}</td>
	</tr>
	
	<tr>
		<td class="tdStyle">?????????</td>
		<td class="lastTdStyle">${boardDTO.name}</td>
	</tr>
	
	<tr>
		<td class="tdStyle">??????</td>
		<td class="lastTdStyle">${boardDTO.content}</td>
	</tr>
	
	<tr>
		<td class="tdStyle">?????????</td>
		<jsp:useBean id="now" class="java.util.Date" />
		<fmt:formatDate value="${now}" type="date" pattern="yyyyMMdd" var="nowDate"/>
		<fmt:formatDate value="${boardDTO.regdate}" type="date" pattern="yyyyMMdd" var="postDate"/>
		<c:if test="${nowDate - postDate == 0}">
			<td class="lastTdStyle"><fmt:formatDate value="${boardDTO.regdate}" pattern="HH:mm:ss" type="time"/></td>
		</c:if>
		<c:if test="${nowDate - postDate != 0}">
			<td class="lastTdStyle"><fmt:formatDate value="${boardDTO.regdate}" pattern="yyyy-MM-dd" type="date"/></td>
		</c:if>
	</tr>
	
	
	<tr>
		<td class="tdStyle">?????????</td>
		<td class="lastTdStyle">${boardDTO.readcount}</td>
	</tr>
	</table><br/>
	<a href="../">????????????</a>
	<a href="${vn}/update">??????</a>
	<a href="${vn}/delete">??????</a>
	
	<hr />
	
	<div class = 'bigPictureWrapper'>
		<ul>
		</ul>
	</div>
	
	<div class = 'uploadResult'>
		<ul>
		</ul>
	</div>
	
	<div>
		<div>
			<strong>??????</strong>
		</div>
		
		<div>
			<ul class="chat">
				<li data-rno='12'>
					<div>
						<div class="header">
							<strong>?????????</strong>
							<small>?????? ?????????</small>
						</div>
						<p>??????</p>
					</div>
				</li>
			</ul>
		</div>
	</div>

	<hr />
	
	<div class="replies" id="replies" style="width: 100%;">
		<div>
			<p>
		  		<label for="replyer">?????????</label><input type="text" id="replyer" name='replyer' value="">
		  		<br/>
		  		<label for="reply">??????&nbsp;&nbsp;&nbsp;</label><input type="text" id="reply" name='reply' value="">
		  	</p>
		  	<button id='addReplyBtn'>?????? ??????</button>
		</div>
	</div>
	
</body>
</html>