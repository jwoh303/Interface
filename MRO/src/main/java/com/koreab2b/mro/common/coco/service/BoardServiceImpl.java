package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.BoardDao;

@Service("boardService")
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardDao boardDao; 
	
	public List<Map<String,String>> boardList(Map<String,String>  pMap){
		return boardDao.boardList(pMap);
	}
	
	public void boardWrite(Map<String,String>  pMap) {
		 boardDao.boardWrite(pMap);
	}
	
	public Map<String, String> boardDetail(Map<String,String>  pMap) {
		 return boardDao.boardDetail(pMap);
	}
	
	public void boardUpdate(Map<String,String>  pMap) {
		 boardDao.boardUpdate(pMap);
	}
	
	public void boardDelete(Map<String,String>  pMap) {
		 boardDao.boardDelete(pMap);
	}
	
	public List<Map<String,String>> codeMasterList(Map<String,String>  pMap) {
		return boardDao.codeMasterList(pMap);
	}
	
	public void codeMasterProcess(List<Object>pList,Map<String,String>  pMap) {
		boardDao.codeMasterProcess(pList,pMap);
	}
	
	public List<Map<String,String>> getMasterMdAmSelectCompanyPop(Map<String,String>  pMap){
		return boardDao.getMasterMdAmSelectCompanyPop(pMap);
	}
	
	public String boardConfirm(Map<String,String>  pMap){
		return boardDao.boardConfirm(pMap);
	};
}
