<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script>
	function valid() {
		var name = $('input[name=name]').val();
		var title = $('input[name=title]').val();
		var content = $('textarea[name=content]').val();
		
		if (name == "") {
			alert("이름은 필수값 입니다.");
			return;
		} 
		if (title == "") {
			alert("제목은 필수값 입니다.");
			return;
		}
		if (content == "") {
			alert("내용은 필수값 입니다.");
			return;
		}

		if (confirm("글을 등록하시겠습니까?")) {
			$.ajax({
				type : "POST", 
				url : "./freeBoardInsertPro.ino", 
				data : {"codeType" : $("select[name=type]").val(), "name" : name, "title" : title, "content" : content}, 
				success : function(response) {
					if (response.result) {
						if (confirm("메인으로 돌아가시겠습니까?")) {
							window.location.replace("./main.ino");
						} else {
							window.location.replace("freeBoardDetail.ino?num=" + response.data);
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

	<form name="frmIn">

		<table border="1">
			<tbody>
				<tr>
					<td style="width: 150px;" align="center">타입 :</td>
					<td style="width: 400px;">
						<select name="type">
							<option value="01">자유</option>
							<option value="02">익명</option>
							<option value="03">QnA</option>
						</select>
					</td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">이름 :</td>
					<td style="width: 400px;"><input type="text" name="name"/></td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">제목 :</td>
					<td style="width: 400px;"><input type="text" name="title"/></td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">내용 :</td>
					<td style="width: 400px;"><textarea name="content" rows="25" cols="65" ></textarea></td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td></td>
					<td align="right">
					<input type="button" value="글쓰기" onclick="valid()">
					<input type="button" value="다시쓰기" onclick="reset()">
					<input type="button" value="취소" onclick="">
					&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
			</tfoot>
		</table>

	</form>



</body>
</html>