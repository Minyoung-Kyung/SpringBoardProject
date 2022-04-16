<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
body {
  margin: 2% 20% 5% 20%;
}
</style>
</head>
<body>
	<form method="post">
		<table>
		<h1 style="text-align: center;">게시물 삭제</h1>
		<tr>
		   <th>번호</th>
		   <td>${vn}<input type="hidden" name="bno" value='${bno}'/></td>
		</tr>
		<tr>
		   <th>비밀번호</th>
		   <td><input type="password" name="password" required="required" autofocus="autofocus"/><br/>
		   		* 처음 글 작성시 입력했던 비밀번호를 다시 입력하세요
		   </td>
		</tr>
		<tr>
		   <td colspan="2" align="center"><input type="submit" value="완료" /></td>
		</tr>
		</table>
	</form>
</body>
</html>