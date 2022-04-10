<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>
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
</style>
<script>
$(document).ready(function(e) {

	$(".uploadResult").on("click", "button", function(e) {
		console.log("delete file");
		
		if(confirm("파일을 지우시겠습니까?")) {
			var targetLi = $(this).closest("li");
			targetLi.remove();
		}
	});
	
	var bnoValue = '<c:out value="${bno}"/>';
	
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
					str += "<span>"+attach.fileName+"</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\'data-type='file'>X</button><br>";
					str += "<img src='${contextPath}/board/${pg}/display?fileName="+fileCallPath+"'>";
					str += "</div>";
					str += "</li>";
				}else{
					var fileCallPath = encodeURIComponent(attach.uploadPath+"/"+attach.uuid+"_"+attach.fileName);
					
					var fileLink = fileCallPath.replace(new RegExp(/\\/),"/");
					
					str += "<li data-path='"+attach.uploadPath+"'";
					str += " data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'data-type='"+attach.fileType+"'"
					str += "><div>";
					str += "<span>"+attach.fileName+"</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\'data-type='file'>X</button><br>";
					str += "<img src='${contextPath}/resources/img/attach.png'></a>";
					str += "</div>";
					str += "</li>";
				}
			});
			
			$(".uploadResult ul").html(str);
		});
	})();
	
	var formObj = $("form");
		
	$('button').on("click", function(e) {
		e.preventDefault();
		
		var operation = $(this).data("oper");
		
		console.log(operation);
		
		if(operation === 'update') {
			console.log("submit clicked");
			
			var str = "";
			
			$(".uploadResult ul li").each(function(i, obj) {
				var jobj = $(obj);
				
				console.dir(jobj);
				
				str += "<input type='hidden' name='attachList["+i+"].fileName' ";
				str += "value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' ";
				str += "value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' ";
				str += "value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].fileType' ";
				str += "value='"+jobj.data("type")+"'>";
			});
			
			$("form[role='form']").append(str).submit();
		}
		formObj.submit();
	});
			
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880;
	
	function checkExtension(fileName, fileSize){
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과");
			return false;
		}
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드 할 수 없습니다.");
			return false;
		}
		return true;
	}
		
	function showUploadResult(uploadResultArr) {
		if(!uploadResultArr || uploadResultArr.length == 0) {return;}
		
		var uploadUL = $(".uploadResult ul");
		
		var str="";
		
		$(uploadResultArr).each(function(i, obj){
			if(obj.fileType){
				var fileCallPath = encodeURIComponent(obj.uploadPath+ "/s_"+obj.uuid+"_"+ obj.fileName);
				
				var fileLink = fileCallPath.replace(new RegExp(/\\/),"/");
				
				str += "<li data-path='"+obj.uploadPath+"'";
				str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"'data-type='"+obj.fileType+"'"
				str += "><div>";
				str += "<span>"+obj.fileName+"</span>";
				str += "<button type='button' data-file=\'"+fileCallPath+"\'data-type='file'>X</button><br>";
				str += "<img src='${contextPath}/board/${pg}/display?fileName="+fileCallPath+"'>";
				str += "</div>";
				str += "</li>";
			}else{
				var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
				
				var fileLink = fileCallPath.replace(new RegExp(/\\/),"/");
				
				str += "<li data-path='"+obj.uploadPath+"'";
				str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"'data-type='"+obj.fileType+"'"
				str += "><div>";
				str += "<span>"+obj.fileName+"</span>";
				str += "<button type='button' data-file=\'"+fileCallPath+"\'data-type='file'>X</button><br>";
				str += "<img src='${contextPath}/resources/img/attach.png'></a>";
				str += "</div>";
				str += "</li>";
			}
		}); 
		
		uploadUL.append(str);
	}
		
	$("input[type='file']").change(function(e){
		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;
		console.log(files);
		
		for(var i = 0; i < files.length ; i++){
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			formData.append("uploadFile", files[i]);
		}
	
		$.ajax({
			url: '${contextPath}/board/${pg}/uploadAjaxAction',
			processData: false,
			contentType: false,
			data: formData,
			type: 'POST',
			dataType: 'json',
				success: function(result){
				console.log(result);
				
				showUploadResult(result);
			}
		});
	});
});
</script>
</head>
<body>
	<c:set var="dto" value="${boardDTO}" />
	<form method="post" role="form">
		<table>
		<h1 style="text-align: center;">게시물 수정</h1>
			<tr>
				<th>번호</th>
				<td>${dto.bno}<input type="hidden" name="no"  
			required="required" value="${dto.bno}" /></td>
			</tr>
			<tr>
				<th>제목</th>
				<td><input type="text" name="title" autofocus="autofocus" 
					required="required" value="${dto.title}" /></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><input type="text" name="name" required="required" value="${dto.name}" /></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="password" name="password" required="required" /><br/>
					* 처음 글 작성시 입력했던 비밀번호를 다시 입력하세요
				</td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="content" rows="5" cols="40" 
					required="required">${dto.content}</textarea></td>
			</tr>
			<tr>
				<th></th>
				<td><input type="file" name='uploadFile' multiple></td>
			</tr>
			<tr>
				<td colspan="2" align="center"><button data-oper="update" id="update" type="submit">완료</button></td>
			</tr>
		</table>
	</form>
	
	<div class='uploadResult'>
		<ul>
		
		</ul>
	</div>
</body>
</html>