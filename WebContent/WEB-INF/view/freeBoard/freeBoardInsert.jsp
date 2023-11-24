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
			alert("�̸��� �ʼ��� �Դϴ�.");
			return;
		} 
		if (title == "") {
			alert("������ �ʼ��� �Դϴ�.");
			return;
		}
		if (content == "") {
			alert("������ �ʼ��� �Դϴ�.");
			return;
		}

		if (confirm("���� ����Ͻðڽ��ϱ�?")) {
			$.ajax({
				type : "POST", 
				url : "./freeBoardInsertPro.ino", 
				data : {"codeType" : $("select[name=type]").val(), "name" : name, "title" : title, "content" : content}, 
				success : function(response) {
					if (response.result) {
						if (confirm("�������� ���ư��ðڽ��ϱ�?")) {
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
		<h1>�����Խ���</h1>
	</div>
	<div style="width:650px;" align="right">
		<a href="./main.ino">����Ʈ��</a>
	</div>
	<hr style="width: 600px">

	<form name="frmIn">

		<table border="1">
			<tbody>
				<tr>
					<td style="width: 150px;" align="center">Ÿ�� :</td>
					<td style="width: 400px;">
						<select name="type">
							<option value="01">����</option>
							<option value="02">�͸�</option>
							<option value="03">QnA</option>
						</select>
					</td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">�̸� :</td>
					<td style="width: 400px;"><input type="text" name="name"/></td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">���� :</td>
					<td style="width: 400px;"><input type="text" name="title"/></td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">���� :</td>
					<td style="width: 400px;"><textarea name="content" rows="25" cols="65" ></textarea></td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td></td>
					<td align="right">
					<input type="button" value="�۾���" onclick="valid()">
					<input type="button" value="�ٽþ���" onclick="reset()">
					<input type="button" value="���" onclick="">
					&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
			</tfoot>
		</table>

	</form>



</body>
</html>