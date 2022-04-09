<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
body {
  margin: 2% 20% 5% 20%;
}
table.type10 {
  border-collapse: collapse;
  text-align: left;
  line-height: 1.5;
  border-top: 1px solid #ccc;
  border-bottom: 1px solid #ccc;
  margin: 20px 10px;
}
table.type10 thead th {
  width: 150px;
  padding: 10px;
  font-weight: bold;
  vertical-align: top;
  color: #fff;
  background: #e7708d;
  margin: 20px 10px;
}
table.type10 tbody th {
  width: 150px;
  padding: 10px;
}
table.type10 td {
  width: 350px;
  padding: 10px;
  vertical-align: top;
}
</style>

<script>
</script>
</head>
<body>
	<table border="1" class="type10">
	<h1 style="text-align: center;">게시물 리스트</h1>
		<tr>
			현재 페이지 : ${pg} / 전체 페이지 수 : ${pageCount}
		</tr>
		<thead>
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>작성일</th>
			<th>조회수</th>
		</tr>
		</thead>
		
		<tbody>
		<c:forEach items="${list}" var="dto" varStatus="vs">
		<jsp:useBean id="now" class="java.util.Date" />
		<fmt:formatDate value="${now}" type="date" pattern="yyyyMMdd" var="nowDate"/>
		<fmt:formatDate value="${dto.regdate}" type="date" pattern="yyyyMMdd" var="postDate" />
		<tr>
			<td>${recordCount - vs.index - ((pg-1)*pageSize)}</td>
			<td><a href="${dto.bno}/?vn=${recordCount - vs.index - ((pg-1)*pageSize)}">${dto.title}</a></td>
			<td>${dto.name}</td>
			<c:if test="${nowDate - postDate == 0}">
				<td><fmt:formatDate value="${dto.regdate}" pattern="HH:mm:ss" type="time"/></td>
			</c:if>
			<c:if test="${nowDate - postDate != 0}">
				<td><fmt:formatDate value="${dto.regdate}" pattern="yyyy-MM-dd" type="date"/></td>
			</c:if>
			<td>${dto.readcount}</td>
		</tr>
		</c:forEach>
	
		<td colspan="5" style="text-align: center;">
			<c:if test="${startPage != 1}">
				<a href="../${startPage-1}/">◀</a>
			</c:if>
			<c:forEach begin="${startPage}" end="${endPage}" var="p">
				<c:if test="${p == pg}">${p}</c:if>
				<c:if test="${p != pg}"><a href="../${p}/">${p}</a></c:if>
			</c:forEach>
			<c:if test="${endPage != pageCount}">
				<a href="../${endPage+1}/">▶</a>
			</c:if>
		</td>
		</tbody>
	</table><br/>
	<a href="insert">글쓰기</a>
	
	<div class="form-group row justify-content-center">
		<div class="w100" style="padding-right:10px">
			<select class="form-control form-control-sm" name="searchType" id="searchType">
				<option value="title">제목</option>

				<option value="Content">내용</option>

				<option value="reg_id">작성자</option>

			</select>
			<input type="text" class="form-control form-control-sm" name="keyword" id="keyword">
			<button class="btn btn-sm btn-primary" name="btnSearch" id="btnSearch">검색</button>
		</div>
	</div>
</body>
</html>