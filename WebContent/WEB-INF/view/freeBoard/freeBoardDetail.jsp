<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script>
	$(document).ready(function() {
		$('select[name=type]').val('${freeBoardDto.codeType}');
	});
	
	function boardModify() {
		var title = $('input[name=title]').val();
		var content = $('textarea[name=content]').val();
		var codeType = $('select[name=type]').val();
		
		if (title == "") {
			alert("제목은 필수값 입니다.");
			return;
		}
		if (content == "") {
			alert("내용은 필수값 입니다.");
			return;
		}

		if (confirm("글을 수정하시겠습니까?")) {
			$.ajax({
				type : "POST", 
				url : "./freeBoardModify.ino", 
				data : {"codeType" : codeType, "num" : $("input[name=num]").val(), "title" : title, "content" : content}, 
				success : function(response) {
					if (response.result) {
						if (confirm("메인으로 돌아가시겠습니까?")) {
							window.location.replace("./main.ino");
						} else {
							window.location.replace("freeBoardDetail.ino?num=" + $("input[name=num]").val());
						}
					} else {
						alert(response.data);
					}
				}
			});

		} else {
			return;
		}
	}

	function boardDelete() {
		if (confirm("글을 삭제하시겠습니까?")) {
			$.ajax({
				type : "POST", 
				url : "./freeBoardDelete.ino", 
				data : {"num" : $("input[name=num]").val()}, 
				success : function(response) {
					if (response.result) {
						alert("글 삭제에 성공하였습니다.");
						window.location.replace("./main.ino");	
					} else {
						alert(response.data);
					}
				}
			});

		} else {
			return;
		}
		
	}
</script>
</head>
<body>

	<div>
		<h1>자유게시판</h1>
	</div>
	<div style="width:650px;" align="right">
		<a href="./main.ino">리스트로</a>
	</div>
	<hr style="width: 600px">

	<form name="insertForm">
		<input type="hidden" name="num" value="${freeBoardDto.num }" />
		<table border="1">
			<tbody>
				<tr>
					<td style="width: 150px;" align="center">타입 :</td>
					<td style="width: 400px;">
						<select id = "codeType" name="type">
							<option value="01">자유</option>
							<option value="02">익명</option>
							<option value="03">QnA</option>
						</select></td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">이름 :</td>
					<td style="width: 400px;"><input type="text" name="name" value="${freeBoardDto.name }" readonly/></td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">제목 :</td>
					<td style="width: 400px;"><input type="text" name="title"  value="${freeBoardDto.title }"/></td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">내용 :</td>
					<td style="width: 400px;"><textarea name="content" rows="25" cols="65"  >${freeBoardDto.content }</textarea></td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td></td>
					<td align="right">
					<input type="button" value="수정" onclick="boardModify()" >
					<input type="button" value="삭제" onclick="boardDelete()" >
					<input type="button" value="취소" onclick="location.href='./main.ino'">
					&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
			</tfoot>
		</table>

	</form>

</body>
</html>