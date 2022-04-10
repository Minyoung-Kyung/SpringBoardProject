<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="app" value="${pageContext.request.contextPath}"/>
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
<style>
.uploadResult{
	width: 100%;
	background-color: gray;
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
</style>
<script>
$(document).ready(function(e){

	$(".uploadResult").on("click", "button", function(e) {
		console.log("delete file");
		var targetFile = $(this).data("file");
		var type = $(this).data("type");
		
		var targetLi = $(this).closest("li");
		
		$.ajax({
			url: 'deleteFile',
			data: {fileName: targetFile, type: type},
			dataType: 'text',
			type: 'POST',
				success: function(result) {
					alert("파일이 삭제되었습니다.");
					
					targetLi.remove();
				}
		});
	});
	
	$("button[type='submit']").on("click", function(e) {
		e.preventDefault();
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
				str += "<img src='${app}/board/${pg}/display?fileName="+fileCallPath+"'>";
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
				str += "<img src='${app}/resources/img/attach.png'></a>";
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
			url: 'uploadAjaxAction',
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
	<form method="post" role="form">
		<table>
		<caption>게시물 작성</caption>
			<tr>
			   <th>제목</th>
			   <td><input type="text" name="title" autofocus="autofocus" 
			      required="required"/></td>
			</tr>
			<tr>
			   <th>이름</th>
			   <td><input type="text" name="name" required="required"/></td>
			</tr>
			<tr>
			   <th>비밀번호</th>
			   <td><input type="password" name="password" required="required" /></td>
			</tr>
			<tr>
			   <th>내용</th>
			   <td><textarea name="content" rows="5" cols="40" 
			      required="required"></textarea></td>
			</tr>
			<tr>
				<th></th>
				<td><input type="file" name='uploadFile' multiple></td>
			</tr>
			<tr>
			   <td colspan="2" align="center"><button type="submit">완료</button></td>
			</tr>
		</table>
	</form>
	
	<div class='uploadResult'>
		<ul>
		
		</ul>
	</div>
</body>
</html>