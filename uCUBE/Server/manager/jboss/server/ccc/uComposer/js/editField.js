/*
  * -------------------------------------------------------------------------
  JIT: Program ID  : TFEnable.js
  JIT: Class Name  :
  JIT: @author     : T.H.KIM
  JIT: @version    : V1.0.0
  JIT: Description : input box 활성화/비활성화
  JIT; Revision History --------------------------------------------------------
  JIT: Version                  Date                 Description
  JIT: 1.0.0                 2002/10/10             initial Release
  * -------------------------------------------------------------------------
*/

var selectAllVar = true;
/*---------------------------------------------------------------------------
description :  전체 선택시 input box 활성화
return      :  none
parameter   :  none
----------------------------------------------------------------------------*/
function js_check_able(frm) 
{
	var objCheck = document.all.check;
	if(objCheck==null) return;
	
	if( objCheck.length == null) {
		abledbox("");
	} else {
		for(idx=0;idx<objCheck.length;idx++) {
			frm.check[idx].checked = selectAllVar==true? true : false;
			abledBoxALL(idx,frm);
		}
	}
	selectAllVar = selectAllVar==true? false : true;

/*		
	alert(frm.check.length);
	if ( frm.check == null ) return;
	
	
	for ( i=0; i < frm.check.length; i++ ) 
	{
		//frm.check[i].checked = frm.ALL.checked ? true : false;
		frm.check[i].checked = selectAllVar==true? true : false;
		abledBoxALL(i,frm);
	}
*/	
}

/*---------------------------------------------------------------------------
description :  전체 선택시 input box 활성화
return      :  none
parameter   :  idx - obj index
               ALL - value of frame 'ALL' obj
----------------------------------------------------------------------------*/
function abledBoxALL(idx,frm) 
{
	Type = new typeDesc();
	
	for( var each_property in Type )
		visiFormALL( idx, Type[each_property], frm );
}

/*---------------------------------------------------------------------------
description :  전체 선택시 input box 활성화
return      :  none
parameter   :  idx - object index
               objname - object name
               ALL - value of 'ALL' object
----------------------------------------------------------------------------*/
function visiFormALL(idx, objname, frm ) 
{
	var obj = "";
	var bool = new Array(6);
	
	//ALL = frm.ALL.checked;
	ALL = selectAllVar;
	
	
	// obj = eval('frm.'+ objname + '[idx]');
	var objCheck = document.all.check;
	if(objCheck==null) return;	
	
	if( objCheck.length == null) {
		obj = eval('frm.'+ objname);
	} else {
		obj = eval('frm.'+ objname + '[idx]');
	}	
	
	bool[0] = ALL;
	bool[1] = ALL == true ? 'block' : 'none';
	bool[2] = ALL == true ? 'none' : 'block';
	bool[3] = ALL == true ? '1' : '0';
	bool[4] = ALL == true ? false : true;
	bool[5] = ALL == true ? 'adb1' : idx%2==0?'tblcw':'tblcg';

	if ( obj.type == 'select-one' ) 
	{
		obj.style.display = bool[1];
		
		// obj = eval('frm._'+ objname + '[idx]');
		if( objCheck.length == null) obj = eval('frm._'+ objname);
		else obj = eval('frm._'+ objname + '[idx]');		
		
		obj.style.display = bool[2];
		obj.disabled = bool[0];
	}
	else {
		obj.style.borderWidth = bool[3];
		obj.readOnly          = bool[4];
		obj.className = bool[5];
	}
}


/*---------------------------------------------------------------------------
description :  행 선택시 input box 활성화
return      :  none
parameter   :  idx - object index
----------------------------------------------------------------------------*/
function abledbox(idx) 
{
	Type = new typeDesc();

	for( var each_property in Type )
	    visiForm( idx, Type[each_property] );
}

/*---------------------------------------------------------------------------
description :  행 선택시 input box 활성화
return      :  none
parameter   :  idx - object index
               objname - object name
----------------------------------------------------------------------------*/
function visiForm(idx, objname ) 
{

	var obj = "";
	var frm = document.forms[0];

	var objCheck = document.all.check;
	if( objCheck.length == null)  obj = eval('frm.'+ objname);
	else  obj = eval('frm.'+ objname + '[idx]');
	
	if ( obj.type == 'select-one' ) 
	{	
		obj.style.display = obj.style.display == 'none' ? 'block' : 'none';
		
		if( objCheck.length == null)  obj = eval('frm._'+ objname);
		else obj = eval('frm._'+ objname + '[idx]');
		
		obj.style.display = obj.style.display == 'none' ? 'block' : 'none';
		obj.disabled = obj.disabled == false ? true : false ;
	}
	else {
		obj.style.borderWidth = obj.readOnly == false ? '0' : '1';
		obj.readOnly          = obj.readOnly == false ? true : false;
		obj.className 		= obj.readOnly == false ? 'adb1' : (idx%2==0?'tblcw':'tblcg');
	}
}
