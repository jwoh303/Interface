package com.koreab2b.mro.search.diquest.catalog;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.diquest.ir.common.msg.protocol.result.GroupResult;
import com.diquest.ir.common.msg.protocol.result.Result;

public class ResultGroup {

	List<Map<String,String>> _groupAList = new ArrayList<Map<String,String>>();  	
	List<Map<String,String>> _groupBList = new ArrayList<Map<String,String>>();  
	
	public ResultGroup(Result pResult){		
		DecimalFormat _formatter = new DecimalFormat("#,###"); 
		GroupResult[] _groupResults = null;
		
		if(pResult.getGroupResultSize() > 0 ){
			for(int j = 0 ;  j < pResult.getGroupResultSize() ; j++ ){
				_groupResults = pResult.getGroupResults();
				for(int k=0 ;  k < _groupResults[j].groupResultSize() ; k++)
				{	
					HashMap<String,String> _groupMap = new HashMap<String,String>(); 
					String _groupId = new String(_groupResults[j].getId(k));
					String _groupIntValue = new String(_formatter.format(_groupResults[j].getIntValue(k)));
					_groupMap.put("groupId", _groupId);
					_groupMap.put("groupIntValue", _groupIntValue);
					
					if(j == 0 ) {
						_groupAList.add(_groupMap);
					}
					else if(j == 1 ){ 
						_groupBList.add(_groupMap);
					}
				}
			}
		}		
	}
	
	public List<Map<String,String>> getGroupAList(){
		return _groupAList;
	}
	
	public List<Map<String,String>> getGroupBList(){
		return _groupBList;
	}
	
}
