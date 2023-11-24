package ino.web.freeBoard.service;

import ino.web.freeBoard.dto.FreeBoardDto;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FreeBoardService {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<FreeBoardDto> freeBoardList(Map<String, Object> searchArr){
		return sqlSessionTemplate.selectList("freeBoardGetList", searchArr);
	}

	public boolean freeBoardInsertPro(FreeBoardDto dto){
		if (sqlSessionTemplate.insert("freeBoardInsertPro",dto) == 1) {
			return true;
		}
		return false;
	}

	public FreeBoardDto getDetailByNum(int num){
		return sqlSessionTemplate.selectOne("freeBoardDetailByNum", num);
	}

	public int getNewNum(){
		return sqlSessionTemplate.selectOne("freeBoardNewNum");
	}

	public boolean freeBoardModify(FreeBoardDto dto){
		if (sqlSessionTemplate.update("freeBoardModify", dto) == 1) {
			return true;
		}
		return false;
	}

	public boolean FreeBoardDelete(String num) {
		if (sqlSessionTemplate.delete("freeBoardDelete", num) == 1) {
			return true;
		}
		return false;
	}

	public boolean FreeBoardMultiDelete(List<Integer> num) {
		if (sqlSessionTemplate.delete("freeBoardMultiDelete", num) == num.size()) {
			return true;
		}
		return false;
	}

	public int getAllCount() {
		return sqlSessionTemplate.selectOne("freeBoardAllCount");
	}

	public int getListCount(Map<String, Object> searchArr) {
		return sqlSessionTemplate.selectOne("freeBoardListCount", searchArr);
	}
	
}
