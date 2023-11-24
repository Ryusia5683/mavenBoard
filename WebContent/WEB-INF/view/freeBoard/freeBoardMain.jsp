<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script>
	$(document).ready(function() {
		$("input[name=chkAll]").click(function() {
			if ($(this).is(":checked")) {
				$("input[name=chkNum]").prop("checked", true);
			} else {
				$("input[name=chkNum]").prop("checked", false);
			}
		});
		
		$("input[name=chkSum]").click(function() {
			var total = $("input[name=chkSum]").length;
			var checked = $("input[name=chkSum]:checked").length;
			
			if (total != checked) {
				$("input[name=chkAll]").prop("checked", false);
			} else {
				$("input[name=chkAll]").prop("checked", true); 
			}
		});
		$("select[name=search]").on("change", function(){
			$("select.dynamic").remove();
			$("input[type=text]").remove();
			$(".searchBox").find("span").remove();
			var html = '';
			if ($(this).val() == 0) {
				return;
			} else if ($(this).val() == 1) {
				html += " <select name='keyowrd' class='dynamic'>";
				html += "<option value='01'>자유</option>";
				html += "<option value='02'>익명</option>";
				html += "<option value='03'>QnA</option>";
				html += "</select>";
			} else if ($(this).val() == 6) {
				html += " <input type='text' name='keyword' class='dynamic' minlength = '8' maxlength='8'/><span> ~ </span>";
				html += "<input type='text' name='keyword' class='dynamic' maxlength='8'/>";
			} else {
				html += " <input type='text' name='keyword' class='dynamic'/>";
			}
			$(this).after(html);
			html = '';
		})

	});     

	var searchArr = {};
	
	function searchBtn() {

		var type = $('select[name=search]').val();
		var reg = /[^0-9]/g;
		if (type == 2) {
			var keyword = $('input[name=keyword]').val();
			keyword = $.trim(keyword);
			if (reg.test(keyword)) {
				alert('숫자만 입력하세요.');
				return;
			}
		}

		if (type == 6) {
			var ea = $('.searchBox').find('input[name=keyword]').length;
			for (var i = 0; i < ea; i++) {
				var keyword = $('.searchBox').find('input[type=text][name=keyword]').eq(i).val();
				keyword = $.trim(keyword);
				if (reg.test(keyword)) {
					alert('숫자만 입력하세요.');
					return;
				}
			}
			
//			if (keyword1.toString().length != 8 || keyword2.toString().length != 8) {
//				alert("날짜를 8자리로 입력하세요.");
//				return;
//			}
		}

		searchArr.search = $('select[name=search]').val();			// search : 0 ~ 6 
		var keyLength = $('.dynamic').length;
		
		for (var i = 0; i < keyLength; i++) {
			searchArr['keyword' + (i + 1)] = $.trim($('.dynamic').eq(i).val());
			console.log("$('.dynamic').eq(" + i + ").val() : '" + $('.dynamic').eq(i).val() + "'");
		}
		
		boardSearch(1);	
	}
	
	function boardSearch(page) {

		searchArr.page = page;
		$.ajax({
			type : "POST", 
			url : "boardSearch.ino", 
			data : JSON.stringify(searchArr),
			dataType : 'json', 
			contentType : 'application/json; charset=UTF-8',
			success : function(data) {
				$('#tb').empty();
				var temp_html = '';
				$.each(data.list, function(index, item){
					temp_html = '<tr><td><input type="checkbox" name="chkNum" value="' + item.num + '"></td>';
					temp_html += '<td style="width: 55px; padding-left: 30px;" align="center">' + item.codeType + '</td>';
					temp_html += '<td style="width: 50px; padding-left: 10px;" align="center">' + item.num + '</td>';
					temp_html += '<td style="width: 125px; align="center"><a href="./freeBoardDetail.ino?num=' + item.num + '">' + item.title + '</td>';
					temp_html += '<td style="width: 48px; padding-left: 50px;" align="center">' + item.name + '</td>';
					temp_html += '<td style="width: 100px; padding-left: 95px;" align="center">' + item.regdate + '</td></tr>';
					$('#tb').append(temp_html);
				})
				$(".paging").remove();
				$("#form").after(data.paging);
			},
		    error : function(xhr, status, error) {
		        console.log(status, error);
		    }
		});
	}
	
	function getSelectedValues() {
//		var num = "";
		var chkArr = [];
		$("input[name=chkNum]:checked").each(function(){
//			num += "," + $(this).val();
			chkArr.push($(this).val());
		})
//		num = num.substr(1);
//		return num;
		return chkArr;
	}
	
	function multiDelete() {
		var chkArr = getSelectedValues();
		if (chkArr.length == 0) {
			alert("삭제할 글을 선택하세요.");
			return;
		} else {
			if (confirm("정말 삭제하시겠습니까?")) {
				
				$.ajax({
					type : "POST", 
					url : "./freeBoardMultiDelete.ino", 
					data : {"chkArr" : chkArr}, 
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
	}
	
</script>
</head>
<body>

	<div>
		<h1>자유게시판</h1>
	</div>
	
	<div class="searchBox">
		<select name="search">
			<option value="0">전체</option>
			<option value="1">타입</option> <!-- select -->
			<option value="2">번호</option> <!-- input type text 검색버튼 클릭시에 숫자인지 체크할것.-->
			<option value="3">제목</option> <!-- input type text -->
			<option value="4">이름</option> <!-- input type text -->
			<option value="5">내용</option> <!-- input type text -->
			<option value="6">기간</option> <!-- input type text input type text 검색버튼 클릭시에 숫자인지 체크할것. ex) 20231102 8자리 -->
		</select>
		<button onclick='searchBtn()'>검색</button>
	</div>
	<div style="width:650px;" align="right">
		<a href="./freeBoardInsert.ino">글쓰기</a>
	</div>
	<hr style="width: 600px;">
	<form id="form">
		<div style="padding-bottom: 10px;">
			<input type="hidden" name="num" />
			<table border="1">
				<thead>
					<tr>
						<td><input type="checkbox" name="chkAll" ></td>
						<td style="width: 55px; padding-left: 30px;" align="center">타입</td>
						<td style="width: 50px; padding-left: 10px;" align="center">글번호</td>
						<td style="width: 125px;" align="center">글제목</td>
						<td style="width: 48px; padding-left: 50px;" align="center">글쓴이</td>
						<td style="width: 100px; padding-left: 95px;" align="center">작성일시</td>
					</tr>
				</thead>
			</table>
		</div>
		<hr style="width: 600px;">
	
		<div>
			<table border="1">
				<tbody id="tb" name="tb">
						<c:forEach var="dto" items="${freeBoardList }">
							<tr>
								<td><input type="checkbox" name="chkNum" value="${dto.num }"></td>
								<td style="width: 55px; padding-left: 30px;" align="center">${dto.codeType }</td>
								<td style="width: 50px; padding-left: 10px;" align="center">${dto.num }</td>
								<td style="width: 125px; align="center"><a href="./freeBoardDetail.ino?num=${dto.num }">${dto.title }</a></td>
								<td style="width: 48px; padding-left: 50px;" align="center">${dto.name }</td>
								<td style="width: 100px; padding-left: 95px;" align="center">${dto.regdate }</td>
							<tr>
						</c:forEach>
				</tbody>
			<tfoot>
				<tr>
					<td align="right" colspan="6">
					<input style="margin: 3px 0;" type="button" value="삭제" onclick="multiDelete()">
					&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
			</tfoot>
			</table>
		</div>
	</form>
	<style>
		.paging {
			margin-top: 10px;
			display: block;
			width: 100%;
			text-align: center;
		}
		.paging > span:not(:last-child) {
			margin-right: 5px;
		}
		.paging > span {
			display: inline-block;
			width: 25px;
			height: 25px;
			border-radius: 2px;
			background-color: #03A9F4;	
			color : #fff;	
			font-size: 13px;	
			line-height: 24px;
		}
		.paging > span:hover > a {	
			border-radius: 2px;	
			background-color: #03A9F4;	
			color: #fff;
		}
		.paging > span > a {	
			display : inline-block;	
			width : 100%;	
			height : 100%;	
			border-radius: 2px;	
			cursor : pointer;	
			text-decoration : none;	
			background-color: #fff;	
			color : #8e8e8e;
		}
	</style>
	${paging }
</body>
</html>