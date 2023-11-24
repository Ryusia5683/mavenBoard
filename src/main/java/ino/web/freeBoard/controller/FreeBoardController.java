package ino.web.freeBoard.controller;

import ino.web.freeBoard.dto.FreeBoardDto;
import ino.web.freeBoard.service.FreeBoardService;
import ino.web.freeBoard.common.util.*;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class FreeBoardController {

	@Autowired
	private FreeBoardService freeBoardService;

	@RequestMapping("/main.ino")
	public ModelAndView main(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		Pagination pagination = new Pagination();
		pagination.setEndPage(freeBoardService.getAllCount());
		Map<String, Object> paging = new HashMap<String, Object>();
		paging.put("page", pagination.getPage());
		paging.put("start", pagination.getStart());
		paging.put("end", pagination.getEnd());
		List<FreeBoardDto> list = freeBoardService.freeBoardList(paging);

		mav.setViewName("boardMain");
		mav.addObject("freeBoardList",list);
		mav.addObject("paging", pagination.getPagination());
		return mav;
	}
	
	@RequestMapping("boardSearch.ino")
	public @ResponseBody Map<String, Object> BoardSearch(@RequestBody Map<String, Object> searchArr) {
		Pagination pagination = new Pagination();
		pagination.setEndPage(freeBoardService.getListCount(searchArr));
		pagination.setPage((int) searchArr.get("page"));
		searchArr.put("start", pagination.getStart());
		searchArr.put("end", pagination.getEnd());
		
		Map<String, Object> list = new HashMap<String, Object>();
		list.put("list", freeBoardService.freeBoardList(searchArr));
		list.put("paging", pagination.getPagination());
		return list;
	}

	@RequestMapping("/freeBoardInsert.ino")
	public String freeBoardInsert(){
		return "freeBoardInsert";
	}

	@RequestMapping("/freeBoardInsertPro.ino")
	public @ResponseBody Map<String, Object> freeBoardInsertPro(HttpServletRequest request, FreeBoardDto dto){
		Map<String, Object>  map = new HashMap<String, Object>();
		boolean result = false;
		String data = null;
		try {
			result = freeBoardService.freeBoardInsertPro(dto);
			data = String.valueOf(freeBoardService.getNewNum());
		} catch (Exception e) {
			e.printStackTrace();
			data = e.toString();
		}
		map.put("result", String.valueOf(result));
		map.put("data", data);
		return map;
//		return "redirect:freeBoardDetail.ino?num="+dto.getNum();
	}

	@RequestMapping("/freeBoardDetail.ino")
	public ModelAndView freeBoardDetail(HttpServletRequest request, int num){
		FreeBoardDto dto = freeBoardService.getDetailByNum(num);
		return new ModelAndView("freeBoardDetail", "freeBoardDto", dto);
	}

	@RequestMapping("/freeBoardModify.ino")
	public @ResponseBody Map<String, Object> freeBoardModify(HttpServletRequest request, FreeBoardDto dto){
		Map<String, Object>  map = new HashMap<String, Object>();
		boolean result = false;
		String data = null;
		try {
			result = freeBoardService.freeBoardModify(dto);
		} catch (Exception e) {
			e.printStackTrace();
			data = e.getCause().toString();
		}
		map.put("result", String.valueOf(result));
		map.put("data", data);
		return map;
	}


	@RequestMapping("/freeBoardDelete.ino")
	public @ResponseBody Map<String, String> FreeBoardDelete(String num){
		Map<String, String>  map = new HashMap<String, String>();
		boolean result = false;
		String data = null;
		try {
			result = freeBoardService.FreeBoardDelete(num);
		} catch (Exception e) {
			e.printStackTrace();
			data = e.toString();
		}
		map.put("result", String.valueOf(result));
		map.put("data", data);
		return map;
//		return "redirect:/main.ino";
	}
	
	@RequestMapping("freeBoardMultiDelete.ino")
	public @ResponseBody Map<String, Object> FreeBoardMultiDelete(@RequestParam(value="chkArr[]") List<Integer> num) {
		Map<String, Object>  map = new HashMap<String, Object>();
		boolean result = false;
		String data = null;
		try {
			result = freeBoardService.FreeBoardMultiDelete(num);
		} catch (Exception e) {
			e.printStackTrace();
			data = e.toString();
		}
		map.put("result", String.valueOf(result));
		map.put("data", data);
		return map;
	}
	
}