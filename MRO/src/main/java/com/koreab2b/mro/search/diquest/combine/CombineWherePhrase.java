package com.koreab2b.mro.search.diquest.combine;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.diquest.ir.client.util.RequestHandler;
import com.diquest.ir.common.msg.protocol.Protocol;
import com.diquest.ir.common.msg.protocol.query.WhereSet;
import com.koreab2b.mro.util.CommonUtil;

public class CombineWherePhrase {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CombineWherePhrase.class);
		
	public WhereSet[] get(RequestHandler pRequestHandler) throws Exception{	
		String searchInResult = pRequestHandler.getParameter("searchInResult", "");
		String st_categ_name = pRequestHandler.getParameter("st_categ_name", "");
		String st_agent_name = pRequestHandler.getParameter("st_agent_name", "");
		String st_buyer_item_no = pRequestHandler.getParameter("st_buyer_item_no", "");
		String st_description = pRequestHandler.getParameter("st_description", "");
		String st_specification = pRequestHandler.getParameter("st_specification", "");
		String st_maker_name = pRequestHandler.getParameter("st_maker_name", "");
		String st_exclude_type = pRequestHandler.getParameter("st_exclude_type", "");
		String st_exclude_string = pRequestHandler.getParameter("st_exclude_string", "");

		String _searchOption = pRequestHandler.getParameter("searchOption", "and");
		byte _whereOption = _searchOption.equals("or") ? Protocol.WhereSet.OP_HASANY : Protocol.WhereSet.OP_HASALL;
		
		List<WhereSet> _whereList = new ArrayList<WhereSet>();
		int index = 0;
		
		if(!st_categ_name.equals("")){
			index++;
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_CATEGORY_TEXT", _whereOption, st_categ_name, 1000));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_CATEGORY_TEXT_LIKE", _whereOption, st_categ_name, 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		}
		
		if(!st_agent_name.equals("")){
			if(index > 0){
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
			}
			index++;
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_AGENT", _whereOption, st_agent_name, 1000));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_AGENT_LIKE", _whereOption, st_agent_name, 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		}
		
		if(!st_buyer_item_no.equals("")){
			if(index > 0){
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
			}
			index++;
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_BUYER_ITEM_NO", _whereOption, st_buyer_item_no, 1000));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_BUYER_ITEM_NO_LIKE", _whereOption, st_buyer_item_no, 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		}
		
		if(!st_description.equals("")){
			if(index > 0){
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
			}
			index++;
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_DESCRIPTION_LOC", _whereOption, st_description, 1000));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_DESCRIPTION_LOC_LIKE", _whereOption, st_description, 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		}
				
		if(!st_specification.equals("")){
			if(index > 0){
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
			}
			index++;
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_SPECIFICATION", _whereOption, st_specification, 1000));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_SPECIFICATION_LIKE", _whereOption, st_specification, 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		}
		
		if(!st_maker_name.equals("")){
			if(index > 0){
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
			}
			index++;
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
			_whereList.add(new WhereSet("IDX_MAKER_NAME", _whereOption, st_maker_name, 1000));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
			_whereList.add(new WhereSet("IDX_MAKER_NAME_LIKE", _whereOption, st_maker_name, 100));
			_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		}
		//대우조선해양 통합카탈로그 검색 안되도록 추가. 
		_whereList.add(new WhereSet(Protocol.WhereSet.OP_NOT));
		_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
		_whereList.add(new WhereSet("IDX_BUYER", _whereOption, "KRDAEW0016", 1000));
		_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		//계약품목만 나오도록 설정.
		_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
		_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));	
		_whereList.add(new WhereSet("IDX_CONTRACT_NO", _whereOption, "PC", 1000));
		_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
		
		if(!st_exclude_string.equals("")){
			String[] arry_exclude_string = CommonUtil.StrToArray(st_exclude_string, ",");
			String typeOfValue = "";
			
			for(int inx = 0 ; inx < arry_exclude_string.length ; inx++){
				if(index > 0){
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_NOT));
				}
				index++;
				
				if(st_exclude_type.equals("DESCRIPTION")){
					typeOfValue = "IDX_DESCRIPTION_LOC";
				} else if(st_exclude_type.equals("AGENT_NAME")){
					typeOfValue = "IDX_AGENT";
				} else if(st_exclude_type.equals("CATEG_NAME")){
					typeOfValue = "IDX_CATEGORY_TEXT";
				} else if(st_exclude_type.equals("MAKER_NAME")){
					typeOfValue = "IDX_MAKER_NAME";
				} else if(st_exclude_type.equals("BUYER_ITEM_NO")){
					typeOfValue = "IDX_BUYER_ITEM_NO";
				} else if(st_exclude_type.equals("SPECIFICATION")){
					typeOfValue = "IDX_SPECIFICATION";
				}
				
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
				_whereList.add(new WhereSet(typeOfValue, _whereOption, arry_exclude_string[inx], 1000));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
				_whereList.add(new WhereSet(typeOfValue + "_LIKE", _whereOption, arry_exclude_string[inx], 100));
				_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
				
			}
		}
		
		if("IN_RESULT".equals(searchInResult)){
			String[] st_categ_name_field = CommonUtil.StrToArray(pRequestHandler.getParameter("st_categ_name_field", ""), "||");
			String[] st_agent_name_field = CommonUtil.StrToArray(pRequestHandler.getParameter("st_agent_name_field", ""), "||");
			String[] st_buyer_item_no_field = CommonUtil.StrToArray(pRequestHandler.getParameter("st_buyer_item_no_field", ""), "||");
			String[] st_description_field = CommonUtil.StrToArray(pRequestHandler.getParameter("st_description_field", ""), "||");
			String[] st_specification_field = CommonUtil.StrToArray(pRequestHandler.getParameter("st_specification_field", ""), "||");
			String[] st_maker_name_field = CommonUtil.StrToArray(pRequestHandler.getParameter("st_maker_name_field", ""), "||");
			String[] st_exclude_type_field = CommonUtil.StrToArray(pRequestHandler.getParameter("st_exclude_type_field", ""), "||");
			String[] st_exclude_string_field = CommonUtil.StrToArray(pRequestHandler.getParameter("st_exclude_string_field", ""), "||");
			
			if(st_categ_name_field != null && st_categ_name_field.length > 0){
				for(int inx = 0 ; inx < st_categ_name_field.length ; inx++){
					if(index > 0){
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
					}
					index++;
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
					_whereList.add(new WhereSet("IDX_CATEGORY_TEXT", _whereOption, st_categ_name_field[inx], 1000));
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
					_whereList.add(new WhereSet("IDX_CATEGORY_TEXT_LIKE", _whereOption, st_categ_name_field[inx], 100));
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
				}
			}
			
			if(st_agent_name_field != null && st_agent_name_field.length > 0){
				for(int inx = 0 ; inx < st_agent_name_field.length ; inx++){
					if(index > 0){
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
					}
					index++;
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
					_whereList.add(new WhereSet("IDX_AGENT", _whereOption, st_agent_name_field[inx], 1000));
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
					_whereList.add(new WhereSet("IDX_AGENT_LIKE", _whereOption, st_agent_name_field[inx], 100));
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
				}
			}
			
			if(st_buyer_item_no_field != null && st_buyer_item_no_field.length > 0){
				for(int inx = 0 ; inx < st_buyer_item_no_field.length ; inx++){
					if(index > 0){
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
					}
					index++;
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
					_whereList.add(new WhereSet("IDX_BUYER_ITEM_NO", _whereOption, st_buyer_item_no_field[inx], 1000));
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
					_whereList.add(new WhereSet("IDX_BUYER_ITEM_NO_LIKE", _whereOption, st_buyer_item_no_field[inx], 100));
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
				}
			}
			
			if(st_description_field != null && st_description_field.length > 0){
				for(int inx = 0 ; inx < st_description_field.length ; inx++){
					if(index > 0){
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
					}
					index++;
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
					_whereList.add(new WhereSet("IDX_DESCRIPTION_LOC", _whereOption, st_description_field[inx], 1000));
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
					_whereList.add(new WhereSet("IDX_DESCRIPTION_LOC_LIKE", _whereOption, st_description_field[inx], 100));
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
				}
			}
			
			if(st_specification_field != null && st_specification_field.length > 0){
				for(int inx = 0 ; inx < st_specification_field.length ; inx++){
					if(index > 0){
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
					}
					index++;
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
					_whereList.add(new WhereSet("IDX_SPECIFICATION", _whereOption, st_specification_field[inx], 1000));
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
					_whereList.add(new WhereSet("IDX_SPECIFICATION_LIKE", _whereOption, st_specification_field[inx], 100));
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
				}
			}
			
			if(st_maker_name_field != null && st_maker_name_field.length > 0){
				for(int inx = 0 ; inx < st_maker_name_field.length ; inx++){
					if(index > 0){
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_AND));
					}
					index++;
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
					_whereList.add(new WhereSet("IDX_MAKER_NAME", _whereOption, st_maker_name_field[inx], 1000));
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
					_whereList.add(new WhereSet("IDX_MAKER_NAME_LIKE", _whereOption, st_maker_name_field[inx], 100));
					_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
				}
			}
			
			if(st_exclude_string_field != null && st_exclude_string_field.length > 0){
				for(int inx = 0 ; inx < st_exclude_string_field.length ; inx++){
					
					String[] arry_exclude_string = CommonUtil.StrToArray(st_exclude_string_field[inx], ",");
					String arry_exclude_type = st_exclude_type_field[inx];
					String typeOfValue = "";
					
					for(int item_inx = 0 ; item_inx < arry_exclude_string.length ; item_inx++){
						if(index > 0){
							_whereList.add(new WhereSet(Protocol.WhereSet.OP_NOT));
						}
						index++;
						
						if(arry_exclude_type.equals("DESCRIPTION")){
							typeOfValue = "IDX_DESCRIPTION_LOC";
						} else if(arry_exclude_type.equals("AGENT_NAME")){
							typeOfValue = "IDX_AGENT";
						} else if(arry_exclude_type.equals("CATEG_NAME")){
							typeOfValue = "IDX_CATEGORY_TEXT";
						} else if(arry_exclude_type.equals("MAKER_NAME")){
							typeOfValue = "IDX_MAKER_NAME";
						} else if(arry_exclude_type.equals("BUYER_ITEM_NO")){
							typeOfValue = "IDX_BUYER_ITEM_NO";
						} else if(arry_exclude_type.equals("SPECIFICATION")){
							typeOfValue = "IDX_SPECIFICATION";
						}
						
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_OPEN));
						_whereList.add(new WhereSet(typeOfValue, _whereOption, arry_exclude_string[item_inx], 1000));
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_OR));
						_whereList.add(new WhereSet(typeOfValue + "_LIKE", _whereOption, arry_exclude_string[item_inx], 100));
						_whereList.add(new WhereSet(Protocol.WhereSet.OP_BRACE_CLOSE));
						
					}
				}
			}
		}
		
		WhereSet[] _whereSet = new WhereSet[_whereList.size()];
		_whereList.toArray(_whereSet);
		return _whereSet;
	}

}
