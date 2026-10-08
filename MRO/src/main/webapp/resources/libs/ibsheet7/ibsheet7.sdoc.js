/**
*
* ibsheetObject object class.
* @id ibsheetObject
* @class ibsheetObject
* @constructor
* @alias ibsheetObject.prototype
* @return {ibsheetObject}
*/
function ibsheetObject(){};



/**
 * SetCellValue : 특정 셀에 값을 설정 한다.
 * @param {Integer} row 해당셀의 Row Index
 * @param {Integer/String} col 해당셀의 Column Index 또는 SaveName
 * @param {Varient} value 셀에 설정할 값
 * @param {Boolean} OnChange event 이벤트 발생여부 (default:1)
 * @example 
 * // 상태셀을 "삭제"상태로 설정<br>
 *	ibsheetObject.SetCellValue(1, 0 "D");
 * 
 */
 ibsheetObject.prototype.SetCellValue = function(row, col, value, evt_flag) {};
 
 /**
  * GetCellValue : 특정 셀에 값을 리턴한다..
  * @param {Integer} row 해당셀의 Row Index
  * @param {Integer/String} col 해당셀의 Column Index 또는 SaveName
  * @example 
  * // 상태셀의 값을 읽어온다.<br>
  * var rowStatus = ibsheetObject.GetCellValue(1, "sStatus");
  */
  ibsheetObject.prototype.GetCellValue = function(row, col) {};

 /**
  * SetActionMenu : Action을 처리하기 위해 사용하는 메뉴를 설정
  * @param {String} text 설정할 팝업메뉴 문자열
  * @param {String} code 설정할 팝업메뉴 코드 문자열 Default="텍스트 문자열"
  * @example
  * // 메뉴와 코드 설정	
  * var Text = "입력|행복사|*-|행삭제|Clear|엑셀다운로드"; <br>
  *	var Code = "Ins|Copy||Del|Clear|Download"; <br>
  *	ibsheetObject.SetActionMenu(Text, Code); <br>
  */
  ibsheetObject.prototype.SetActionMenu = function(text, code){};

  /**
   * GetActionMenu : Action을 처리하기위해 사용하는 메뉴를 확인
   * @returns {String} 설정된 팝업메뉴 
   */
  ibsheetObject.prototype.GetActionMenu = function(){};
  
/**
  * SetAllowCheck : 체크박스의 값 변경을 수용할 지의 여부를 설정
  * @param {Boolean} 값의 변경 수용여부 (default=true)
  * @example
  * // 체크박스의 값을 변경 안함<br>
  * ibsheetObject.SetAllowCheck(false);
  */
  ibsheetObject.prototype.SetAllowCheck = function(Val){};
  
/**
  * GetAllowCheck : 체크박스의 값 변경을 수용할 지의 여부를 확인
  * @returns {Boolean} 설정된 값
  */  
  ibsheetObject.prototype.GetAllowCheck = function(){};
  
/**
  * AllowEvent4CheckAll : 전체선택시 OnChange Event를 실행할지 여부
  * @param {Boolean} OnChange Event 발생여부 (default=1)
  * @example
  * // 전체선택시 이벤트 발생안함<br>
  * ibsheetObject.AllowEvent4CheckAll(0);
  */  
  ibsheetObject.prototype.AllowEvent4CheckAll = function(Val){};

  /**
   * SetAllowExpand : OnBeforeExpand 발생 직후 트리동작을 설정한다. 
   * @param {Boolean} 트리의 펼쳐짐 여부 (0으로 지정시 트리 동작을 막음)
   * @example
   * function ibsheetObject_OnBeforeExpand(Row,Expand) { <br>
   *	if(Row == 1 && Expand == 2) { <br>
   * 		ibsheetObject.SetAllowExpand(0); <br>
   * 		alert("1 행에서는 펼칠 수 있지만 접을 수 없습니다."); <br>
   * 	} <br>
   * } <br>
   */
  ibsheetObject.prototype.SetAllowExpand = function(Expand){};
  
  /**
   * GetAllowExpand : OnBeforeExpand 발생 직후 트리동작을 확인
   * @returns {Boolean} 설정 값
   */
  ibsheetObject.prototype.GetAllowExpand = function(){};
  
  /**
   * SetAutoRowHeight : 데이터 행의 높이를 자동으로 조정할지 여부 설정
   * @param {Boolean} 데이터행의 높이 자동조정 여부 (default=1)
   * @example
   * // 높이를 자동으로 조정하지 않고, 한줄 높이로 고정한다.<br>
   * ibsheetObject.SetAutoRowHeight(0);
   */  
  ibsheetObject.prototype.SetAutoRowHeight = function(Flag){};
  
  /**
   * GetAutoRowHeight : 데이터 행의 높이를 자동으로 조정할지 여부 확인
   * @example
   * // 설정값 확인<br>
   * ibsheetObject.GetAutoRowHeight();
   * @returns {Boolean} 설정 값
   */
  ibsheetObject.prototype.GetAutoRowHeight = function(){};

  /**
   * SetAutoSumPosition : 전체 합계/평균의 표시 위치를 설정
   * @param {Integer}<br> 
   * 0 해더 바로 아래인 최상단에 고정하여 표시<br>
   * 1 화면에 보이는 영역의 최하단에 고정되어 표시
   * @example
   * // 합계 행을 상단에 표시<br>
   * ibsheetObject.SetAutoSumPosition(0);
   */
  ibsheetObject.prototype.SetAutoSumPosition = function(Position){};

  /**
   * GetAutoSumPosition : 전체 합계/평균의 표시 위치를 확인
   * @example
   * // 설정값 확인<br>
   * ibsheetObject.GetAutoRowHeight();
   * @returns {Integer} 설정 값
   */
  
  ibsheetObject.prototype.GetAutoSumPosition = function(){};

  /**
   * SetBasicImeMode : Edit 셀에 포커스시 키보드 상태설정
   * @param {Integer}<br> 
   * 0 마지막상태
   * 1 한글
   * 2 영문
   * @example
   * // 기본 한글 입력 키보드 상태 사용<br>
   * ibsheetObject.SetBasicImeMode(1);
   */  
  ibsheetObject.prototype.SetBasicImeMode = function(Val){};

  /**
   * GetBasicImeMode : Edit 셀에 포커스시 키보드 상태확인
   * @returns {Integer} 설정 값
   */    
  ibsheetObject.prototype.GetBasicImeMode = function(){};
  
  /**
   * SetCellAlign : 셀에 대한 정렬을 설정
   * @param {Integer} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {String} 정렬 값 (Left,Center,Right)
   * @example
   * // 해당 셀을 가운데 정렬로 변경한다.<br>
   * ibsheetObject.SetCellAlign(1, 1, "Center");
   */  
  ibsheetObject.prototype.SetCellAlign = function(Row, Col, Align){};

  /**
   * GetCellAlign :셀에 대한 정렬을 확인
   * @param {Long}
   * @param {Long/String}
   * @example
   * //	해당 셀의 정렬 값을 확인한다.<br>
   * var align = ibsheetObject.GetCellAlign(1, 1);<br>
   * alert("셀의 정렬 값은 " + align + "입니다.");
   * @returns {String} 현재 정렬 값
   */    
  ibsheetObject.prototype.GetCellAlign = function(Row, Col){};  
  
  /**
   * SetCellBackColor : 셀의 배경색을 설정한다.
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {String} 색상 값 (WebColor 또는 Basic 16 Color)
   * @example
   * // 헤더행의 첫번째 셀의 배경색을 빨간색으로 변경<br>
   * ibsheetObject.SetCellBackColor(0, 0, "#FF0000");
   */  
  ibsheetObject.prototype.SetCellBackColor = function(Row, Col, Color){};

  /**
   * GetCellBackColor : 셀의 배경색을 확인한다
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @example
   * //	설정된 색상 값을 확인한다.<br>
   * var color = ibsheetObject.GetCellBackColor(1,1);<br>
   * alert("셀의 색상 값은 " + color + "입니다.");
   * @returns {String} 설정된 색상 값
   */    
  ibsheetObject.prototype.GetCellBackColor = function(Row, Col){};  
    
  /**
   * CellComboItem : 특정 셀의 Combo 항목을 개별 설정한다.
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {Object} 구분자 "|"로 연결된 문자열을 만들어 ComboCode와 ComboText로 값을 설정
   * @example
   * // 특정 셀의 콤보 항목 바꾸기<br>
   * var info = {"ComboCode":"사장|과장|대리","ComboText":"A|B|C"};
   * ibsheetObject.CellComboItem(1,2,info);
   */  
  ibsheetObject.prototype.CellComboItem = function(Row, Col, info){};
 
  /**
   * SetCellEditable : 셀의 Edit 가능 여부를 설정한다.<br>
   * Edit 불가(자동계산,DelCheck체크행,데이터타입:Status, Image, Seq, DataSeq)
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {Boolean} 편집가능여부 (1:가능 0:불가)
   * @example
   * // 1행 3컬럼을 Edit 가능으로 변경<br>
   * ibsheetObject.SetCellEditable(1, 3, 1);
   */  
  ibsheetObject.prototype.SetCellEditable = function(Row, Col, Edit){};

  /**
   * GetCellEditable : 셀의 Edit 가능 여부를 확인한다.
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @example
   * // 1행 2컬럼이 Edit 가능인지 확인<br>
   * if(ibsheetObject.GetCellEditable(1, 2) == 1){}
   * @returns {Boolean} 편집 설정 값
   */  
  ibsheetObject.prototype.GetCellEditable = function(Row, Col, Edit){};

  /**
   * SetCellFont : 특정 셀 또는 영역의 글꼴,크기,글자색,기울임,볼드,밑줄 등을 설정한다.<br>
   * (name,size,color,bold,underline)
   * @param {String} 폰트속성
   * @param {Long} 영역시작 셀의 Row Index
   * @param {Long/String} 영역시작 셀의 Column Index 또는 SaveName
   * @param {Long} 영역마지막 셀의 Row Index
   * @param {Long/String} 영역마지막 셀의 Column Index 또는 SaveName
   * @param {Boolean/String} 폰트속성에 설정한값
   * @example
   * // 영역에 글자 Bold 설정<br>
   * ibsheetObject.SetCellFont("FontBold", 1,1,2,3,1) ;
   */  
  ibsheetObject.prototype.SetCellFont = function(Flag, Row1, Col1, Row2, Col2, Value){};

  /**
   * GetCellFont : 특정 셀 또는 영역의 글꼴,크기,글자색,기울임,볼드,밑줄 등을 확인한다.<br>
   * @param {String} 폰트속성
   * @param {Long} 영역시작 셀의 Row Index
   * @param {Long/String} 영역시작 셀의 Column Index 또는 SaveName
   * @param {Long} 영역마지막 셀의 Row Index
   * @param {Long/String} 영역마지막 셀의 Column Index 또는 SaveName
   * @example
   * // 글자크기가 10보다 큰 경우 9사이즈로 변경한다.<br>
   * if (ibsheetObject.GetCellFont("FontSize", 2,1,2,1) >= 10) { <br>
   * ibsheetObject.SetCellFont("FontSize", 2,1,2,1,9)); <br>
   * }
   * @returns {Boolean/String} 설정한 속성 값
   */  
  ibsheetObject.prototype.GetCellFont = function(Flag, Row1, Col1, Row2, Col2){};

  /**
   * SetCellFontBold : 특정 셀의 글자 Bold 여부를 설정한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {Boolean} Bold 여부
   * @example
   * // 특정 셀에 글자를 Bold 처리한다.<br>
   * ibsheetObject.SetCellFontBold(1,1,1) ;
   */
  ibsheetObject.prototype.SetCellFontBold = function(Row, Col, Bold){};
  
  /**
   * GetCellFontBold : 특정 셀의 글자 Bold 여부를 확인한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @example
   * // 특정 셀의 Bold 처리 여부를 확인한다.<br>
   * ibsheetObject.GetCellFontBold1,1) ;
   * @returns {Boolean} 설정 값
   */  
  ibsheetObject.prototype.GetCellFontBold = function(Row, Col){};
  
  /**
   * SetCellFontColor : 특정 셀의 글자 색을 설정한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {String} 색상 값
   * @example
   * // 1행2컬럼에 색상을 빨강으로 변경
   * ibsheetObject.SetCellFontColor(1,2,"#FF0000");
   */
  ibsheetObject.prototype.SetCellFontColor = function(Row, Col, Color){};
  
  /**
   * GetCellFontColor :특정 셀의 글자 색을 확인한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @example
   * // 금액이 0보다 작으면 숫자는 붉은색으로 표시한다.<br>
   * if(ibsheetObject.GetCellValue(1, 2) < 0 ) { <br>
   * ibsheetObject.SetCellFontColor(1,2,"#FF0000") ; <br>
   * } 
   * @returns {String} 설정된 색상 값
   */
  ibsheetObject.prototype.GetCellFontColor = function(Row, Col){};
  
  /**
   * SetCellFontItalic : 특정 셀에 글자를 이탤릭체로 설정한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {Boolean} 이탤릭 여부 (1:설정, 0:취소) 
   * @example
   * // 특정 셀에 글자를 이탤릭체로 설정한다.
   * ibsheetObject.SetCellFontItalic(1,1,1)
   */
  ibsheetObject.prototype.SetCellFontItalic = function(Row, Col, Italic){};

  /**
   * SetCellFontColor : 특정 셀에 글자를 이탤릭체인지 확인한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @example
   * // 특정 셀의 이탤릭체 여부를 확인한다.
   * ibsheetObject.GetCellFontItalic(1,1);
   */
  ibsheetObject.prototype.GetCellFontItalic = function(Row, Col){};

  /**
   * SetCellFontName : 특정 셀에 대해 글자체를 설정한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {String} 글자체 
   * @example
   * // 글자체를 궁서체로 바꾼다.
   * ibsheetObject.SetCellFontName(1, 1, "Gungsuh");
   */  
  ibsheetObject.prototype.SetCellFontName = function(Row, Col, FontName){};
  
  /**
   * GetCellFontName : 특정 셀에 대해 글자체를 확인한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @example
   * // 글자체를 확인한다
   * alert(ibsheetObject.GetCellFontName(1, 1));
   * @returns {String} 설정 값
   */  
  ibsheetObject.prototype.GetCellFontName = function(Row, Col){};  

  /**
   * SetCellFontSize : 특정 셀에 대해 글자 크기를 설정한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {Integer} 설정하고자 하는 글자크기 
   * @example
   * // 글자크기를 20px로 바꾼다.
   * ibsheetObject.SetCellFontSize(1, 1, 20)
   */  
  ibsheetObject.prototype.SetCellFontSize = function(Row, Col, FontSize){};
  
  /**
   * GetCellFontSize : 특정 셀에 대해 글자 크기를 확인한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @example
   * // 셀의 글자 크기를 확인한다.
   * alert(ibsheetObject.GetCellFontSize(1,1));
   * @returns {Integer} 설정 값
   */  
  ibsheetObject.prototype.GetCellFontSize = function(Row, Col){};
  
  /**
   * SetCellFontUnderline : 셀의 글자의 밑줄을 설정한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {Boolean} 밑줄 여부 
   * @example
   * // 1행 2열 셀의 밑줄표시
   * ibsheetObject.SetCellFontUnderline(1, 2, 1);
   */  
  ibsheetObject.prototype.SetCellFontUnderline = function(Row, Col, Underline){};
  
  /**
   * GetCellFontUnderline : 셀의 글자의 밑줄을 확인한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @returns {Boolean} 설정 값
   */  
  ibsheetObject.prototype.GetCellFontUnderline = function(Row, Col){};
  
  /**
   * SetCellImage : Type이 Image이거나 Image 속성을 사용한 경우 해당 셀의 이미지를 설정한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {String} 실제 이미지 경로
   * @example
   * // 1컬럼의 SaveName이 "btnAction"인 경우
   * ibsheetObject.SetCellImage(1 ,"btnAction", "../image/myImage1.jpg");
   */  
  ibsheetObject.prototype.SetCellImage = function(Row, Col, image){};
  
  /**
   * GetCellImage : Type이 Image이거나 Image 속성을 사용한 경우 해당 셀의 이미지를 확인한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @returns {String} 설정된 이미지 경로
   */  
  ibsheetObject.prototype.GetCellImage = function(Row, Col){};
  
  /**
   * CellSearchValue : 셀이 조회되었던 당시의 값을 확인한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @example
   * //조회되었던 셀 값을 확인한다.
   * ibsheetObject.CellSearchValue(Row, Col);
   * @returns {String} 조회당시 셀 값
   */  
  ibsheetObject.prototype.CellSearchValue = function(Row, Col){};
  
  /**
   * SetCellText : 셀의 값을 Format이 적용된 형태로 화면에 보여지는 값 그대로 설정한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {String} 셀에 설정할 값
   * @example
   * // 날짜 셀에 값 설정
   * ibsheetObject.SetCellText(1, 1, "2011/07/15");
   */  
  ibsheetObject.prototype.SetCellText = function(Row, Col, Text){};
  
  /**
   * GetCellText : 셀의 값을 Format이 적용된 형태로 화면에 보여지는 값 그대로 확인한다.<br>
   * @param {Long} 해당 셀의 Row Index
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @example
   * // 1행 1열 셀 확인
   * alert(ibsheetObject.GetCellText(1,1));
   * @returns {String} 셀에 설정된 값
   */  
  ibsheetObject.prototype.GetCellText = function(Row, Col){};

  /**
   * CheckAll : 컬럼 전체 Check하거나 UnCheck 처리한다.<br>
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {Integer} 0 : 전체체크해제, 1 : 전체체크, 그외 : 이전값 반대
   * @param {Boolean} OnChange 이벤트 발생 여부 Default=1
   * @example
   * //모두체크하기
   * ibsheetObject.CheckAll(1, 1);
   */  
  ibsheetObject.prototype.CheckAll = function(Col, Value, evt_flag){};

  /**
   * CheckedRows : 해당 컬럼에 존재하는 체크박스 중 체크된 행의 개수를 반환한다.<br>
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @example
   * var RowCnt1 = ibsheetObject.CheckedRows(1);
   * alert("체크된 행의 개수는 " + RowCnt1 + "개 입니다.");
   * @returns {Long} 특정 컬럼에 체크된 행의 개수
   */  
  ibsheetObject.prototype.CheckedRows = function(Col){};

  /**
   * CheckReverse : 특정 컬럼에 체크를 반전한다.<br>
   * @param {Long/String} 해당 셀의 Column Index 또는 SaveName
   * @param {Boolean} 편집가능 불가능을 확인하여 편집가능일때만 변경한다. Default=0
   * @param {Boolean} 체크가 바뀔때 OnChange 이벤트를 발생할것인가 여부, Default=0
   * @example
   * // 1컬럼의 체크를 반전한다.
   * ibsheetObject.CheckReverse(1);
   * @returns {Long} 특정 컬럼에 체크된 행의 개수
   */  
  ibsheetObject.prototype.CheckReverse = function(Col, Editable, Event){};  

  /**
   * ClearHeaderCheck : 헤더의 모든 전체체크박스의 값을 언체크로 초기화 한다.<br>
   * @example
   * // RemoveAll 호출전에 전체체크박스를 초기화 한다.<br>
   * ibsheetObject.ClearHeaderCheck();<br>
   * ibsheetObject.RemoveAll();
   */  
  ibsheetObject.prototype.ClearHeaderCheck = function(){};  

  /**
   * SetClipCopyMode :  포커스 셀 복사(default:0), 포커스 행 복사(1)<br>
   * @param {Integer} 복사 방법에 따른 설정값
   * @example
   * // 포커스셀 값이나 선택셀 값 모두 복사<br>
   * ibsheetObject.SetClipCopyMode(0);<br>
   */  
  ibsheetObject.prototype.SetClipCopyMode = function(Mode){};
  
  /**
   * GetClipCopyMode : Ctrl + C 키보드를 사용하여 ClipBoard에 복사하는 방식을 확인한다.<br>
   * @returns {Integer} 설정 값
   */  
  ibsheetObject.prototype.GetClipCopyMode = function(){};
  
  /**
   * SetClipPasteMode :  복사된 내용을 붙여넣을 때 처리 방식을 설정<br>
   * @param {Integer} 복사 방법에 따른 설정값 <br>
   * (-1:사용안함, 0:1개셀, 1:여러셀, 2:여러셀및행추가, 3:행추가) <br>
   * @example
   * // 1개 셀에 붙이기 모드 <br>
   * ibsheetObject.SetClipPasteMode(0); <br>
   * // 여러개 셀에 붙이기 모드 <br>
   * ibsheetObject.SetClipPasteMode(1); <br>
   */  
  ibsheetObject.prototype.SetClipPasteMode = function(Mode){};
  
  /**
   * GetClipPasteMode : 복사된 내용을 붙여넣을 때 처리 방식을 확인<br>
   * @returns {Integer} 설정 값
   */  
  ibsheetObject.prototype.GetClipPasteMode = function(){}; 

  /**
   * SetColBackColor :  컬럼 전체의 배경색을 설정<br>
   * @param {Long /String} 특정 컬럼의 Column Index 또는 SaveName
   * @param {Long} WebColor 색상 값
   * @example
   * // 컬럼 배경색을 회색으로 설정한다.<br>
   * ibsheetObject.SetColBackColor(1, "#ADADAD");<br>
   */  
  ibsheetObject.prototype.SetColBackColor = function(Col, Color){};
  
  /**
   * GetColBackColor : 컬럼 전체의 배경색을  확인<br>
   * @param {Long} 특정 컬럼의 Column Index 또는 SaveName
   * @example
   * // 2컬럼 배경색을 확인 
   * ibsheetObject.GetColBackColor(2);
   * @returns {String} 설정된 색상값
   */  
  ibsheetObject.prototype.GetColBackColor = function(Col){};
  
  /**
   * SetColCondProperty : 숫자형 타입에서 특정 컬럼의 각 셀의 데이타값이 조건에 맞을경우 속성을 설정
   * @param {Long /String} 대상이 되는 컬럼 index또는 SaveName
   * @param {String} 설정할 조건 (예:"%d >1000")
   * @param {Object} 설정할 컬럼 속성
   * @example
   * // 컬럼 배경색을 회색으로 설정한다.<br>
   * ibsheetObject.SetColCondProperty(13,"%d>1000",{BackColorT:"#00ff00",<br>
   * FontColorT:"#ffff00", EditT : false, BackColorF : "#0000ff",<br>
   * FontColorF:"#ffffff", EditF : true, CursorT:"Pointer", CursorF:"Default"})<br>
   */  
  ibsheetObject.prototype.SetColCondProperty = function(Col, Cond, Prop){};
  
  /**
   * GetColCondProperty : 숫자형 타입에서 특정 컬럼의 각 셀의 데이타값이 조건에 맞을경우 조건을 확인한다.
   * @param {Long/String} 특정 컬럼의 Column Index 또는 SaveName
   * @example
   * // 설정한 조건을 확인한다.
   * ibsheetObject.GetColCondProperty(13)
   * @returns {String} 설정한 조건
   */  
  ibsheetObject.prototype.GetColCondProperty = function(Col){};
  
  /**
   * SetColEditable : 특정 컬럼의 Edit 가능 여부를 설정한다.<br>
   * @param {Long /String} 특정 컬럼의 Column Index 또는 SaveName
   * @param {Boolean} 특정컬럼의 Edit 가능 여부
   * @example
   * // 5컬럼의 Edit 가능 여부를 불가로 설정한다.<br>
   * ibsheetObject.SetColEditable(5,0);<br>
   */  
  ibsheetObject.prototype.SetColEditable = function(Col, Editable){};
  
  /**
   * GetColEditable : 특정 컬럼의 Edit 가능 여부를 확인한다.<br>
   * @param {Long / String} 특정 컬럼의 Column Index 또는 SaveName
   * @example
   * // 5컬럼의 Edit 가능 여부를 확인한다.
   * 	ibsheetObject.GetColEditable(5);
   * @returns {Boolean} Edit 가능 여부
   */  
  ibsheetObject.prototype.GetColEditable = function(Col){};
  
  /**
   * SetColFontColor : 대상 컬럼 전체의 글자색을 설정한다.<br>
   * @param {Long /String} 특정 컬럼의 Column Index 또는 SaveName
   * @param {String} 색상 값
   * @example
   * // 컬럼 글자색을 회색으로 설정한다.<br>
   * ibsheetObject.SetColFontColor(1, "#FF0000");<br>
   */  
  ibsheetObject.prototype.SetColFontColor = function(Col, Editable){};
  
  /**
   * GetColFontColor : 대상 컬럼 전체의 글자색을 확인한다.<br>
   * @param {Long / String} 특정 컬럼의 Column Index 또는 SaveName
   * @example
   * // 2컬럼의 글자색을 확인한다.<br>
   * alert(ibsheetObject.GetColFontColor(2));
   * @returns {String} 설정된 색상값
   */  
  ibsheetObject.prototype.GetColFontColor = function(Col){};  
 
  /**
   * SetColFontUnderline : 대상 컬럼 전체의 글자 언더라인을 설정한다<br>
   * @param {Long /String} 특정 컬럼의 Column Index 또는 SaveName
   * @param {Boolean} 밑줄 여부
   * @example
   * // 컬럼 전체 글자에 언더라인을 설정한다.<br>
   * ibsheetObject.SetColFontUnderline(1, 1);<br>
   */  
  ibsheetObject.prototype.SetColFontUnderline = function(Col, Underline){};
  
  /**
   * GetColFontUnderline : 대상 컬럼 전체의 글자 언더라인을 확인한다<br>
   * @param {Long / String} 특정 컬럼의 Column Index 또는 SaveName
   * @example
   * // 컬럼 전체 글자에 언더라인 설정여부를 확인한다.<br>
   * alert(ibsheetObject.GetColFontUnderline(1));<br>
   * @returns {Boolean} 밑줄 설정 값
   */  
  ibsheetObject.prototype.GetColFontUnderline = function(Col){};

  /**
   * SetColHidden : 컬럼의 숨김여부를 설정한다.<br>
   * @param {Long /String} 특정 컬럼의 Column Index 또는 SaveName
   * @param {Boolean} 숨김 여부
   * @example
   * // 컬럼 전체 글자에 언더라인을 설정한다.<br>
   * ibsheetObject.SetColHidden(1, 1);<br>
   */  
  ibsheetObject.prototype.SetColHidden = function(Col, Hidden){};
  
  /**
   * GetColHidden : 컬럼의 숨김여부를 확인한다<br>
   * @param {Long / String} 특정 컬럼의 Column Index 또는 SaveName
   * @example
   * // 컬럼 전체 글자에 언더라인 설정여부를 확인한다.<br>
   * alert(ibsheetObject.GetColFontUnderline(1));<br>
   * @returns {Boolean} 숨김 설정 값
   */  
  ibsheetObject.prototype.GetColHidden = function(Col){};

  /**
   * ColLeft : 컬럼의 왼쪽 위치를 확인한다.<br>
   * @param {Long / String} 특정 컬럼의 Column Index 또는 SaveName
   * @example
   * // 컬럼의 왼쪽 위치를 파악한다.<br>
   * var iLeft = ibsheetObject.ColLeft(1);<br>
   * @returns {Long} 특정 컬럼의 왼쪽 위치 값
   */  
  ibsheetObject.prototype.ColLeft = function(Col){};

  /**
   * ColSaveName : 특정 컬럼 saveName을 확인한다.<br>
   * @param {Long} 특정 컬럼의 Column Index
   * @example
   * // 컬럼의 SaveName을 가져온다.<br>
   * var sSaveName = ibsheetObject.ColSaveName(1);<br>
   * @returns {String} 특정컬럼의 SaveName
   */
  ibsheetObject.prototype.ColSaveName = function(Col){};
  
  /**
   * ColumnSort : 단일 또는 다중 컬럼의 데이터를 정렬한다.<br>
   * @param {Long / String} 소트할 컬럼 Index 또는 SaveName을 "|"로 조합한 문자열
   * @param {String} "ASC" 또는 "DESC", Default ="ASC"
   * @param {String} 각 컬럼의 소트 방향을 "|"로 연결한 문자열, Default=""
   * @param {Boolean} Cols파라미터에서 지정된 순서대로 소트할 것인지 선택, Default=0
   * @example
   * // 6컬럼만 내림차순으로 정렬<br>
   * ibsheetObject.ColumnSort("6", "DESC");<br>
   * // 설정된 정렬을 모두 초기화 한다.
   * ibsheetObject.ColumnSort(); 
   * @returns {String} 특정컬럼의 SaveName
   */
  ibsheetObject.prototype.ColumnSort = function(Col, Sort, ColSort,KeepColOrder){};  

  /**
   * ColValueDup : 특정 컬럼 내에 중복된 값이 존재하는지 여부를 확인한다.<br>
   * @param {Long / String} Column Index 또는 SaveName의 조합. "|"로 연결
   * @param {Boolean} 트랜잭션 상태가 삭제인 행을 포함 여부(Default=1)
   * @param {Boolean} 대/ 소문자 구분 설정여부(Default=1)
   * @example
   * // 1컬럼에 중복된 값이 존재하는 행번을 가져옴<br>
   * var Row = ibsheetObject.ColValueDup("1");<br>
   * @returns {Long} 행번호
   */  
  ibsheetObject.prototype.ColValueDup = function(ColStr, IncludeDelRow, Division){};  

  /**
   * ColValueDupRows : 특정 컬럼 내에 중복된 값이 존재하는지 여부를 확인한다.<br>
   * @param {Long / String} Column Index 또는 SaveName의 조합. "|"로 연결
   * @param {Boolean} 트랜잭션 상태가 삭제인 행을 포함 여부(Default=1)
   * @param {Boolean} 중복된 행의 최초의 행을 포함할지 여부(Default=0)
   * @param {Long} 검사 첫행
   * @param {EndRow} 검사 마지막행 
   * @example
   * // 4컬럼,5컬럼 중복검사(삭제행제외, 최초행포함, 1행~50행)<br>
   * var duprows2 = ibsheetObject.ColValueDupRows("4|5",false,true,1,50);<br>
   * @returns {String} ","로 조합한 문자열
   */  
  ibsheetObject.prototype.ColValueDupRows = function(ColStr, IncludeDelRow, 
		  IncludeFirstRow, StartRow, EndRow){};

  /**
   * SetColWidth : 특정 컬럼의 너비를 설정한다.<br>
   * @param {Long / String} 특정 컬럼의 Column Index 또는 SaveName
   * @param {Integer} 너비 픽셀 값(0:해당 컬럼 내의 Text 중 가장 긴 값)
   * @example
   * //50 픽셀로 너비 수정<br>
   * ibsheetObject.SetColWidth(1, 50);<br>
   */  
  ibsheetObject.prototype.SetColWidth = function(Col, Width){};  

  /**
   * GetColWidth : 특정 컬럼의 너비를 확인한다.<br>
   * @param {Long / String} 특정 컬럼의 Column Index 또는 SaveName
   * @example
   * // 1컬럼의 너비값을 확인<br>
   * ibsheetObject.GetColWidth(1);<br>
   * @returns {Integer} 특정컬럼의 너비 픽셀 값
   */  
  ibsheetObject.prototype.GetColWidth = function(Col){};
 
  /**
   * SetComboOpenMode : Combo, ComboEdit 컬럼을 한번 클릭으로 펼쳐줄지에 대해 설정한다.<br>
   * @param {Boolean} 0:포커스만 얻기(Default) 1:한번클릭으로 펼쳐짐
   * @example
   * // 콤보를 한번 클릭으로 연다.<br>
   * ibsheetObject.SetComboOpenMode(1);<br>
   */  
  ibsheetObject.prototype.SetComboOpenMode = function(mode){}; 
  
  /**
   * GetComboOpenMode : Combo, ComboEdit 컬럼을 한번 클릭으로 펼쳐줄지에 대해 확인한다.<br>
   * @param {Long / String} 특정 컬럼의 Column Index 또는 SaveName
   * @example
   * // ComboOpenMode 설정되어 있는 값을 확인한다.<br>
   * ibsheetObject.GetComboOpenMode();<br>
   * @returns {Boolean} 현재 설정 값
   */  
  ibsheetObject.prototype.GetComboOpenMode = function(){};
  
  /**
   * ComputeSum : 특정 영역의 합계를 계산하여 반환한다.<br>
   * @param {String} 계산 공식, 공식에 다른 컬럼값이 사용되는 경우 반드시 "|"로 감싸서 사용한다.
   * @param {Long} 계산 대상행의 시작 index, Default=-1
   * @param {Long} 계산 대상행의 마지막 index, Default=-1
   * @param {Boolean} 0 : 소계행은 계산식에서 제외,  1 : 소계행을 계산식에 포함(Default) 
   * @example
   * // 3컬럼의 합계를 구한다.<br>
   * 	var Sum3 = ibsheetObject.ComputeSum("|3|");<br>
   * // 1행부터 10행까지 3컬럼 * 4컬럼 / 100 한 값들의 합계를 구한다.<br>
   * 	var Sum4 = ibsheetObject.ComputeSum("|3| * |4| / 100", 1, 10);
   */  
  ibsheetObject.prototype.ComputeSum = function(CalcuLogic, FirstRow, LastRow, isFullSum){};

  /**
   * ConfirmOK : OnMessage Event 안에서만 사용하며, 응답 결과를 Sheet로 돌려준다.<br>
   * @param {Boolean} 확인창 표시 여부
   * @example
   * // 메시지 모드를 설정한다.<br>
   * ibsheetObject.ShowMsgMode=0;<br>
   * 
   * // OnMessage 이벤트를 처리한다.<br>
   * Function ibsheetObject_OnMessage(grid,msg, level, isconfirm)
   *
   * //메시지 표시하기
   *	 var win_result = window.showModalDialog(<br>
   *		"sheet_message.jsp?Msg=" + msg + "&IsConfirm=" + isconfirm,<br>
   *		'modalResult',<br>
   *		'dialogWidth:200px;dialogHeight:200px;center:yes;help:no;status:no;');<br>
   *
   * // Sheet로 메시지 결과를 반환한다.<br>
   * 	if(IsConfirm) ibsheetObject.ConfirmOk = win_result;
   */  
  ibsheetObject.prototype.ConfirmOK = function(Val){};
  
  /**
   * SetCountFormat : 보여지는 건수 정보의 포멧을 설정한다.<br>
   * @param {String} 설정할 출력포맷
   * @example
   * // 건수 포멧을 설정한다.<br>
   * ibsheetObject.SetCountFormat("현재 BOTTOMDATA건 / 전체 TOTALROWS건");
   */  
  ibsheetObject.prototype.SetCountFormat = function(Format){};
 
  /**
   * GetCountFormat : 보여지는 건수 정보의 포멧을 설정한다.<br>
   * @example
   * // 건수 포멧을 확인한다.<br>
   * ibsheetObject.GetCountFormat();
   * @returns {String} 설정된 출력 포맷
   */  
  ibsheetObject.prototype.GetCountFormat = function(){};
  
  /**
   * SetCountPosition : 건수 정보를 IBSheet의 특정 영역에 보이도록 설정한다.<br>
   * @param {Integer} 설정할 출력정보 위치 값 
   * 0:표시안함 1:좌측상단 2:우측상단 3:좌측하단 4:우측하단
   * @example
   * // 개수 정보를 좌측 상단에 표시한다.<br>
   * ibsheetObject.SetCountPosition(1);
   */  
  ibsheetObject.prototype.SetCountPosition = function(Position){};
 
  /**
   * GetCountPosition : 건수 정보를 확인한다.<br>
   * @example
   * // 개수 정보가 표시되지 않고 있는지 확인<br>
   * if(ibsheetObject.GetCountPosition() == 0);
   * @returns {Integer} 설정된 출력정보 위치 값
   */  
  ibsheetObject.prototype.GetCountPosition = function(){};  
  
  /** 
   * CreatePivotTable : 데이터의 나열 형태에 따라서 집계나 카운트 등을 계산한다.<br>
   * @param {json} 피벗 테이블에서 사용할 행, 열, 집계 레이블로 json 형태로 설정한다.<br>
   * 속성 : Rows, Cols, Value, ValueType
   * @param {Object} 데이터가 있는 IBSheet의 객체
   * @example
   * //5,6,7 열을 행 레이블에 트리 구조로 표시하고, 8,9,10 열을 열 레이블에 표시하며, 13 컬럼을 합계로 집계한다.
   * ibsheetObject2.CreatePivotTable({Rows:'5|6|7', Cols:'8|9|10', Value:'13', ValueType:'Sum'}, ibsheetObject);
   */  
  ibsheetObject.prototype.CreatePivotTable = function(Info, DataSheet){};
  
  /**
   * SetCumulateBackColor : 누계 행의 배경 색상을 설정한다. (WebColor 값)<br>
   * @param {String} WebColor 값 
   * @param {Object} 데이터가 있는 IBSheet의 객체
   * @example
   * // 누계 행 배경색상을 녹색으로 설정
   * ibsheetObject.SetCumulateBackColor("#00FF00");
   */  
  ibsheetObject.prototype.SetCumulateBackColor = function(Color){};
  
  /**
   * GetCumulateBackColor : 누계 행의 배경 색상을 확인한다.<br>
   * @example
   * // 누계 행 배경색상을 확인
   * ibsheetObject.GetCumulateBackColor();
   * @returns {String} 현재 누계 색상 값 
   */  
  ibsheetObject.prototype.GetCumulateBackColor = function(){};

  /**
   * Data2Clipboard : IBSheet위의 있는 모든 데이터를 클립보드에 복사한다.<br>
   * @example
   * // 클립보드에 복사한다.
   * ibsheetObject.Data2Clipboard();	
   * @returns {String} 클립보드에 복사된 문자열 
   */
  ibsheetObject.Data2Clipboard = function(){};

  /**
   * SetDataAlternateBackColor : 짝수번째 데이터 행의 기본 배경색을 설정한다. (WebColor 값)<br>
   * @param {String} 설정할 색상 값 
   * @example
   * // 짝수행을 빨간색으로 변경
   * ibsheetObject..SetDataAlternateBackColor("#FF0000");
   */  
  ibsheetObject.prototype.SetDataAlternateBackColor = function(Color){};
  
  /**
   * GetDataAlternateBackColor : 짝수번째 데이터 행의 기본 배경색을 확인한다 (WebColor 값)<br>
   * @param {String} WebColor 값 
   * @param {Object} 데이터가 있는 IBSheet의 객체
   * @example
   * // 색상값 확인
   * ibsheetObject.GetDataAlternateBackColor(1,1);
   * @returns {String} 현재 짝수행 색상값 
   */  
  ibsheetObject.prototype.GetDataAlternateBackColor = function(){};
  
  /**
   * SetDataAutoTrim : 조회 또는 저장 시 데이터의 공백 트림 여부를 설정한다. <br>
   * @param {Boolean} 설정할 데이터의 공백Trim값
   * @example
   * // 자동 트림하여 조회하기
   * ibsheetObject.SetDataAutoTrim(1);
   * ibsheetObject.DoSearch("list.jsp");
   */  
  ibsheetObject.prototype.SetDataAutoTrim = function(Trim){};
  
  /**
   * GetDataAutoTrim : 조회 또는 저장 시 데이터의 공백 트림 여부를 확인한다. <br>
   * @param {String} 설정할 색상 값 
   * @example
   * // 자동 트림여부 설정 확인하기
   * ibsheetObject.GetDataAutoTrim();
   * @returns {Boolean} 데이터의 공백Trim 설정값
   */  
  ibsheetObject.prototype.GetDataAutoTrim = function(){};
  
  /**
   * SetDataBackColor : 홀수번째 데이터 행의 기본 배경색을 설정한다. <br>
   * @param {String} 설정할 색상 값
   * @example
   * // 홀수행의 배경색을 흰색으로 설정
   * ibsheetObject.SetDataBackColor("#FFFFFF");
   */  
  ibsheetObject.prototype.SetDataBackColor = function(Color){};
  
  /**
   * GetDataBackColor : 홀수번째 데이터 행의 기본 배경색을 확인한다. <br>
   * @example
   * // 홀수행의 배경색을 확인
   * ibsheetObject.GetDataBackColor();
   * @returns {String} 현재 홀수행 색상값
   */  
  ibsheetObject.prototype.GetDataBackColor = function(){};
		  
  /**
   * DataCopy : 행의 내용을 복사하여 신규 입력 행 생성<br>
   * @param {Boolean} 자식 레벨의 행까지 복사하는지 여부 Default=0
   * @example
   * // 행을 복사하고, 복사된 행의 트랜잭션 상태를 "조회" <br>
   * var Row = ibsheetObject.DataCopy(); <br>
   * ibsheetObject.SetCellValue(Row, "Status", "R");
   * @returns {Long} 복사하여 생성된 행의 Row Index
   */  
  ibsheetObject.prototype.DataCopy = function(IncludeChild){};
  
  /**
   * SetDataFontColor : 모든 데이터 행의 글자색을 설정<br>
   * @param {String} 설정할 색상 값
   * @example
   * // 데이터 행의 글자색을 빨간색으로 설정한다. <br>
   * ibsheetObject.SetDataFontColor("#FF0000");
   */  
  ibsheetObject.prototype.SetDataFontColor = function(Color){};
  
  /**
   * GetDataFontColor : 모든 데이터 행의 글자색을 확인<br>
   * @example
   * // 데이터 행의 글자색을 확인한다. <br>
   * ibsheetObject.GetDataFontColor();
   * @returns {String} 설정된 글자 색상값
   */  
  ibsheetObject.prototype.GetDataFontColor = function(){};
  
  /**
   * DataInsert : 행을 신규 생성, 행의 Row Index를 반환한다. <br>
   * @param {Long} 생성될 행 위치
   * @param {Long} 생성될 행의 트리 레벨 수준
   * @example
   * // 첫 행에 생성하기 <br>
   * ibsheetObject.DataInsert(0); <br>
   * //마지막 행에 생성하기 <br>
   * ibsheetObject.DataInsert(-1); <br>
   * //현재 선택된 행의 바로 아래에 생성 <br>
   * ibsheetObject.DataInsert();
   * @returns {Long} 신규 생성된 행의 Row Index
   */  
  ibsheetObject.prototype.DataInsert = function(Row, Level){}; 
  
  /**
   * SetDataLinkMouse : 데이터 행의 페이지 링크 여부를 설정한다.<br>
   * @param {Long / String} 특정컬럼의 Column Index 또는 SaveName
   * @param {Boolean} 링크여부 설정	
   * @example
   * // 1 컬럼에서만 가능하도록 설정한다. <br>
   * ibsheetObject.SetDataLinkMouse(1, 1);
   */  
  ibsheetObject.prototype.SetDataLinkMouse = function(Col, Link){};
  
  /**
   * GetDataLinkMouse : 데이터 행의 페이지 링크 여부를 확인한다.<br>
   * @example
   * // 데이터행의 페이지 링크 여부 확인한다. <br>
   * ibsheetObject.GetDataLinkMouse(1);
   * @returns {Boolean} 설정된 링크 값
   */  
  ibsheetObject.prototype.GetDataLinkMouse = function(Col){};
  
  /**
   * DataMove : 데이터 행을 다른 위치로 이동한다.<br>
   * @param {Long} 이동할 위치의 Row Index <br>
   * @param {Long} 선택된 데이터의 Row Index,Default=-1
   * @param {Integer} 이동 후 선택된 데이터의 트리 레벨 Default="원래 레벨 수준" <br>
   * @example
   * // 12행을 10행으로 이동한다. <br>
   * ibsheetObject.DataMove(10, 12);
   */  
  ibsheetObject.prototype.DataMove = function(ToRow, FromRow, RowLevel){};
  
  /**
   * SetDataRowHeight : 모든 데이터 행의 행높이를 설정한다.<br>
   * @param {Integer} 설정할 데이터행 높이 값	
   * @example
   * // 행의 높이를 22 픽셀로 설정한다. <br>
   * ibsheetObject.SetDataRowHeight(22);
   */  
  ibsheetObject.prototype.SetDataRowHeight = function(Height){};
  
  /**
   * GetDataRowHeight : 모든 데이터 행의 행높이를 확인한다.<br>
   * @example
   * // 행의 높이를 확인한다. <br>
   * ibsheetObject.GetDataRowHeight();
   * @returns {Integer} 설정된 높이 값
   */  
  ibsheetObject.prototype.GetDataRowHeight = function(){}; 

  /**
   * SetDataRowMerge : 모든 데이터 행의 가로 머지 여부를 설정한다.<br>
   * @param {Boolean} 머지 허용 여부 (Default: 0)
   * @example
   * // 모든 데이터 행의 가로머지를 허용 <br>
   * ibsheetObject.SetDataRowMerge(1);
   */  
  ibsheetObject.prototype.SetDataRowMerge = function(Merge){};
  
  /**
   * GetDataRowMerge : 모든 데이터 행의 가로 머지 여부를 확인한다.<br>
   * @returns {Boolean} 설정된 값
   */  
  ibsheetObject.prototype.GetDataRowMerge = function(){};

  /**
   * DirectDown2Excel : 서버에서 만든 자료를 기준으로 엑셀 파일을 빠르게 구성하여 다운로드 받도록 한다.<br>
   * 1.화면페이지 2.비즈니스로직페이지(DB조회) <br> 
   * 3.데이터 저장 request.setAttribute("SHEETDATA", li); <br>
   * 4.DirectDown2Excel.jsp 페이지로 forwarding 
   * @example
   * var param = { <br>
   * URL:"/bus/bussinessList.jsp" <br>
   * ,ExtendParam:"sa_nm=양진열&sa_no=980123" <br>
   * ,FileName:"PersonList.xls" <br>
   * }; <br>
   * ibsheetObject. DirectDown2Excel(param);
   */  
  ibsheetObject.prototype.DirectDown2Excel = function(parameters){};
  
  /**
   * DirectLoadExcel : 서버에서 만든 자료를 기준으로 엑셀 파일을 빠르게 구성하여 다운로드 받도록 한다.<br>
   * 1.포워딩 페이지 경로설정 2.request.getAttribute("SHEETDATA");
   * 3.화면출력
   * @example
   * function makeExParam(key,data){ <br>
   * return "&"+encodeURIComponent(key)+"="+encodeURIComponent(data);<br>
   * }<br>
   * // 엑셀로 넘어온 내용을 전달할 포워딩 페이지<br>
   * var param =makeExParam( “FP" ,"/bu/MassSave.jsp");<br>
   * param += makeExParam("sname","chris");<br>
   * param += makeExParam("date","20091221”);<br>
   * var parameters = { Mode : mch, StartRow: "1", ExtendParam:param}<br>
   * // 엑셀로 로딩하여 서버에서 즉시 처리하기<br>
   * ibsheetObject. DirectLoadExcel(parameters);
   */  
  ibsheetObject.prototype.DirectLoadExcel = function(parameters){};
  
  /**
   * DoAllSave : 트랜잭션에 상관없이 모든 데이터를 저장한다.<br>
   * @param {String} 저장 처리할 페이지 파일 이름 <br>
   * @param {String} 저장을 위한 Parameter (Default="") <br>
   * @param {Boolean} IBSheet 위의 데이터를 인코딩할지 여부를 설정 (Default=1) <br>
   * @param {Integer} Query String 문자열 조합방법 Mode=1, Mode=2 (Default =1) <br>
   * @param {String} Mode=2일때 연결될 구분자 설정 (Default ="|")
   * @example
   * // 모든 내역 저장하기 <br>
   * ibsheetObject.DoAllSave("save.jsp", "id=khlee&seq=1");
   */  
  ibsheetObject.prototype.DoAllSave = function(PageUrl, Param, UrlEncode, Mode, Delim){};
  
  /**
   * DoPrint : 보여지고 있는 모든 데이터를 인쇄한다.<br>
   * @example
   * // 인쇄하기 <br>
   * ibsheetObject.DoPrint();
   */  
  ibsheetObject.prototype.DoPrint = function(){};  
  
  /**
   * DoRowSearch : 특정 행의 셀 데이터를 조회 한다.<br>
   * @param {Long} 대상 행의 Index <br>
   * @param {String} 처리할 페이지 Url<br>
   * @param {String} 조회조건 Query String (Default "") <br>
   * @param {Boolean} Query String 문자열 조합방법 Mode=1, Mode=2 (Default =1) <br>
   * @param {String} 대기 이미지 표시 여부 (Default =1)
   * @example
   * // 해당행의 데이터를 읽어옴.<br>
   * ibsheetObject.DoRowSearch(Row, "grid_rowdata.html", "" ,0);
   */  
  ibsheetObject.prototype.DoRowSearch = function(Row, PageUrl, Param, WaitImage){};
  
  /**
   * DoSave : 데이터의 트랜잭션 상태 저장 처리한다.<br>
   * @param {String} 저장 처리할 페이지 파일 이름 <br>
   * @param {String} 저장을 위한 Parameter (Default="")<br>
   * @param {Long / String} 저장 대상이 되는 기준 컬럼, 또는 SaveName Default=상태컬럼(-1) <br>
   * @param {Boolean} 확인 메시지 표시 여부 설정 (Default=1) <br>
   * @param {Boolean} 인코딩할지 여부를 설정 (Default=1) <br>
   * @param {Ineteger} 문자열 조합방법 Mode=1, Mode=2 (Default=1) <br>
   * @param {String} Mode=2일때, 연결될 구분자 설정 (Default="|")
   * @example
   * // 2컬럼의 CheckBox가 체크된것만 저장<br>
   * ibsheetObject.DoSave("Save.jsp" ,"id=khlee&seq=1", 2);
   */  
  ibsheetObject.prototype.DoSave = function(PageUrl, Param, Col,
		  Quest, UrlEncode, Mode, Delim){};
  
  /**
   * DoSearch : 조회 페이지를 연결. <br>
   * @param {String} 조회 XML 페이지 파일 이름 <br>
   * @param {String} 조회 조건 Query String (Default="") <br>
   * @param {Boolean} 동기 조회 여부 (Default=0) <br>
   * @example
   * // 데이터 비동기 조회 <br>
   * ibsheetObject.DoSearch("list.jsp", "id=khlee&seq=1");
   */  
  ibsheetObject.prototype.DoSearch = function(PageUrl, Param, Syn){};
  
  /**
   * DoSearchChild : 트리형태에서 부모컬럼을 넘겨 자식데이터조회 <br>
   * @param {Long} OnTreeChild 이벤트에서 받은 행의 Index <br>
   * @param {String} 조회 XML,JSON 페이지 파일 이름 <br>
   * @param {String} 조회 조건 Query String (Default="") <br>
   * @param {Boolean} 대기 이미지 표시 여부 (Default=1) <br>
   * @example
   */  
  ibsheetObject.prototype.DoSearchChild = function(Row, PageUrl, Param, Wait){};
  
  /**
   * DoSearchFx : 조회 메서드인 DoSearch와 동일한 기능(포멧에 따른 검사를 생략) <br>
   * @param {String} 조회 XML 페이지 파일 이름<br>
   * @param {String} 조회 조건 Query String (Default="") <br>
   * @example
   * // 데이터 조회하기<br>
   * DoSearchFx("list.jsp", "id=khlee&seq=1" );
   */  
  ibsheetObject.prototype.DoSearchFx = function(PageUrl, Param){};
  
  /**
   * DoSearchPaging : 대량 데이터를 조회, IBSheet 의 스크를 위치의 데이터 일부만을 조회 하여 화면에 표현한다. <br>
   * @param {String} 조회 페이지 Url <br>
   * @param {String} 페이지 인덱스를 받을 변수명 (Default="ibpage") <br>
   * @param {String} 조회 조건 Query String (Default="") <br>
   * @param {String} 헤더 정렬 정보를 받을 변수명 (Default="iborderby") <br>
   * @example
   * // 데이터 조회하기<br>
   *  DoSearchFx("list.jsp", "id=khlee&seq=1" );
   */  
  ibsheetObject.prototype.DoSearchPaging = function(Url, Info){};  
  
  /**
   * DoSearchScript : 자바 스크립트 변수에 설정된 값을 화면에 표현한다. <br>
   * @param {String} 스크립트 변수명 (반드시 전역변수로)<br> 
   * @example
   * // 전역변수 설정 <br>
   * var gJson = ""; <br>
   * // 변수를 이용한 조회 <br>
   * gJson = "{data:[{C1: '01', C2:1234},{C1: '02', C2:5678}]}"; <br>
   * ibsheetObject.DoSearchScript("gJson"); <br>
   */  
  ibsheetObject.prototype.DoSearchScript = function(Name){};
//아직안함
  
  /**
   * Down2Excel : 조회된 데이터가 있는 경우 IBSheet의 내용을 엑셀 파일로 변환하여 다운로드 한다. <br>
   * 확장자는 반드시 xls, 현재 xlsx는 지원안함 <br>
   * @example
   * // 엑셀로 내려 받기 <br>
   * ibsheetObject.Down2Excel(); <br>
   * // 다운로드할 파일명을 excel2로 하고 워크시트명은 sheet-test 로 정의하여다운로드 받는다. <br>
   * ibsheetObject.Down2Excel({FileName:'excel2',SheetName:' sheet-test'}); <br>
   */  
  ibsheetObject.prototype.Down2Excel = function(parameters){};

  /**
   * SetDown2ExcelUrl : 엑셀 다운로드 기능을 처리할 서버 페이지 경로를 설정한다. <br>
   * @param {String} 설정할 서버 페이지 Url <br>
   * @example
   * // 엑셀 다운로드 경로를 설정한다. <br>
   * ibsheetObject.SetDown2ExcelUrl("/jsp/Down2Excel.jsp");
   */  
  ibsheetObject.prototype.SetDown2ExcelUrl = function(Url){}; 
  
  /**
   * GetDown2ExcelUrl : 엑셀 다운로드 기능을 처리할 서버 페이지 경로를 확인한다. <br>
   * @example
   * // 엑셀 다운로드 설정 경로를 확인한다.<br>
   * var url = ibsheetObject.GetDown2ExcelUrl();
   * @returns {String} 설정된 경로값
   */  
  ibsheetObject.prototype.GetDown2ExcelUrl = function(){}; 
  
  /**
   * Down2ExcelBuffer : 여러 개의 시트로부터 1개의 엑셀 문서로 다운로드 받는다. <br>
   * @param {Bool} 버퍼링여부
   * @example
   * // 1개의 시트를 엑셀문서에 즉시 다운로드 받는다. <br>
   * ibsheetObject.Down2Excel({FileName:'excel2',SheetName:' sheet-test'}); <br>
   * //이후로는 버퍼링한다. 아무 동작 안함. <br>
   * ibsheetObject.Down2ExcelBuffer(true); <br>
   * // 첫번째 워크시트에 담아두기를 예약함. <br>
   * ibsheetObject.Down2Excel({FileName:'excel2',SheetName:'sheet1'}); <br>
   * // 버퍼링된 모든 엑셀 자료를 1개의 엑셀문서에 모두 모아서 즉시 다운로드 한다. <br>
   * ibsheetObject.Down2ExcelBuffer(false); 
   * @returns {String} 설정된 경로값
   */  
  ibsheetObject.prototype.Down2ExcelBuffer = function(IsBuffer){};
  
  /**
   * Down2Text : 조회된 데이터가 있는 경우 IBSheet의 내용을 텍스트 파일로 변환하여 다운로드 한다. <br>
   * @example
   * // 텍스트 파일로 내려 받기 <br>
   * ibsheetObject.Down2Text(); <br>
   * // 다운로드할 파일명을 text로 정의하여다운로드 받는다. <br>
   * ibsheetObject.Down2Text({FileName:'text' }); <br>
   * // 콤보는 코드로 받고, 헤더와 합계는 제외하고 컬럼은 왼쪽에서 3개의 컬럼만 다운로드 한다. <br>
   * ibsheetObject.Down2Text({DownCombo:'CODE', DownRows:'',
   * DownCols:'0|1|2', DownHeader:0, DownSum:0});
   */  
  ibsheetObject.prototype.Down2Text = function(parameters){};

  /**
   * SetDown2TextUrl : 텍스트 다운로드 기능을 처리할 서버 페이지 경로를 설정한다. <br>
   * @param {String} 설정할 서버 페이지 Url <br>
   * @example
   * // 텍스트 다운로드 경로를 설정한다. <br>
   * ibsheetObject.SetDown2TextUrl("/jsp/Down2Text.jsp");
   */  
  ibsheetObject.prototype.SetDown2TextUrl = function(Url){}; 
  
  /**
   * GetDown2TextUrl : 텍스트 다운로드 기능을 처리할 서버 페이지 경로를 확인한다. <br>
   * @example
   * // 텍스트 다운로드 설정 경로를 확인한다.
   * var url = ibsheetObject.GetDown2TextUrl();<br>
   * @returns {String} 설정된 경로값
   */  
  ibsheetObject.prototype.GetDown2TextUrl = function(){}; 
   
  
  /**
   * SetDownloadingImage : 파일 다운로드 중 대기 이미지 파일의 위치를 설정한다 <br>
   * @param {String} 이미지 URL <br> 
   * @example
   * // 다운로드 중 대기 이미지를 변경한다.<br>
   * ibsheetObject.SetDownloadingImage( "/sheet/imgDownload.gif");<br>
   */  
  ibsheetObject.prototype.SetDownloadingImage = function(URL){};
  
  /**
   * GetDownloadingImage : 파일 다운로드 중 대기 이미지 파일의 위치를 확인한다 <br>
   * @example
   * // 다운로드 중 대기 이미지 경로를 확인한다. <br>
   * ibsheetObject.GetDownloadingImage(); <br>
   * @returns {String} 현재 설정값 <br>
   */  
  ibsheetObject.prototype.GetDownloadingImage = function(){};
  
  /**
   * SetDragMode : 마우스 드래깅시 처리 방법을 설정한다. <br>
   * @param {Boolean} 드래그 처리 설정 값 (Default=0) <br> 
   * @example
   * // DragMode 방식 설정 <br>
   * ibsheetObject.SetDragMode(1); <br>
   */  
  ibsheetObject.prototype.SetDragMode = function(Mode){};
  
  /**
   * GetDragMode : 마우스 드래깅시 처리 방법을 확인 한다. <br>
   * @example
   * // DragMode 설정 값 확인 <br>
   * var mode = ibsheetObject.GetDragMode(); <br>
   * @returns {Boolean} 설정된 값 <br>
   */  
  ibsheetObject.prototype.GetDragMode = function(){};
  
  /**
   * SetEditable : 전체적인 Edit 허용 여부를 설정한다. <br>
   * @param {Boolean} 설정할 편집 여부 값 <br> 
   * @example
   * // 초기 로드 시 전체 적인 Edit 가능 설정 <br>
   * ibsheetObject.SetEditable(1); <br>
   */  
  ibsheetObject.prototype.SetEditable = function(Edit){};
  
  /**
   * GetEditable : 전체적인 Edit 허용 여부를 확인한다. <br>
   * @example
   * // Edit 가능 여부 확인 <br>
   * ibsheetObject.GetEditable(); <br>
   * @returns {Boolean} 설정된 값 <br>
   */  
  ibsheetObject.prototype.GetEditable = function(){};
  
  /**
   * SetEditEnterBehavior : Edit 후 Enter 키를 눌렀을 때 동작을 설정한다. <br>
   * @param {Boolean} Enter key 입력시 설정할 속성 값 (Default="tab") <br>
   * tab, down, newline, none <br>
   * @example
   * // 초기 로드 시 전체 적인 Edit 가능 설정 <br>
   * ibsheetObject.SetEditable(1); <br>
   */  
  ibsheetObject.prototype.SetEditEnterBehavior = function(Mode){};
  
  /**
   * GetEditEnterBehavior : Edit 후 Enter 키를 눌렀을 때 동작을 확인한다 <br>
   * @example
   * // Edit 가능 여부 확인 <br>
   * ibsheetObject.GetEditable(); <br>
   * @returns {Boolean} 설정된 값 <br>
   */  
  ibsheetObject.prototype.GetEditEnterBehavior = function(){};
  
  /**
   * SetEditableColorDiff : 편집이 불가능한 셀을 색상으로<br> 
   * 구분하여 표시할지 여부를 설정한다. <br>
   * @param {Integer} 설정 값 <br> 
   * 0:구분없이 표시 1:css 2:css와 기본배경색의 조합 <br>
   * @example
   * // 편집 불가능한 셀을 구분하지 않음 <br>
   * ibsheetObject.SetEditableColorDiff(0); <br>
   */  
  ibsheetObject.prototype.SetEditableColorDiff = function(Mode){};
  
  /**
   * GetEditableColorDiff : 편집이 불가능한 셀을 색상으로<br>
   *  구분하여 표시할지 여부를 확인한다. <br>   *  
   * @example
   * // 편집 불가능한 셀의 표시방법 확인 <br>
   * ibsheetObject.GetEditableColorDiff(); <br>
   * @returns {Integer} 설정 값 <br>
   */  
  ibsheetObject.prototype.GetEditableColorDiff = function(){};
  
  /**
   * SetEditArrowBehavior : 화살표키(상,하,좌,우)에 대한 셀의 포커스 이동 동작을 설정한다.<br>
   * 0:모두불가 1:상하만 2:좌우만 3:모두가능 
   * @param {Integer} 설정할 동작 값 (Default=1) <br> 
   * @example
   * // 화살표키 모두이동가능 <br>
   * ibsheetObject.SetEditArrowBehavior(3); <br>
   */  
  ibsheetObject.prototype.SetEditArrowBehavior = function(behavior){};
  
  /**
   * GetEditArrowBehavior : 화살표키(상,하,좌,우)에 대한 셀의 포커스 이동 동작을 확인한다.<br>
   * @example
   * // 설정값 확인
   * ibsheetObject.GetEditArrowBehavior(); <br>
   * @returns {Integer} 설정 값 <br>
   */  
  ibsheetObject.prototype.GetEditArrowBehavior = function(){};
  
  /**
   * SetEllipsis : 말줄임 표시 기능을 사용할 것인지 여부를 설정한다. <br>
   * "…"와 같은 말 줄임 표시 <br>
   * @param {Boolean} 사용가능 여부 값 (Default="0") <br> 
   * @example
   * // 말줄임 기능 사용하기 <br>
   * ibsheetObject.SetEllipsis(1); <br>
   */  
  ibsheetObject.prototype.SetEllipsis = function(Flag){};
  
  /**
   * GetEllipsis : 말줄임 표시 기능을 사용할 것인지 여부를 확인한다.<br>
   * @example
   * // 설정값 확인
   * ibsheetObject.GetEllipsis(); 
   * @returns {Integer} 설정 값 <br>
   */  
  ibsheetObject.prototype.GetEllipsis = function(){};
  
  /**
   * SetEnable : User Interface 기능(마우스,키보드) 여부를 설정한다. <br>
   * @param {Boolean} User Interface 사용 가능 여부 <br> 
   * @example
   * // 사용 불가능 상태로 변경한다. <br>
   * ibsheetObject.SetEnable(0); <br>
   */  
  ibsheetObject.prototype.SetEnable = function(Enable){};
  
  /**
   * GetEnable : User Interface 기능(마우스,키보드) 여부를 확인한다. <br>
   * @example
   * //User Interface 사용가능 여부 값을 확인한다.
   * ibsheetObject.GetEnable(); 
   * @returns {Boolean} 사용가능 여부 값 <br>
   */  
  ibsheetObject.prototype.GetEnable = function(){};
  
  /**
   * SetEnterBehavior : 셀에 포커스시 Enter키 속성 설정 <br>
   * @param {String} Enter key 입력시 설정할 속성 값 (Default="edit") <br> 
   * @example
   * // Enter를 누르면 무조건 옆으로 이동하게 한다. <br>
   * ibsheetObject.SetEnterBehavior("tab"); <br>
   */  
  ibsheetObject.prototype.SetEnterBehavior = function(Mode){};
  
  /**
   * GetEnterBehavior : 셀에 포커스시 Enter키 속성 확인 <br>
   * @returns {String} 설정한 속성 값 <br>
   */  
  ibsheetObject.prototype.GetEnterBehavior = function(){};
  
  /**
   * SetEtcData : 데이터 정보 이외의 정보를 설정한다. <br>
   * @param {String} 기타정보 키 이름 <br>
   * @param {String} 기타정보 키 값 <br>  
   * @example
   * // 기타 정보의 값을 변경한다. <br>
   * ibsheetObject.SetEtcData("age", 40); <br>
   */  
  ibsheetObject.prototype.SetEtcData = function(KeyName, Value){};
  
  /**
   * GetEtcData : 데이터 정보 이외의 정보를 확인한다. <br>
   * @param {String} 기타정보 키 이름 <br>
   * @example
   * // XML을 통해서 조회된 기타 정보를 TextBox에 설정한다.<br>
   * document.form1.txtAge.value = ibsheetObject.GetEtcData("age");
   * @returns {String} 키에 설정된 값 <br>
   */  
  ibsheetObject.prototype.GetEtcData = function(KeyName){}; 
  
  /**
   * SetExtendLastCol : 마지막 컬럼의 너비를 전체 너비에 맞게 자동으로 맞출것인지 여부를 설정한다. <br>
   * @param {Boolean} 마지막 컬럼 너비 확장 여부 (Default= 0) <br>
   * @example
   * // 마지막 컬럼을 전체 너비에 맞춘다. <br>
   * ibsheetObject.SetExtendLastCol(1); <br>
   */  
  ibsheetObject.prototype.SetExtendLastCol = function(Extend){};
  
  /**
   * GetExtendLastCol : 마지막 컬럼의 너비를 전체 너비에 맞게 자동으로 맞출것인지 여부를 확인한다. <br>
   * @returns {Boolean} 확장 설정 여부 값 <br>
   */  
  ibsheetObject.prototype.GetExtendLastCol = function(){};
  
  /**
   * FindCheckedRow : 특정 컬럼을 체크된 행번호를 "|"로 연결하여 반환한다. <br>
   * @param {Long / String} 특정 컬럼의 Column Index 또는 SaveName <br> 
   * @example
   * // 체크된 행번호를 가져온다. <br>
   * var sRow = ibsheetObject.FindCheckedRow(2); <br>
   * // 받은 결과를 배열로 생성한다. <br>
   * var arrRow = sRow.split("|");
   * @returns {String} 체크된 행번호를 "|" 연결한 문자열 (Default="")
   */  
  ibsheetObject.prototype.FindCheckedRow = function(Col){};

  /**
   * FindStatusRow : 트랜잭션 상태에 행번호를 ";"로 조합하여 반환한다. <br>
   * @param {String} 찾고자 하는 트랜잭션 상태 코드를 "|"로 연결한 문자열 <br> 
   * @example
   * // 수정, 삭제인 행을 알아오기 <br>
   * var sRow = ibsheetObject.FindStatusRow("U|D"); <br>
   * // 받은 결과를 배열로 생성한다. <br>
   * var arrRow = sRow.split(";"); <br>
   * @returns {String} 행번호를 ";"로 조합한 문자열 (Default="")
   */  
  ibsheetObject.prototype.FindStatusRow = function(sStatus){};
  
  /**
   * FindSubSumRow : 소계의 행 번호를 "|"로 연결하여 문자열로 반환한다. <br>
   * @param {Long/String} 컬럼Index 또는 SaveName. Default=""(전체컬럼) <br> 
   * @example
   * // 표시된 모든 소계의 행 찾기 <br>
   * var sRow = ibsheetObject.FindSubSumRow(); <br>
   * // 1컬럼으로 기준으로 표시된 소계 행 찾기. <br>
   * var sRow = ibsheetObject.FindSubSumRow(1); <br>
   * @returns {String} 소계의 행 번호를 "|"로 연결한 문자열
   */  
  ibsheetObject.prototype.FindSubSumRow = function(StdCol){}; 
  
  /**
   * FindSubSumRow : 합계행의 인덱스를 확인한다. <br>
   * @param {Long/String} 컬럼Index 또는 SaveName. Default=""(전체컬럼) <br> 
   * @example
   * // 합계행의 행 번호를 가져온다. <br>
   * var sumRow = ibsheetObject.FindSumRow(); <br>
   * @returns {Long} 합계행의 인덱스 (Default=-1)
   */  
  ibsheetObject.prototype.FindSubSumRow = function(StdCol){};
  
  /**
   * FindText : 컬럼내에 특정 텍스트를 찾아서 행번호를 반환한다. <br>
   * @param {Long / String} 찾고자 하는 컬럼 Index 또는 SaveName
   * @param {String} 찾을 문자열
   * @param {Long}  시작 행의 Index (Default="첫행")
   * @param {Integer} 글자 동일 종류 (Default=-1)
   * -1:전체 0:앞부분 1:뒤부분 2:가운데
   * @param {Boolean} 대소문자 구분 여부 (Default=1)
   * @example
   * // 2컬럼내에 '한국'으로 시작하는 데이터의 행 위치 찾기<br>
   * var Row1 = ibsheetObject.FindText(2, "한국", 0, 0, 0); <br>
   * @returns {Long} 찾아진 행번호 (Default=-1)
   */  
  ibsheetObject.prototype.FindText = function(Col, SearchText,
		  StartRow, FullMatch, CaseSensitive){};
  
  /**
   * FitColWidth : 모든 컬럼의 Width를 재조정하여 수평 스크롤이 생기지 않도록 한다. <br>
   * @param {Long/String} 각 컬럼의 %단위 너비의 조합 (Default="") <br> 
   * @example
   * // 컬럼들의 너비 재조정  <br>
   * ibsheetObject.FitColWidth(); <br>
   * // % 단위로 재설정하기 <br>
   * ibsheetObject.FitColWidth("10|20|40|30"); <br>
   */  
  ibsheetObject.prototype.FitColWidth = function(Width){};
  
  /**
   * FitSize : 모든 행의 높이와 모든 컬럼의 너비를 재조정한다. <br>
   * @param {Boolean} 행 높이 변경 여부
   * @param {Boolean} 컬럼 너비 변경 여부 
   * @example
   * // 행 높이만 재조정하기  <br>
   * ibsheetObject.FitSize(1, 0); <br>
   * // % 단위로 재설정하기 <br>
   * ibsheetObject.FitSize(1, 1); <br>
   */  
  ibsheetObject.prototype.FitSize = function(RowHeight, ColumnWidth){}; 
  
  /**
   * SetFocusAfterProcess : 조회 완료 후 포커스를 데이터 행으로 설정한다. <br>
   * @param {Boolean} 포커스 설정 여부 (Default=1)
   * @example
   * // 조회 후 포커스를 두지않음  <br>
   * ibsheetObject.SetFocusAfterProcess(0); <br>
   * // % 단위로 재설정하기 <br>
   * ibsheetObject.FitSize(1, 1); <br>
   */  
  ibsheetObject.prototype.SetFocusAfterProcess = function(mode){}; 
  
  /**
   * GetFocusAfterProcess : 조회 완료 후 포커스 여부를 확인한다. <br>
   * @returns {Boolean} 설정 값
   */  
  ibsheetObject.prototype.GetFocusAfterProcess = function(){};
  
  /**
   * SetFocusAfterRowTransaction : 행 추가, 삭제, 이동, 복사 후 포커스를 
   * 이동 할지 여부를 설정 한다. <br>
   * @param {Boolean} 포커스 설정 여부 (Default=1)
   * @example
   * // 포커스 고정  <br>
   * ibsheetObject.SetFocusAfterRowTransaction(0); <br>
   */  
  ibsheetObject.prototype.SetFocusAfterRowTransaction = function(mode){}; 
  
  /**
   * GetFocusAfterRowTransaction : 행 추가, 삭제, 이동, 복사 후 포커스를
   * 이동 할지 여부를 확인한다. <br>
   * @returns {Boolean} 설정 값
   */  
  ibsheetObject.prototype.GetFocusAfterRowTransaction = function(){}; 
   
  /**
   * SetFocusEditMode : 셀의 포커스시 Edit or 포커스 여부 설정 
   * @param {Integer} 포커스 설정 여부 (Default=0)
   * @example
   * // 포커스시 단순 포커스 상태 유지 <br>
   * ibsheetObject.SetFocusEditMode(0); <br>
   */  
  ibsheetObject.prototype.SetFocusEditMode = function(mode){}; 
  
  /**
   * GetFocusEditMode : 셀의 포커스시 Edit 또는 포커스 여부 확인
   * @returns {Integer} 설정 값
   */  
  ibsheetObject.prototype.GetFocusEditMode = function(){};
  
  /**
   * GetCellProperty :  InitColumns 또는 InitCellProperty 에서 설정한 속성의 정보를 확인한다.
   * @param {Long} 특정 셀의 Row Index
   * @param {Long / String} 특정 셀의 컬럼 Index 또는 SaveName
   * @param {String} 확인하고자 하는 속성명
   * @example
   * // 데이터 타입을 읽어옴 <br>
   * var iType = ibsheetObject.GetCellProperty(1, 1, "Type"); <br>
   * @returns {String/ Boolean/ Integer} 설정한 컬럼의 속성값  
   */  
  ibsheetObject.prototype.GetCellProperty = function(Row, Col, PropName){}; 

  /**
   * GetChildNodeCount :  트리구조에서 하위노드의 개수를 확인한다.
   * @param {Long} 특정 행의 Row Index
   * @example
   * // 1번째행의 하위노드 개수 <br>
   * var childCount = ibsheetObject.GetChildNodeCount(1); <br>
   * @returns {Integer} 하위 노드의 개수  
   */  
  ibsheetObject.prototype.GetChildNodeCount = function(Row){}; 
  
  /**
   * GetChildRows :  트리구조에서 특정 행의 자식행들의 Index를 "|"로 조합하여 반환한다.
   * @param {Long} 특정 행의 Row Index <br>
   * @param {Integer} 확인할 자식행의 제한 레벨 (Default=-1, 모든자식) <br>
   * @example
   * // 2번째 행의 자식레벨중 3레벨까지만 확인 <br>
   * var childRows = ibsheetObject.GetChildRows(2, 3); <br>
   * @returns {String} 대상 자식행들의 문자열 조합 
   */  
  ibsheetObject.prototype.GetChildRows = function(Row, MaxLevel){};
  
  /**
   * GetComboInfo :  특정 셀의 콤보 정보를 확인한다.
   * @param {Long} 특정 셀의 Row Index <br>
   * @param {Long / String} 특정 셀의 컬럼 Index 또는 SaveName <br>
   * @param {String} "Text", "Code" 선택
   * @example
   * // 콤보 텍스트를 가져온다. <br>
   * var sText = ibsheetObject.GetComboInfo(0,2, "Text"); <br> 
   * // 각각 배열로 구성한다. <br>
   * var arrText = sText.split("|");
   * @returns {String} 콤보 텍스트 또는 코드
   */  
  ibsheetObject.prototype.GetComboInfo = function(Row,Col,Flag){};
  
  /**
   * GetCurrentPage : 전체데이터를 기준으로 현재 화면 위에 올려진 
   * 부분이 몇번째 페이지인지를 리턴한다.(smGeneral 제외)
   * @example
   * // 현재 페이지 넘버 <br>
   * var pageNum = ibsheetObject.GetCurrentPage(); <br>
   * @returns {Integer} 현재 페이지 번호
   */  
  ibsheetObject.prototype.GetCurrentPage = function(){}; 
  
  /**
   * GetDataRows : 단위 데이터 행의 설정 개수를 확인 한다.
   * 부분이 몇번째 페이지인지를 리턴한다.(smGeneral 제외)
   * @example
   * // 단위데이터행의 개수를 확인한다. <br>
   * var dataRows = ibsheetObject.GetDataRows();. <br>
   * @returns {Integer} 설정 되어 있는 단위 데이터 행의 개수
   */  
  ibsheetObject.prototype.GetDataRows = function(){}; 
  
  /**
   * GetEditText : Edit 중인 글자를 확인한다.
   * @returns {String} 편집중인 글자 (Default="")
   */  
  ibsheetObject.prototype.GetEditText = function(){};
  
  /**
   * GetFilterParam : SearchMode:3 필터링한 것과 같은 데이터를 구하여 시트에서
   * 조회하기 위한 QueryString 문자열을 구해오는 함수이다.
   * @param {Boolean} 전체 필터링 여부 (Default =0)
   * @param {Boolean} UrlEncode 여부 (Default= 1)
   * @example
   * //필터행 전체 컬럼을 Param 형식의 스트링으로 구해오기.
   * var FilterStr = ibsheetObject.GetFilterParam(1);   
   * @returns {String} 조회 조건 Query String
   */  
  ibsheetObject.prototype.GetFilterParam = function(AllFilter, UrlEncode){};
  
  /**
   * GetFirstChildRow : 트리구조에서 특정 행의 첫번째 자식 행의 Index를 확인한다.
   * @param {Long} 대상 행의 Index
   * @example
   * // 2번째 행의 첫번째 자식 행을 확인한다. <br>
   * var firstChild = ibsheetObject.GetFirstChildRow(2);  <br>
   * @returns {Long} 첫번째 자식 행의 Index
   */  
  ibsheetObject.prototype.GetFirstChildRow = function(Row){};   
  
  /**
   * GetGroupCol : 현재 설정되어있는 그룹 기준 컬럼을 SaveName확인한다.
   * @example
   * // 그룹행을 설정한다.
   * ibsheetObject.ShowGroupRow();
   * // 현재 설정되어 있는 그룹 기준 컬럼을 확인한다.
   * var Cols = ibsheetObject.GetGroupCol();	 
   * @returns {String} 현재 설정된 그룹 기준 컬럼 정보
   */  
  ibsheetObject.prototype.GetGroupCol = function(Row){};
  
  /**
   * GetLastChildRow : 트리구조에서 특정 행의 마지막 자식 행의 Index를 확인한다
   * @param {String} 대상 행의 Index <Br>
   * @example
   * // 2번째 행의 마지막 자식 행을 확인한다. <br>
   * var lastChild = ibsheetObject.GetLastChildRow(2);
   */  
  ibsheetObject.prototype.GetLastChildRow = function(Row){};
  
  /**
   * GetMergedEndCell : 전체 머지된 셀중 머지 마지막 셀 리턴
   * @param {String} 대상 행의 Index
   * @param {Long / String} 대상이 되는 컬럼 또는 SaveName
   * @example 
   * var endMergeCell = ibsheetObject.GetMergedEndCell(4,5);
   * @returns {String} Row와 Col 정보를 "Row, Col"형태의 String으로 리턴
   */  
  ibsheetObject.prototype.GetMergedEndCell = function(Row, Col){};
  
  /**
   * GetMergedStartCell : 전체 머지된 셀중 머지 시작 셀 리턴
   * @param {String} 대상 행의 Index
   * @param {Long / String} 대상이 되는 컬럼 또는 SaveName
   * @example 
   * var startMergeCell = ibsheetObject.GetMergedStartCell(4,5);
   * @returns {String} Row와 Col 정보를 "Row, Col"형태의 String으로 리턴
   */  
  ibsheetObject.prototype.GetMergedStartCell = function(Row, Col){};
  
  /**
   * GetNextSiblingRow : 특정 행에서 동일 부모, 동일 레벨상의 다음 행의 Index를 확인
   * @param {Long} 대상 행의 Index
   * @example
   * // 6번째 행의 동일레벨 상의 다음 행을 확인한다. 
   * var next = ibsheetObject.GetNextSiblingRow(6);
   * @returns {Long} 동일 레벨상 다음 행의 Index
   */  
  ibsheetObject.prototype.GetNextSiblingRow = function(Row){};  
  
  /**
   * GetSheetPageLength : SetConfig Page 속성 값을 확인한다.
   * @param {Long} 대상 행의 Index
   * @example
   * // Page속성값을 확인한다.
   * ibsheetObject.GetSheetPageLength();
   * @returns {Integer} Page 속성 값
   */  
  ibsheetObject.prototype.GetSheetPageLength = function(Row){};
  
  /**
   * GetParentRow : 트리구조에서 특정 행의 부모 행의 Index를 확인한다.
   * @param {Long} 대상 행의 Index
   * @example
   * // 5번째 행의 부모행을 확인한다.
   * var parent = ibsheetObject.GetParentRow(5);
   * @returns {Long} 부모 행의 Index
   */  
  ibsheetObject.prototype.GetParentRow = function(Row){};
  
  /**
   * GetPrevSiblingRow : 특정 행에서 동일 부모, 동일 레벨상의 이전 행의 Index를 확인
   * @param {Long} 대상 행의 Index
   * @example
   * // 6번째 행의 동일레벨 상의 이전 행을 확인한다.
   * var previous = ibsheetObject.GetPrevSiblingRow(6);
   * @returns {Long} 이전 행의 Index
   */  
  ibsheetObject.prototype.GetPrevSiblingRow = function(Row){};
  
  /**
   * GetRowJson : 행의 데이터를 각 컬럼의 SaveName을 이용하여 Json 객체로 생성하여 반환한다.
   * @param {Long} 해당 행의 Row Index
   * @example
   * // 1행의 Json 객체를 가져온다. <br>
   * var rowJosn = ibsheetObject.GetRowJson(1);
   * @returns {Object} 해당 행의 데이터 객체
   */  
  ibsheetObject.prototype.GetRowJson = function(Row){};
  
  /**
   * GetSaveData : 저장 처리를 완료한 후 생성된 결과를 문자열로 반환한다.
   * @param {String} 저장 처리할 페이지 URL
   * @param {String} 저장할 Query String, Default=""
   * @param {String} 저장 조건 Query String, Default=""
   * @example
   * // 저장 String 가져오기<br>
   * var SaveStr = ibsheetObject.GetSaveString();
   * @returns {Object} 해당 행의 데이터 객체
   */  
  ibsheetObject.prototype.GetSaveData = function(PageUrl, SaveString, Param){};
  
  /**
   * GetSaveJson : 저장 대상의 데이터를 Json 객체로 반환한다.
   * @param {Boolean} 전체 저장 여부 (Default = 0)
   * @param {Long / String} 대상이 되는 기준 컬럼 또는 SaveName (Default =상태 컬럼)
   * @param {String} 저장 조건 Query String (Default="")
   * @example
   * // 모든 행의 데이터를 객체로 받기 <br>
   * var SaveJson = ibsheetObject.GetSaveJson(1);
   * @returns {Object} 저장할 데이터의 Json 객체
   */  
  ibsheetObject.prototype.GetSaveJson = function(AllSave, Col){};
  
  /**
   * GetSaveString : 저장 시 사용되는 데이터의 Query String을 문자열로 반환한다.
   * @param {Boolean} 전체 저장 여부 (Default=0)
   * @param {Boolean} UrlEncode 여부 (Default=1)
   * @param {Long / String} 대상이 되는 기준 컬럼 또는 SaveName (Default =상태 컬럼)
   * @param {String} 저장시 SaveName 앞에 붙이고자 하는 문자열 (Default="")
   * @param {Integer} Query String 문자열 조합방법을 설정Mode=1, Mode=2 (Default =1)
   * @param {String} Mode=2일때, 연결될 구분자 설정 (Default ="|")
   * @example
   * // DoAllSave 함수 사용과 동일한 저장 String 가져오기
   * var SaveStr = ibsheetObject.GetSaveString(1);
   * //DoSave 함수 사용과 동일한 저장 String 가져오기 (4컬럼 체크된것만)
   * var SaveStr = ibsheetObject.GetSaveString(0, 1, 4);
   * @returns {String} 저장할 Query String
   */  
  ibsheetObject.prototype.GetSaveString = function(AllSave, Col){};

  /** 
   * GetSearchData : 조회 처리를 완료한 후 생성된 조회결과 데이터를 문자열로 반환한다.
   * @param {String} 조회 처리할 페이지 URL
   * @param {String} 조회 조건 Query String, Default=""
   * @example
   * // 조회 데이터 읽어오기 <br>
   * var sXml = ibsheetObject.GetSearchData("list.jsp"); <br>
   * // 조회 결과 내용을 표현하기 <br>
   * ibsheetObject.LoadSearchData(sXml); <br>
   * @returns {String} 조회 데이터의 문자열
   */  
  ibsheetObject.prototype.GetSearchData = function(PageUrl, Param){};
  
  /** 
   * GetSearchData : 조회 처리를 완료한 후 생성된 조회결과 데이터를 문자열로 반환한다.
   * @param {String} 조회 처리할 페이지 URL
   * @param {String} 조회 조건 Query String, Default=""
   * @example
   * // 조회 데이터 읽어오기 <br>
   * var sXml = ibsheetObject.GetSearchData("list.jsp"); <br>
   * // 조회 결과 내용을 표현하기 <br>
   * ibsheetObject.LoadSearchData(sXml); <br>
   * @returns {String} 조회 데이터의 문자열
   */  
  ibsheetObject.prototype.GetSearchData = function(PageUrl, Param){};  
 
  /** 
   * GetSelectionCols : 조회 처리를 완료한 후 생성된 조회결과 데이터를 문자열로 반환한다.
   * @param {String} 조합구분자 (Default="|")
   * @example
   * // "/" 구분자로 연결하여 선택된 행번 가져오기 <br>
   * var sColStr = ibsheetObject.GetSelectionCols("/"); <br>
   * @returns {String} 선택되어있는 행번 조합 문자열
   */  
  ibsheetObject.prototype.GetSelectionCols = function(DeliChar){};
  
  /** 
   * GetSelectionRows : 선택 상태에 있는 행의 번호를 구분자로 구분하여 반환한다.
   * @param {String} 조합구분자 (Default="|")
   * @example
   * // "/" 구분자로 연결하여 선택된 행번 가져오기 <br>
   * var sRowStr = ibsheetObject.GetSelectionRows("/");; <br>
   * @returns {String} 선택되어있는 행번 조합 문자열
   */  
  ibsheetObject.prototype.GetSelectionRows = function(DeliChar){};  

  
  /** 
   * GoToFirstPage : 페이징 모드시 맨 처음 페이지로 이동한다.
   * @example
   * // 페이징 모드 설정
   * var cfg = {SearchMode:1, Page:10}; <br>
   * ibsheetObject.SetConfig(cfg); <br>
   * // 맨 처음 페이지로 이동 <br>
   * ibsheetObject.GoToFirstPage(); <br>
   * @returns {String} 선택되어있는 행번 조합 문자열
   */  
  ibsheetObject.prototype.GoToFirstPage = function(){};  
  
  /** 
   * GoToLastPage : 페이징 모드시 맨 마지막 페이지로 이동한다.
   * @example
   * // 페이징 모드 설정
   * var cfg = {SearchMode:1, Page:10}; <br>
   * ibsheetObject.SetConfig(cfg); <br>
   * // 맨 마지막 페이지로 이동 <br>
   * ibsheetObject.GoToLastPage(); <br>
   * @returns {String} 선택되어있는 행번 조합 문자열
   */  
  ibsheetObject.prototype.GoToLastPage = function(){};
  
  /** 
   * GoToNextPage : 페이징 모드시 다음 페이지로 이동한다.
   * @example
   * // 페이징 모드 설정
   * var cfg = {SearchMode:1, Page:10}; <br>
   * ibsheetObject.SetConfig(cfg); <br>
   * // 다음 페이지로 이동 <br>
   * ibsheetObject.GoToNextPage(); <br>
   * @returns {String} 선택되어있는 행번 조합 문자열
   */  
  ibsheetObject.prototype.GoToNextPage = function(){};
  
  /** 
   * GoToPageNum : 페이징 모드시 다음 페이지로 이동한다.
   * @param {Integer} 이동하고자 하는 Page의 Index 
   * @example
   * // 페이징 모드 설정
   * var cfg = {SearchMode:1, Page:10}; <br>
   * ibsheetObject.SetConfig(cfg); <br>
   * // 5번째 페이지로 이동 <br>
   * ibsheetObject.GoToPageNum(5); <br>
   * @returns {String} 선택되어있는 행번 조합 문자열
   */  
  ibsheetObject.prototype.GoToPageNum = function(index){};
  
  /** 
   * GoToPrevPage : 페이징 모드시 이전 페이지로 이동한다.
   * @example
   * // 페이징 모드 설정
   * var cfg = {SearchMode:1, Page:10}; <br>
   * ibsheetObject.SetConfig(cfg); <br>
   * // 이전 페이지로 이동 <br>
   * ibsheetObject.GoToPrevPage(); <br>
   * @returns {String} 선택되어있는 행번 조합 문자열
   */  
  ibsheetObject.prototype.GoToPrevPage = function(){};
  
  /** 
   * SetHeaderBackColor : 해더 행의 바탕색을 설정한다.
   * @param {String} 헤더행의 배경 색상
   * @example
   * // 해더의 배경색을 빨간색으로 설정한다.
   * ibsheetObject.SetHeaderBackColor("#FF0000"); <br>
   */  
  ibsheetObject.prototype.SetHeaderBackColor = function(Color){};
  
  /** 
   * GetHeaderBackColor : 해더 행의 바탕색을 확인한다.
   * @returns {String} 현재 배경 색상 값
   */  
  ibsheetObject.prototype.GetHeaderBackColor = function(){};
  
  /** 
   * SetHeaderCheck : 헤더의 전체체크박스 값을 설정 한다.
   * @param {Long} 대상 행의 Index
   * @param {Long / String} 대상이 되는 컬럼 또는 SaveName
   * @param {Boolean} 체크박스에 설정하고자 하는 값
   * @example
   * // 헤더의 3번째 컬럼의 전체 체크박스 값을 언체크 한다. <br>
   * ibsheetObject.SetHeaderCheck(0, 3, 0); 
   */  
  ibsheetObject.prototype.SetHeaderCheck = function(Row, Col, Value){};
  
  /** 
   * GetHeaderCheck : 헤더의 전체체크박스 값을 확인한다.
   * @param {Long} 대상 행의 Index
   * @param {Long / String} 대상이 되는 컬럼 또는 SaveName
   * @exmple
   * // 헤더의 3번째 컬럼의 전체 체크박스 값을 확인 한다.<br>
   * var CheckValue = ibsheetObject.GetHeaderCheck(0, 3);
   * @returns {Boolean} 현재 설정 값
   */  
  ibsheetObject.prototype.GetHeaderCheck = function(Row, Col){};  
  
  /** 
   * SetHeaderFontBold : 해더 행의 글자 볼드 여부를 설정한다.
   * @param {Boolean} Header행의 Font Bold 여부
   * @example
   * // 해더의 글자를 Bold로 설정한다.
   * ibsheetObject.SetHeaderFontBold(1); <br>
   */  
  ibsheetObject.prototype.SetHeaderFontBold = function(Bold){};
  
  /** 
   * GetHeaderFontBold : 해더 행의 글자 볼드 여부를 확인한다.
   * @exmple
   * // 헤더의 글자 Bold 설정 확인한다.
   * ibsheetObject.GetHeaderFontBold();
   * @returns {Boolean} 현재 설정 값
   */  
  ibsheetObject.prototype.GetHeaderFontBold = function(){};
  
  /** 
   * SetHeaderFontColor : 해더 행의 글자색을 설정한다.
   * @param {String} 설정하고자 하는 WebColor
   * @example
   * // 해더의 글자색을 검은색으로 설정한다.
   * ibsheetObject.SetHeaderFontColor("#000000"); <br>
   */  
  ibsheetObject.prototype.SetHeaderFontColor = function(){};
  
  /** 
   * GetHeaderFontColor : 해더 행의 글자색을 확인한다.
   * @returns {Boolean} 현재 설정 값
   */  
  ibsheetObject.prototype.GetHeaderFontColor = function(){};
  
  /** 
   * HeaderRows : 해더행의 개수를 확인한다.
   * @returns {Long} 해더행의 개수
   */  
  ibsheetObject.prototype.HeaderRows = function(){};
  
  /** 
   * SetHeaderRowHeight : 해더 행의 행높이를 픽셀 단위 설정한다. 
   * @param {Integer} 설정하고자 하는 픽셀값
   * @example
   * // 헤더 행의 높이를 30 픽셀로 설정.
   * ibsheetObject.SetHeaderRowHeight(30); <br>
   */  
  ibsheetObject.prototype.SetHeaderRowHeight = function(Height){};
  
  /** 
   * GetHeaderRowHeight : 해더 행의 행높이를 확인한다. 
   * @returns {Integer} 현재 설정 값
   */  
  ibsheetObject.prototype.GetHeaderRowHeight = function(){};
  
  /** 
   * HideFilterRow : IBSheet 상단 고정행의 필터행을 삭제한다. 
   * @example
   * // 필터행 삭제하기 <br>
   * ibsheetObject.HideFilterRow(); 
   * @returns {Integer} 현재 설정 값
   */  
  ibsheetObject.prototype.HideFilterRow = function(){};
  
  /** 
   * HideSubSum : 소계기능을 다음 조회에서 더 이상 추가되지 않도록 한다.
   * @param {Long / String} 소계를 표시한 기준 컬럼의
   * 컬럼Index 또는 SaveName. Default=""(전체컬럼)
   * @example
   * // 1컬럼을 중심으로 소계 계산하여 표시하기 <br>
   * var info = {StdCol:1, SumCols:"3|4|5"}; <br>
   * ibsheetObject.ShowSubSum(info); <br>
   * // 표시된 소계 숨기기 <br>
   * ibsheetObject.HideSubSum();  
   */  
  ibsheetObject.prototype.HideSubSum = function(StdCol){};
  
  /** 
   * SetHighlightAfterSort : 소트 후 하이라이트 처리 방법을 설정한다.
   * @param {Integer} Sort 설정방법 (Default=1)
   * @example
   * // 소트 이후 기존에 선택하고 있던 데이터를 찾아감. <br>
   * ibsheetObject.SetHighlightAfterSort(1);
   */  
  ibsheetObject.prototype.SetHighlightAfterSort = function(Sort){};
  
  /** 
   * GetHighlightAfterSort : 소트 후 하이라이트 처리 방법을 확인한다.
   * @returns {Integer} 현재 설정 값
   */  
  ibsheetObject.prototype.GetHighlightAfterSort = function(){};
  
  /** 
   * IBCloseCalendar : 외부의 컨트롤에서 사용한 달력팝업을 닫도록 설정한다.
   * @example
   * // 달력 팝업을 띄운다.
   * ibsheetObject.IBShowCalendar("20121116", {Format:"yyyy/MM/dd", X:300, Y:600});
   * // 띄운 달력 팝업 Dialog를 닫는다.
   * ibsheetObject.IBCloseCalendar();
   * @returns {Integer} 현재 설정 값
   */  
  ibsheetObject.prototype.IBCloseCalendar = function(){};
  
  /** 
   * IBShowCalendar : 달력 팝업을 외부의 컨트롤에서 사용하도록 설정한다.
   * @param {String} 날짜데이터값 (Default=현재날짜)
   * @param {Object} 기능을 json 형태로 설정한다. 
   * @example
   * // 달력 팝업을 띄운다.<br>
   * ibsheetObject.IBShowCalendar("20121116", {Format:"YYYY/MM/dd", X:300, Y:600});
   * @returns {String} 달력 팝업 Dialog에서 선택한 날짜값
   */  
  ibsheetObject.prototype.IBShowCalendar = function(val, obj){};
  
  /** 
   * SetImageList : N번째 이미지 파일의 웹서버 경로를 확인하거나 설정한다.
   * @param {String} Image 인덱스
   * @param {Object} 설정할 Image 경로 
   * @example
   * // 0 인덱스에 이미지경로 설정
   * ibsheetObject.SetImageList(0, "../image/btn_search.gif”);
   * // 0 인덱스에 저장된 이미지 사용(Type:Image)
   * ibsheetObject.SetCellImage(3, 5, 0); 	
   * @returns {String} 달력 팝업 Dialog에서 선택한 날짜값
   */  
  ibsheetObject.prototype.SetImageList = function(Index, Url){};
  
  /** 
   * InitCellProperty :  특정 셀의 속성 정의를 한다.
   * 	(Seq, Status, DelCheck, AutoSum, AutoAvg)불가
   * @param {String} 대상 행의 Index
   * @param {Long / String} 대상이 되는 컬럼 Index 또는 SaveName
   * @param {Object} 셀의 속성 정의 객체
   * @example
   * // Text 컬럼 타입으로 변경
   * var info = {Type: "Text", Align: "Center", Edit: 0}; <br>
   * ibsheetObject.InitCellProperty(2, "sCombo", info);
   */  
  ibsheetObject.prototype.InitCellProperty = function(Row, Col, info){}; 
 
  /** 
   * InitColumns :  각 컬럼의 데이터 타입, 포맷 및 기능들을 설정한다.
   * @param {json} 각 컬럼의 기능을 json 형태로 설정한다.
   * @example
   * // 각 컬럼의 기능을 설정한다.<br>
   * var cols = [ <br>
   * {Type:"Status",Width:60,SaveName:"sStatus",Align:"Center"},<br> 
   * {Type:"DelCheck",Width:60,SaveName:"sDelete",Align:"Center"},<br>
   * ];<br>
   * ibsheetObject.InitColumns(cols);<br>
   */  
  ibsheetObject.prototype.InitColumns = function(cols){};
 
  /** 
   * InitComboNoMatchText : Combo 항목에 없는 항목을 설정하거나
   * 조회 하였을 경우 보여지는 글자를 설정한다.
   * @param {Boolean} 콤보 항목 이외의 글자를 보여줄지 여부를 설정
   * @param {String} 콤보 항목 이외인 경우 표시할 글자 (Default ="")
   * @param {Boolean} 해당 셀에 아이템으로 삽입한다. (Default=0)
   * @example
   * // Combo 항목이 없는 경우 항목 없음 표시하기
   * ibsheetObject.InitComboNoMatchText(1, "항목없음");
   */  
  ibsheetObject.prototype.InitComboNoMatchText = function(Show, ShowText, InsertItem){};
  
  /** 
   * InitHeaders : 헤더에 들어갈 타이틀과 해더기능을 지정한다.
   * @param {json} 헤더 타이틀과 정렬 방식을 json 형태로 설정한다.
   * @param {json} 소팅가능여부와 컬럼이동여부등 헤더의 기능을 설정한다.
   * @example
   * // 2줄 헤더타이틀을 설정한다. <br>
   * var headers = [ <br>
   * {Text:"상태|삭제|직원정보|직원정보|직원정보", Align:" Center"},<br>
   * {Text:"상태|삭제|직원명 |직원번호|입사일", Align:" Center"}<br>
   * ]; <br>
   * var info = {Sort:1, ColMove:1, ColResize:0, HeaderCheck:0};<br>
   * ibsheetObject.InitHeaders(headers,info);
   */  
  ibsheetObject.prototype.InitHeaders = function(Headers, info){};
  
  /** 
   * IsDataModified : 데이터 행의 트랜잭션 여부를 확인한다.
   * @example
   * // 트랜잭션이 발생여부 확인 <br>
   * ibsheetObject.IsDataModified(); <br>	
   * @returns {Boolean} 데이터 행의 트랜잭션 여부 
   */  
  ibsheetObject.prototype.IsDataModified = function(){};  
    
  /** 
   * IsHaveChild : 트리형에서 특정 행에 Child 레벨의 행이 존재하는지 여부를 확인한다.
   * @param {Long} 특정 행의 Row Index
   * @param {Boolean} "삭제" 상태의 행을 포함여부 (Default=0)
   * @example
   * // 4행에 자식레벨이 있는지 확인
   * ibsheetObject.IsHaveChild(4)<br>
   */  
  ibsheetObject.prototype.IsHaveChild = function(Row, IncludeDelRow){};
  
  /** 
   * SetKeyFieldImage : 필수 입력 항목에 대한 이미지 파일의 위치를 설정한다.
   * @param {String} 설정할 Url
   * @example 
   * // 필수 입력 항목 이미지를 변경한다.
   *	ibsheetObject.SetKeyFieldImage = "/sheet/imgKeyField.gif"<br>
   */  
  ibsheetObject.prototype.SetKeyFieldImage = function(imgUrl){};
 
  /** 
   * GetKeyFieldImage : 필수 입력 항목에 대한 이미지 파일의 위치를 확인한다.
   * @returns {String} 설정 값
   */  
  ibsheetObject.prototype.GetKeyFieldImage = function(){};
  
  /** 
   * LastCol : 마지막 컬럼의 index를 반환한다.
   * @example
   * // 마지막 컬럼의 index를 확인한다.<br>
   * ibsheetObject.LastCol();
   * @returns {Long} 마지막 컬럼 인덱스 
   */  
  ibsheetObject.prototype.LastCol = function(){};
  
  /** 
   * LastRow : 마지막 행의 index를 반환한다.
   * @example
   * // 마지막 행의 index를 확인한다.<br>
   * ibsheetObject.LastRow();
   * @returns {Long} 마지막 행의 인덱스 
   */  
  ibsheetObject.prototype.LastRow = function(){};
  
  /** 
   * SetLeftCol : 가장 좌측에 표시되는 컬럼을 설정한다.
   * @param {Long / String} Column Index 또는 SaveName
   * @example
   * // 4컬럼을 수평스크롤 가장 좌측에 보이는 컬럼으로 설정
   * ibsheetObject.SetLeftCol(4);
   */  
  ibsheetObject.prototype.SetLeftCol = function(){};
  
  /** 
   * GetLeftCol : 가장 좌측에 표시되는 컬럼을 확인한다.
   * @example
   * // 4컬럼으로 설정됨을 확인
   * ibsheetObject.GetLeftCol();
   * @returns {Long} 가장좌측 끝 컬럼 인덱스
   */  
  ibsheetObject.prototype.GetLeftCol = function(){};
  
  /** 
   * LoadSaveData : 저장 데이터를 함수의 인자로 전달 받아 결과를 IBSheet 내부에 처리한다.
   * @param {String} 저장XML 또는 저장JSON 문자열
   * @example
   * // 저장 작업 Ajax 처리 <br>
   * var rtnData = ibsheetObject.GetSaveData("Action.do", param); <br>
   * // 저장 결과 표현하기 <br>
   * ibsheetObject.LoadSaveData(rtnData);
   */  
  ibsheetObject.prototype.LoadSaveData = function(Content){};
  
  /** 
   * LoadSearchChildData : 트리구조에서 자식노드 조회 데이터(xml or json)를
   * 함수의 인자로 전달 받아 아이비시트에 로딩한다.
   * @param {Long} 대상 부모의 행 인덱스
   * @param {String / Object} 조회 데이터 문자열 또는 JSON 객체
   * @param {Object} 기능을 json 형태로 설정한다.
   * @example
   * //조회 데이터 읽어오기<br>
   * var Row = ibsheetObject.GetSelectRow();<br>
   * 
   * var Data;<br>
   * Data=ibsheetObject.GetSearchData('list2_Child_Json.jsp',<br>
   * 'ChildLevel='+(parseInt(ibsheetObject.GetRowLevel(Row))+1));<br>
   * 
   * var Opt = {Append: 1, WaitDlg: 1};<br>
   * 
   * //조회 결과 내용을 표현하기<br>
   * ibsheetObject.LoadSearchChildData(Row, Data, Opt);<br>
   */  
  ibsheetObject.prototype.LoadSearchChildData = function(Row, Data, Opt){};
  
  /** 
   * LoadSearchData : 조회 데이터(xml or json)를 함수의 인자로
   * 전달 받아 아이비시트에 로딩한다.
   * @param {String} 조회XML 또는 조회JSON 문자열
   * @param {Object} 기능을 json 형태로 설정한다.
   * @example
   * // 조회 데이터 읽어오기<br>
   * var sXml = ibsheetObject.GetSearchData("list.jsp");<br>
   * // 조회 결과 내용을 표현하기<br>
   * ibsheetObject.LoadSearchData(sXml);
   */  
  ibsheetObject.prototype.LoadSearchData = function(Content){};
  
  /** 
   * LoadSearchDataFx : 이 메서드는 LoadSearchData 메서드와 동일한 기능을 수행한다.
   * 포멧에 대한 유효성체크로직을 수행하지 않음으로 많은 양을 데이터를 로딩하는 경우 속도를 향상
   * @param {String} 조회XML 또는 조회JSON 문자열
   * @param {Object} 기능을 json 형태로 설정한다.
   * @example
   * // 조회 데이터 읽어오기
   * var sXml = ibsheetObject.GetSearchData("list.jsp");
   * // 조회 결과 내용을 표현하기
   * ibsheetObject.LoadSearchDataFx(sXml);
   */  
  ibsheetObject.prototype.LoadSearchDataFx = function(Content){};

  /** 
   * LoadExcel : 엑셀로부터 데이터를 읽어 들여 데이터 영역에 표시한다.
   * @example
   * // 엑셀로 로딩하기 <br>
   * ibsheetObject.LoadExcel();<br>
   * // 헤더타이틀을 서로 비교하여 동일한 컬럼끼리 로딩을 하되 7행부터 9 행까지만 읽어들인다.<br>
   * ibsheetObject.Load Excel({Mode:'HeaderMatch',StartRow:'7',EndRow:'9'});<br>
   * // IBSheet의 첫번째 컬럼에 엑셀의 5번째 컬럼의 값을 로딩하고,<br>
   * IBSheet 의 5번째 컬럼에 엑셀의 1번째 컬럼의 값을 로딩함.<br>
   * ibsheetObject.Load Excel({ColumnMapping:'5|4|3|2|1'});<br>
   */  
  ibsheetObject.prototype.LoadExcel = function(parameters){};  

  /** 
   * SetLoadExcelUrl : 엑셀 업로드 기능을 처리할 서버 페이지 경로를 설정한다.
   * @param {String} 설정할 서버 페이지 Url
   * @example
   * // 엑셀 업로드 경로를 설정한다.
   * ibsheetObject.SetLoadExcelUrl("/jsp/LoadExcel.jsp");
   */  
  ibsheetObject.prototype.SetLoadExcelUrl = function(Url){};
  
  /** 
   * GetLoadExcelUrl : 엑셀 업로드 기능을 처리할 서버 페이지 경로를 확인한다.
   * @example
   * // 엑셀 업로드 설정 경로를 확인한다.
   * var url = ibsheetObject.GetLoadExcelUrl();
   * @returns {String} 설정된 경로값
   */  
  ibsheetObject.prototype.GetLoadExcelUrl = function(Url){};

  /** 
   * LoadText : 텍스트 파일로부터 데이터를 읽어 들여 데이터 영역에 표시한다.
   * @example
   * // 텍스트 파일로 로딩하기
   * ibsheetObject.LoadText();
   * // 헤더타이틀을 서로 비교하여 동일한 컬럼끼리 로딩을 하며, 컬럼 구분자는'\t' 로 구분되어 있다
   * ibsheetObject.LoadText({Mode:'HeaderMatch', Deli:'\t'});
   */
  ibsheetObject.prototype.LoadText = function(parameters){};  

  /** 
   * SetLoadTextUrl : 텍스트 업로드 기능을 처리할 서버 페이지 경로를 설정한다.
   * @param {String} 설정할 서버 페이지 Url
   * @example
   * // 텍스트 업로드 경로를 설정한다.
   * ibsheetObject.SetLoadTextUrl("/jsp/LoadText.jsp");
   */  
  ibsheetObject.prototype.SetLoadTextUrl = function(Url){};
  
  /** 
   * GetLoadTextUrl : 텍스트 업로드 기능을 처리할 서버 페이지 경로를 확인한다.
   * @example
   * // 텍스트 업로드 설정 경로를 확인한다.
   * var url = ibsheetObject.GetLoadTextUrl();
   * @returns {String} 설정된 경로값
   */  
  ibsheetObject.prototype.GetLoadTextUrl = function(){};  
  
  /** 
   * SetMergeSheet : 전체적인 머지 종류를 설정한다.
   * @param {Integer} 머지 종류
   * 0: 머지 없음 (Default) 1: 전부 머지 가능 <br>
   * 2: 앞 컬럼이 머지 된 경우 해당 행 안에서 머지 가능 5:헤더만 머지 <br>
   * 7: 앞 컬럼이 머지 된 경우 해당 행 안에서 머지기능 + 헤더 머지 <br>
   * @example
   * // 초기 로드 시 전체 머지 종류를 설정
   * ibsheetObject.SetMergeSheet(msHeaderOnly);
   */  
  ibsheetObject.prototype.SetMergeSheet = function(Merge){};
  
  /** 
   * GetMergeSheet : 전체적인 머지 종류를 확인한다.
   * @return {Integer} 현재 설정된 머지 종류
   */  
  ibsheetObject.prototype.GetMergeSheet = function(Content){};

  /** 
   * SetMaximumValue : 숫자 Format과 관련된 경우 편집시 입력할 수 있는 최대값을 설정한다.
   * @param {Long} 해당 셀의 행 Index
   * @param {Long / String} 해당 셀의 컬럼 Index 또는 SaveName
   * @param {Long} 설정 최대 값
   * @example
   * // 숫자포멧의 최대값을 설정한다. <br>
   * ibsheetObject.SetMaximumValue(1, 12, 5000);
   */  
  ibsheetObject.prototype.SetMaximumValue = function(Row, Col){};
  
  /** 
   * GetMaximumValue : 숫자 Format과 관련된 경우 편집시 입력할 수 있는 최대값을 확인한다.
   * @example
   * // 설정된 숫자포멧의 최대값을 확인한다.
   * ibsheetObject.GetMaximumValue(1, 12);
   * @return {Long} 설정된 최대값
   */  
  ibsheetObject.prototype.GetMaximumValue = function(Row, Col, Value){};
  
  /** 
   * SetMinimumValue : 숫자 Format과 관련된 경우 편집시 입력할 수 있는 최소값을 설정한다.
   * @param {Long} 해당 셀의 행 Index
   * @param {Long / String} 해당 셀의 컬럼 Index 또는 SaveName
   * @param {Long} 설정 최소 값
   * @example
   * // 숫자포멧의 최소값을 설정한다. <br>
   * ibsheetObject.SetMinimumValue(1, 12, 1000);
   */  
  ibsheetObject.prototype.SetMinimumValue = function(Row, Col){};
  
  /** 
   * GetMinimumValue : 숫자 Format과 관련된 경우 편집시 입력할 수 있는 최소값을 확인한다.
   * @example
   * // 설정된 숫자포멧의 최소값을 확인한다.
   * ibsheetObject.GetMinimumValue(1, 12);
   * @return {Long} 설정된 최소값
   */  
  ibsheetObject.prototype.GetMinimumValue = function(Row, Col, Value){};  
  
  /** 
   * MouseCol : 마우스가 눌려졌을 때 선택된 컬럼 번호를 반환한다.
   * 데이터 영역이 아닌 경우는 ?1을 반환한다.
   * @example
   * // 마우스가 눌러졌을 때 컬럼 번호를 가져온다. <br>
   * function ibsheetObject_OnMouseDown(Button, Shift, X, Y) { <br>
   * 	alert(ibsheetObject.MouseRow() + "행 " + ibsheetObject.MouseCol() + "컬럼이 눌림"); <br>
   * } 
   * @return {Long} 마우스위치가 있는 컬럼 인덱스
   */  
  ibsheetObject.prototype.MouseCol = function(){};
  
  /** 
   * SetMousePointer : 마우스의 모양을 설정한다.
   * @param {String} 설정할 마우스 모양(Default:기본, Hand:손가락)
   * @example
   * function ibsheetObject_OnMouseMove(Button, Shift, X, Y) { <br>
   * //마우스 위치가 2컬럼 일때만 마우스 손가락 모양 <br>
   * if(ibsheetObject.MouseCol() == 2) { <br>
   *	ibsheetObject.SetMousePointer("Hand"); <br>
   * }else{ <br>
   *	ibsheetObject.SetMousePointer("Default"); <br>
   * } <br>
   * }
   */  
  ibsheetObject.prototype.SetMousePointer = function(Pointer){};
  
  /** 
   * GetMousePointer : 마우스의 모양을 확인한다.
   * @return {String} 마우스 설정 값
   */  
  ibsheetObject.prototype.GetMousePointer = function(){};

  /** 
   * MouseRow : 마우스가 눌려졌을 때 선택된 행 번호를 반환한다.
   * 데이터 영역이 아닌 경우는 ?1을 반환한다.
   * @example
   * // 마우스가 눌러졌을 때 컬럼 번호를 가져온다. <br>
   * function ibsheetObject_OnMouseDown(Button, Shift, X, Y){ <br>
   * alert(ibsheetObject.MouseRow() + "행이 눌림");<br>
   * } 
   * @return {Long} 마우스포인터가 있는 셀의 행 Index
   */  
  ibsheetObject.prototype.MouseRow = function(){};
  
  /** 
   * MoveColumnFail : 컬럼 이동 여부 실패(OnBeforeColumnMove 안에서 사용)
   * @param {Boolean} 컬럼이동실패여부
   */  
  ibsheetObject.prototype.MoveColumnFail = function(flag){};
  
  /** 
   * MoveColumnPos : 특정 컬럼을 새로운 컬럼 위치로 이동한다.
   * @param {Long / String} 이동할 컬럼의 Index 또는 SaveName
   * @param {Long / String} 이동될 위치의 컬럼 Index 또는 SaveName
   * @param {Boolean} 이동되면서 발생하는 이벤트 발생 여부 <br>
   * (OnBeforeColumnMove Event, OnAfterColumn Event, Default=1)
   * @example
   * // 1컬럼을 9컬럼으로 이동한다. <br>
   * ibsheetObject.MoveColumnPos(1, 9); <br>
   * // 각 컬럼의 SaveName으로 설정한 경우 <br>
   * ibsheetObject.MoveColumnPos("stockNm", "payAmt"); <br>
   */  
  ibsheetObject.prototype.MoveColumnPos = function(Col, NewPos, Event){};
  
  /** 
   * SetRangeBackColor : 셀의 범위 영역의 배경색을 설정하거나 확인한다.
   * @param {Long} 범위 시작 셀의 Row Index
   * @param {Long} 범위 시작 셀의 Column Index
   * @param {Long} 범위 종료 셀의 Row Index
   * @param {Long} 범위 종료 셀의 Column Index
   * @param {String} WebColor
   * @example
   * // 영역에 배경색 설정하기 <br>
   * ibsheetObject.SetRangeBackColor(1,0,10,10, "#FFFF00");<br>
   */  
  ibsheetObject.prototype.SetRangeBackColor = function(Row1,Col1,Row2,Col2,Color){};
  
  /** 
   * GetRangeBackColor : 셀의 범위 영역의 배경색을 설정하거나 확인한다.
   * @param {Long} 범위 시작 셀의 Row Index
   * @param {Long} 범위 시작 셀의 Column Index
   * @param {Long} 범위 종료 셀의 Row Index
   * @param {Long} 범위 종료 셀의 Column Index
   * @return {String} 현재 설정값
   */  
  ibsheetObject.prototype.GetRangeBackColor = function(Row1,Col1,Row2,Col2){};
   
  /** 
   * SetRangeFontBold : 셀의 범위 영역의 글자볼드 여부를 설정한다.
   * @param {Long} 범위 시작 셀의 Row Index
   * @param {Long} 범위 시작 셀의 Column Index
   * @param {Long} 범위 종료 셀의 Row Index
   * @param {Long} 범위 종료 셀의 Column Index
   * @param {String} 볼드 설정 여부
   * @example
   * // 영역 글자 볼드 설정하기 <br>
   * ibsheetObject.SetRangeFontBold(1, 0, 2, 2, 1);
   */  
  ibsheetObject.prototype.SetRangeFontBold = function(Row1,Col1,Row2,Col2,Bold){};
  
  /** 
   * GetRangeFontBold : 셀의 범위 영역의 글자볼드 여부를 확인한다.
   * @param {Long} 범위 시작 셀의 Row Index
   * @param {Long} 범위 시작 셀의 Column Index
   * @param {Long} 범위 종료 셀의 Row Index
   * @param {Long} 범위 종료 셀의 Column Index
   * @return {Boolean} 현재 설정값
   */  
  ibsheetObject.prototype.GetRangeFontBold = function(Row1,Col1,Row2,Col2){};
  
  /** 
   * SetRangeFontColor : 셀의 범위 영역의 글자색을 설정한다.
   * @param {Long} 범위 시작 셀의 Row Index
   * @param {Long} 범위 시작 셀의 Column Index
   * @param {Long} 범위 종료 셀의 Row Index
   * @param {Long} 범위 종료 셀의 Column Index
   * @param {String} WebColor
   * @example
   * //영역에 글자색 설정하기 <br>
   * ibsheetObject.SetRangeFontColor(1,0,10,10, "FF0000");
   */  
  ibsheetObject.prototype.SetRangeFontColor = function(Row1,Col1,Row2,Col2,Color){};
  
  /** 
   * GetRangeFontColor : 셀의 범위 영역의 글자색을 확인한다.
   * @param {Long} 범위 시작 셀의 Row Index
   * @param {Long} 범위 시작 셀의 Column Index
   * @param {Long} 범위 종료 셀의 Row Index
   * @param {Long} 범위 종료 셀의 Column Index
   * @return {Boolean} 현재 설정값
   */  
  ibsheetObject.prototype.GetRangeFontColor = function(Row1,Col1,Row2,Col2){};
 
  /** 
   * SetRangeText : 특정 영역의 셀값을 Format이 적용된 형태로
   * 화면에 보여지는 값 그대로 설정한다.
   * @param {String} 문자열
   * @param {Long} 범위 시작 셀의 Row Index
   * @param {Long} 범위 시작 셀의 Column Index
   * @param {Long} 범위 종료 셀의 Row Index
   * @param {Long} 범위 종료 셀의 Column Index
   * @param {String} 컬럼과 컬럼 사이를 구분하는 구분자. Default="|"
   * @param {String} 행과 행 사이를 구분하는 구분자. Default="^"
   * @example
   * // 1,1 셀에 A 를 2,2셀에 D를 설정한다.<br>
   * ibsheetObject.SetRangeText("A|B^C|D", 1, 1, 2, 2, "|", "^");
   * //1,7 셀부터 5,10 셀까지 ** 로 설정한다.
   * ibsheetObject.SetRangeText("**", 1, 7, 5, 10);
   */  
  ibsheetObject.prototype.SetRangeText = function(sData,Row1,Col1,Row2,
		  Col2,ColSeparator,RowSeparator){};
  
  /** 
   * GetRangeText : 특정 영역의 셀값을 Format이 적용된 형태로
   * 화면에 보여지는 값 그대로 확인한다.
   * @param {Long} 범위 시작 셀의 Row Index
   * @param {Long} 범위 시작 셀의 Column Index
   * @param {Long} 범위 종료 셀의 Row Index
   * @param {Long} 범위 종료 셀의 Column Index
   * @param {String} 컬럼과 컬럼 사이를 구분하는 구분자 (Default="|")
   * @param {String} 행과 행 사이를 구분하는 구분자 (Default="^")
   * @return {String} 현재 문자열값
   */  
  ibsheetObject.prototype.GetRangeText = function(sData,Row1,Col1,Row2,
		  Col2,ColSeparator,RowSeparator){};
  
  /** 
   * SetRangevalue : 특정 영역의 셀값을 Format이 적용된 형태로
   * 화면에 보여지는 값 그대로 설정한다.
   * @param {String} 문자열
   * @param {Long} 범위 시작 셀의 Row Index
   * @param {Long} 범위 시작 셀의 Column Index
   * @param {Long} 범위 종료 셀의 Row Index
   * @param {Long} 범위 종료 셀의 Column Index
   * @param {String} 컬럼과 컬럼 사이를 구분하는 구분자. Default="|"
   * @param {String} 행과 행 사이를 구분하는 구분자. Default="^"
   * @example
   * // 1,1 셀에 A 를 2,2셀에 D를 설정한다.<br>
   * ibsheetObject.SetRangeValue("A|B^C|D", 1, 1, 2, 2, "|", "^");
   */  
  ibsheetObject.prototype.SetRangevalue = function(sData,Row1,Col1,Row2,
		  Col2,ColSeparator,RowSeparator){};
  
  /** 
   * GetRangevalue : 특정 영역의 셀값을 Format이 적용된 형태로
   * 화면에 보여지는 값 그대로 확인한다.
   * @param {Long} 범위 시작 셀의 Row Index
   * @param {Long} 범위 시작 셀의 Column Index
   * @param {Long} 범위 종료 셀의 Row Index
   * @param {Long} 범위 종료 셀의 Column Index
   * @param {String} 컬럼과 컬럼 사이를 구분하는 구분자 (Default="|")
   * @param {String} 행과 행 사이를 구분하는 구분자 (Default="^")
   * @return {String} 현재 문자열값
   */  
  ibsheetObject.prototype.GetRangevalue = function(sData,Row1,Col1,Row2,
		  Col2,ColSeparator,RowSeparator){};
  
  /** 
   * SetRedrawSum : 합계 내용 계산 여부를 설정한다.
   * @param {Boolean} 합계행 계산 여부
   * @example
   * //변경해야 할 데이터가 많은 경우 사용
   * ibsheetObject.SetRedrawSum(0);
   */  
  ibsheetObject.prototype.SetRedrawSum = function(Redraw){};
  
  /** 
   * GetRedrawSum : 합계 내용 계산 여부를 확인한다.
   * @return {Boolean} 설정 값
   */  
  ibsheetObject.prototype.GetRedrawSum = function(){}; 
		  
  /** 
   * RemoveAll : 해더 행을 제외한 모든 데이터 행을 지운다.
   * @example
   * // 모든 데이터 지우기
   * ibsheetObject.RemoveAll();
   * @return {Boolean} 설정 값
   */  
  ibsheetObject.prototype.RemoveAll = function(){};
  
  /** 
   * RenderSheet : 속도개선을 위해 랜더링을 마지막에 한꺼번에 처리 하기 위한 기능을 한다.
   * (ColHidden, DataInsert, InitCellProperty)
   * @param {Boolean} 렌더링 여부 (Default=1)
   * @example
   * // 랜더링끄기
   * ibsheetObject.RenderSheet(0);
   */  
  ibsheetObject.prototype.RenderSheet = function(Render){};
  
  /** 
   * ReNumberSeq : 데이터 타입이 Seq인 데이터의 순번을 다시 매긴다.
   * @example
   * // 컬럼의 Type이 Seq인 컬럼의 숫자를 1부터 다시 메긴다. 
   * ibsheetObject.ReNumberSeq();
   */  
  ibsheetObject.prototype.ReNumberSeq = function(){};
  
  /** 
   * Reset : IBSheet에 설정된 모든 기본 속성을 제거하고 초기상태로 변경한다.
   * @example
   * // 초기 상태로 변경하기 
   * ibsheetObject.Reset();
   */  
  ibsheetObject.prototype.Reset = function(){};
  
  /** 
   * ReturnCellData : 특정 셀의 값을 트랜잭션이 발생하기 이전의 조회된 데이터 되돌린다.
   * @param {Long} 데이터 셀의 Row Index
   * @param {Long / String} 데이터 셀의 Column Index 또는 SaveName 
   * @example
   * // 1행 4컬럼에 셀을 되돌린다.
   * ibsheetObject.ReturnCellData(1,4);
   */  
  ibsheetObject.prototype.ReturnCellData = function(Row,Col){};
  
  /** 
   * ReturnColumnPos : 이동된 컬럼의 위치를 처음 위치로 되돌린다.
   * @example
   * // 초기 위치로 되돌린다.
   * ibsheetObject.ReturnColumnPos();
   */  
  ibsheetObject.prototype.ReturnColumnPos = function(){};
  
  /** 
   * ReturnData : 특정 행의 데이터를 조회 상태의 문자열로 변경한다.
   * @param {Long} 데이터 행의 Row Index
   * @example
   * // 초기 상태로 변경하기.
   * ibsheetObject.ReturnData(2);
   */  
  ibsheetObject.prototype.ReturnData = function(Row){};
  
  /** 
   * SetRowBackColor : 전체의 배경색을 설정한다.
   * @param {Long} Row Index
   * @param {String} WebColor 색상 값
   * @example
   * // 1행의 배경색을 회색으로 설정한다.
   * ibsheetObject.SetRowBackColor(1,"#C0C0C0");
   */  
  ibsheetObject.prototype.SetRowBackColor = function(Row, BackColor){}; 
  
  /** 
   * GetRowBackColor : 전체의 배경색을 확인한다.
   * @param {Long} 데이터 행의 Row Index
   * @returns {String} 배경 색상
   */  
  ibsheetObject.prototype.GetRowBackColor = function(Row){}; 
  
  /** 
   * SetRowBackColorD : 각행의 트렌젝션 상태가 삭제인 행의 배경색을 설정한다.
   * (새로 추가되는 항목에 한하여)
   * @param {Long} Row Index
   * @param {String} WebColor 색상 값
   * @example
   * // 트렌젝션상태가 삭제인 행의 배경색을 회색으로 설정한다.
   * ibsheetObject.SetRowBackColorD("#C0C0C0");
   */  
  ibsheetObject.prototype.SetRowBackColorD = function(Row, BackColor){}; 
  
  /** 
   * GetRowBackColorD : 각행의 트렌젝션 상태가 삭제인 행의 배경색을 확인한다.
   * @returns {String} 설정 색상
   */  
  ibsheetObject.prototype.GetRowBackColorD = function(BackColor){};
  
  /** 
   * SetRowBackColorI : 각행의 트렌젝션 상태가 입력인 행의 배경색을 설정한다.
   * (새로 추가되는 항목에 한하여)
   * @param {String} WebColor 색상 값
   * @example
   * // 트렌젝션상태가 입력인 행의 배경색을 회색으로 설정한다.
   * ibsheetObject.SetRowBackColorI("#C0C0C0");
   */  
  ibsheetObject.prototype.SetRowBackColorI = function(BackColor){}; 
  
  /** 
   * GetRowBackColorI : 각행의 트렌젝션 상태가 입력인 행의 배경색을 확인한다.
   * @returns {String} 설정 색상
   */  
  ibsheetObject.prototype.GetRowBackColorI = function(){};
  
  /** 
   * SetRowBackColorU : 각행의 트렌젝션 상태가 수정인 행의 배경색을 설정한다.
   * (새로 추가되는 항목에 한하여)
   * @param {String} WebColor 색상 값
   * @example
   * // 트렌젝션상태가 입력인 행의 배경색을 회색으로 설정한다.
   * ibsheetObject.SetRowBackColorI("#C0C0C0");
   */  
  ibsheetObject.prototype.SetRowBackColorU = function(BackColor){}; 
  
  /** 
   * GetRowBackColorU : 각행의 트렌젝션 상태가 수정인 행의 배경색을 확인한다.
   * @returns {String} 설정 색상
   */  
  ibsheetObject.prototype.GetRowBackColorU = function(){};
  
  /** 
   * RowCount : 전체 데이터 행 개수를 확인한다.
   * @param {String} 트랜잭션 코드. Default="전체건수
   * @example
   * alert("전체 건수 는 " + ibsheetObject.RowCount() + " 건입니다. ");
   * alert("조회 건수 는 " + ibsheetObject.RowCount("R") + " 건입니다. ");
   * @returns {Long} 전체 또는 특정 트랜잭션 상태의 데이터행 개수
   */  
  ibsheetObject.prototype.RowCount = function(Status){}; 

  /** 
   * RowDelete : 특정 행을 완전히 제거한다.
   * @param {Long} 삭제할 행의 Row Index (Default ="마지막 선택 행")
   * @param {Boolean} 삭제 전 메세지 확인 여부 (Default=0)
   * @example
   * // 확인 메시지 없이 1행 제거하기
   * ibsheetObject.RowDelete(1, 0); 
   * @returns {Long} 전체 또는 특정 트랜잭션 상태의 데이터행 개수
   */  
  ibsheetObject.prototype.RowDelete = function(Row, Question){};
  
  /** 
   * SetRowEditable : 특정 행의 Edit 가능 여부를 설정한다.
   * @param {Long} 해당 행의 Row Index
   * @param {Boolean} 행의 Edit 가능 여부
   * @example
   * // 1행의 Edit 가능 여부를 0으로 설정한다.
   * ibsheetObject.SetRowEditable(1,0);
   * @returns {Long} 전체 또는 특정 트랜잭션 상태의 데이터행 개수
   */  
  ibsheetObject.prototype.SetRowEditable = function(Row, Editable){};
  
  /** 
   * GetRowEditable : 특정 행의 Edit 가능 여부를 확인한다.
   * @param {Long} 해당 행의 Row Index
   * @returns {Boolean} Edit 가능 여부
   */  
  ibsheetObject.prototype.GetRowEditable = function(Row){};
  
  /** 
   * SetRowExpanded : 특정 행의 Edit 가능 여부를 설정한다.
   * @param {Long} Row Index
   * @param {Boolean} 자식행의 펼쳐짐 여부
   * @example
   * // 2행의 트리를 펼친다. <br>
   * if(ibsheetObject.GetRowExpanded(2) == 0){ <br>
   * 	ibsheetObject.SetRowExpanded(2, 1); <br>
   * }
   */  
  ibsheetObject.prototype.SetRowExpanded = function(Row, Expand){};
  
  /** 
   * GetRowEditable : 특정 행의 Edit 가능 여부를 확인한다.
   * @param {Long} 해당 행의 Row Index
   * @returns {Boolean} 행의 자식행들의 펼쳐짐 여부
   */  
  ibsheetObject.prototype.GetRowEditable = function(Row){};
  
  /** 
   * SetRowFontColor : 행 전체의 글자색을 설정한다.
   * @param {Long} Row Index
   * @param {String} WebColor 색상 값
   * @example
   * // 1행의 글자색을 회색으로 설정한다. <br>
   * ibsheetObject.SetRowFontColor(1, "192,192,192");
   */  
  ibsheetObject.prototype.SetRowFontColor = function(Row,Color){};
  
  /** 
   * GetRowFontColor : 행 전체의 글자색을 확인한다.
   * @param {Long} Row Index
   * @returns {String} 설정 색상
   */  
  ibsheetObject.prototype.GetRowFontColor = function(Row){};
  
  /** 
   * SetRowHeight : 특정 행의 높이를 확인한다.
   * @param {Long} Row Index
   * @param {Integer} Row Height
   * @example
   * // 50 픽셀로 높이 수정 <br>
   * ibsheetObject.SetRowHeight(1, 50);
   */  
  ibsheetObject.prototype.SetRowHeight = function(Row,Height){};
  
  /** 
   * GetRowHeight : 특정 행의 높이를 설정한다.
   * @param {Long} Row Index
   * @returns {Integer} 현재 행 높이
   */  
  ibsheetObject.prototype.GetRowHeight = function(Row){};
  
  /** 
   * SetRowHeightMax : 모든 데이터 행의 최대 높이를 설정한다.
   * @param {Integer} 해당 행에 설정 할 최대 높이값
   * @example
   * // 최대 높이를 50픽셀로 설정한다. <br>
   * ibsheetObject.SetRowHeight(1, 50);
   */  
  ibsheetObject.prototype.SetRowHeightMax = function(MaxHeight){};
  
  /** 
   * GetRowHeightMax : 모든 데이터 행의 최대 높이를 확인한다.
   * @example
   * // 설정한 최대 높이값 확인한다.
   * ibsheetObject.GetRowHeightMax();
   * @returns {Integer} 행의 최대 높이
   */  
  ibsheetObject.prototype.GetRowHeightMax = function(){};
  
  /** 
   * SetRowHeightMin :  모든 행의 최소 높이를 설정한다. (5픽셀이상)
   * @param {Integer} 해당 행에 설정 할 최소 높이값
   * @example
   * // 최소 높이를 10픽셀로 설정한다. <br>
   * ibsheetObject.SetRowHeightMin(10);
   */  
  ibsheetObject.prototype.SetRowHeightMin = function(MaxHeight){};
  
  /** 
   * GetRowHeightMin :  모든 행의 최소 높이를 확인한다.
   * @example
   * // 설정한 최소 높이값 확인한다.
   * ibsheetObject.GetRowHeightMin();
   * @returns {Integer} 행의 최소 높이
   */  
  ibsheetObject.prototype.GetRowHeightMin = function(){};
  
  /** 
   * SetRowHidden : 행의 숨기여부를 설정한다.
   * @param {Long / String} 특정 행의 Row Index 혹은 구분자 "|"로 연결된 문자열
   * @param {Boolean} 숨김여부
   * @example
   * // 다수의 행을 숨김<br>
   * ibsheetObject.SetRowHidden("2|5|7|10", 1);
   */  
  ibsheetObject.prototype.SetRowHidden = function(Row, Hidden){};
  
  /** 
   * GetRowHidden : 행의 숨기여부를 확인한다.
   * @param {Long / String} 특정 행의 Row Index
   * @example
   * // 설정한 최소 높이값 확인한다.
   * ibsheetObject.GetRowHeightMin();
   * @returns {Boolean} 1: 숨김, 0: 보임
   */  
  ibsheetObject.prototype.GetRowHidden = function(Row){};

  /** 
   * SetRowLevel : 행의 트리 레벨을 설정한다.
   * @param {Long / String} 해당 행의 Row Index
   * @param {Integer} 해당 행의 트리 레벨값
   * @example
   * // 트리 레벨을 1 증가 시킨다.
   * ibsheetObject.SetRowLevel(1,ibsheetObject.GetRowLevel(1) +1);
   */  
  ibsheetObject.prototype.SetRowHidden = function(Row, Level){};
  
  /** 
   * GetRowLevel : 행의 트리 레벨을 확인한다.
   * @param {Long / String} 해당 행의 Row Index
   * @example
   * @returns {Boolean} 1: 숨김, 0: 보임
   */  
  ibsheetObject.prototype.GetRowLevel = function(Row){};  
 
  /** 
   * SetRowMerge : 행의 가로 머지 여부를 설정한다.
   * @param {Long} 해당 행의 Row Index
   * @param {Boolean} 가로머지 허용 여부
   * @example
   * // 첫번째 행의 가로 머지를 허용하도록 설정한다.
   * ibsheetObject.SetRowMerge(1, 1);
   */  
  ibsheetObject.prototype.SetRowMerge = function(Row, Merge){};
  
  /** 
   * GetRowMerge : 행의 가로 머지 여부를 확인한다.
   * @param {Long} 해당 행의 Row Index
   * @returns {Boolean} 현재 행의 가로 머지 여부
   */  
  ibsheetObject.prototype.GetRowMerge = function(Row){};
  
  /** 
   * RowSaveStr : 행의 데이터를 각 컬럼의 SaveName을 이용하여
   * 저장 시 사용되는 Query String 형태로 조합하여 반환한다.
   * @param {Long} 해당 행의 Row Index
   * @example
   * // 1행의 SaveString을 가져온다. <br>
   * var RowParam = ibsheetObject.RowSaveStr(1);
   */  
  ibsheetObject.prototype.RowSaveStr = function(Row){};
  
  /** 
   * RowTop : 행의 상단 위치를 확인한다.
   * @param {Long} 행의 상단 위치 index
   * @example
   * //행의 상단 위치를 파악한다. <br>
   * var iTop = ibsheetObject.RowTop(1);
   */  
  ibsheetObject.prototype.RowTop = function(Row){};
  
  /** 
   * SaveNameCol : SaveName을 이용하여 해당하는 컬럼 번호를 확인한다.
   * @param {String} 저장 변수명
   * @example
   * // 변수명으로 컬럼 번호를 가져온다. <br>
   * var Col = ibsheetObject.SaveNameCol("STATUS");
   * @returns {Long} 컬럼의 Index
   */  
  ibsheetObject.prototype.SaveNameCol = function(SaveName){};
  
  /** 
   * SetSavingImage : 저장 중 대기 이미지 파일의 위치를 설정한다.
   * @param {String} 이미지 URL
   * @example
   * // 저장 중 대기 이미지를 변경한다. <br>
   * ibsheetObject.SetSavingImage( "/sheet/imgSave.gif");
   */  
  ibsheetObject.prototype.SetSavingImage = function(Url){};
  
  /** 
   * GetSavingImage : 저장 중 대기 이미지 파일의 위치를 확인한다.
   * @param {String} 저장 변수명
   * @example
   * // 현재 설정되어있는 저장 중 대기 이미지 경로를 확인한다. <br>
   * alert(ibsheetObject.GetSavingImage());
   * @returns {String} 현재 설정값
   */  
  ibsheetObject.prototype.GetSavingImage = function(){};
  
  /** 
   * SetSearchingImage : 조회 중 대기 이미지 파일의 위치를 설정한다.
   * @param {String} 이미지 URL
   * @example
   * // 조회 중 대기 이미지를 변경한다. <br>
   * ibsheetObject.SetSearchingImage( "/sheet/imgSearch.gif");
   */  
  ibsheetObject.prototype.SetSearchingImage = function(Url){};
  
  /** 
   * GetSearchingImage : 조회 중 대기 이미지 파일의 위치를 확인한다.
   * @param {String} 저장 변수명
   * @example
   * // 현재 설정되어있는 조회 중 대기 이미지 경로를 확인한다. <br>
   * alert(ibsheetObject.GetSearchingImage());
   * @returns {String} 현재 설정값
   */  
  ibsheetObject.prototype.GetSearchingImage = function(){};
  
  /** 
   * SearchRows : 조회 XML을 통해서 조회된 전체 행 개수를 확인한다.
   * @param {String} 저장 변수명
   * @example
   * // 행 개수 확인 <br>
   * alert(ibsheetObject.SearchRows());
   * @returns {Long} 조회된 전체 행 개수
   */  
  ibsheetObject.prototype.SearchRows = function(){};

  /** 
   * SelectCell : 특정 셀을 선택한다
   * @param {Long} 선택할 셀의 Row Index
   * @param {Long / String} 선택할 셀의 Column Index 또는 SaveName
   * @param {Boolean} 선택과 동시에 Edit 가능 여부를 설정 (Default=0, Edit 불가능)
   * @param {String} EditMode가 1일때 편집상태의 글자 설정 (Defulat= "")
   * @example
   * // 2행을 선택하고 그 행 아래에 새로운 행 생성하기
   * ibsheetObject.SelectCell(2, 0); <br>
   * ibsheetObject.DataInsert();
   */  
  ibsheetObject.prototype.SelectCell = function(Row, Col, EditMode, EditModeText){};
  
  /** 
   * SetSelectCol : 현재 선택된 셀의 컬럼 Index를 설정한다.
   * @param {Long/String} 현재 선택된 셀의 Column Index 또는 SaveName
   * @example
   * // 인덱스가 2인 컬럼을 선택한다.<br>
   * ibsheetObject.SetSelectCol(2);
   */  
  ibsheetObject.prototype.SetSelectCol = function(Col){};
  
  /** 
   * GetSelectCol : 현재 선택된 셀의 컬럼 Index를 확인한다.
   * @example
   * // 선택된 컬럼을 확인한다. <br>
   * alert(ibsheetObject.GetSelectCol());
   * @returns {Long} 현재 선택된 컬럼 Index
   */  
  ibsheetObject.prototype.GetSelectCol = function(){}; 
  
  /** 
   * SetSelectionMode : 셀 선택 모드를 설정한다.
   * (0:셀 단위, 1:행 단위, 3:Ctrl키사용)
   * @param {Integer} 선택 모드 종류
   * @example
   * // 셀 단위 선택으로 설정한다.<br>
   * ibsheetObject.SetSelectionMode(0);
   */  
  ibsheetObject.prototype.SetSelectionMode = function(Mode){};
  
  /** 
   * GetSelectionMode : 셀 선택 모드를 확인한다.
   * @example
   * // 현재 설정되어 있는 선택 모드를 확인한다. <br>
   * alert(ibsheetObject.GetSelectionMode());
   * @returns {Integer} 현재 설정 값
   */  
  ibsheetObject.prototype.GetSelectionMode = function(){};   
  
  /** 
   * SetSelectRow : 현재 선택된 셀의 행 Index를 설정한다.
   * @param {Long} 현재 선택된 셀의 행 Index
   * @example
   * // 인덱스가 2인 행을 선택한다. <br>
   * ibsheetObject.SetSelectRow(2);
   */  
  ibsheetObject.prototype.SetSelectRow = function(Row){};
  
  /** 
   * GetSelectRow : 현재 선택된 셀의 행 Index를 확인한다.
   * @example
   * // 선택된 행을 확인한다. <br>
   * alert(ibsheetObject.GetSelectRow());
   * @returns {Long} 현재 선택된 행 Index
   */  
  ibsheetObject.prototype.GetSelectRow = function(){};
  
  /** 
   * SetSendComboData : 데이터 타입이 Combo일때 서버로 전송되는 데이터를 설정한다.
   * @param {Long} 단위 데이터 행 Index
   * @param {Long / String} 특정 컬럼의 Column Index 또는 SaveName
   * @param {String} 서버 전송 옵션 설정("Text" 또는 "code")
   * @example
   * //3컬럼에 대해서 저장시 Code 와 Text 값이 같이 전달되도록 한다. <br>
   * ibsheetObject.SendComboData(0,3) = "Code|Text";
   */  
  ibsheetObject.prototype.SetSendComboData = function(DataRow, Col){};
  
  /** 
   * GetSendComboData : 데이터 타입이 Combo일때 서버로 전송되는 데이터를 확인한다.
   * @param {Long} 단위 데이터 행 Index
   * @param {Long / String} 특정 컬럼의 Column Index 또는 SaveName   
   * @example
   * // Dept 컬럼에 대해서 저장시 Code 대신 Text 값이 전달되도록 한다. <br>
   * ibsheetObject.SendComboData(0,"Dept") = "Text";
   * @returns {String} 현재 선택된 콤보 컬럼의 전송될 데이터 형식
   */  
  ibsheetObject.prototype.GetSendComboData = function(DataRow, Col){};
  
  /** 
   * SetBlur : 시트에 포커스를 뺀다.
   * @param {Long} 단위 데이터 행 Index
   * @param {Long / String} 특정 컬럼의 Column Index 또는 SaveName
   * @param {String} 서버 전송 옵션 설정("Text" 또는 "code")
   * @example
   * // 시트에서 포커스를 뺀다. <br>
   * ibsheetObject.SetBlur();
   */  
  ibsheetObject.prototype.SetBlur = function(){};
  
  /** 
   * SetCellImageStyle : Image 속성을 사용하는 경우 해당 셀의 이미지에 대한 설정을 한다.
   * @param {Long} 대상 행의 Index
   * @param {Long / String} 대상 컬럼의 Index 또는 SaveName
   * @param {Object} 셀의 이미지관련 속성 객체
   * @example
   * // 3번째 행의 3번째 컬럼에 이미지를 왼쪽에 표시. <br>
   * var style = {Image: "myImage.gif", ImgHeight:20, ImgAlign:"Left"}; <br>
   * ibsheetObject.SetCellImageStyle(3, 3, style);
   */  
  ibsheetObject.prototype.SetCellImageStyle = function(Row, Col, Style){};

  /** 
   * SetColProperty : InitColums Method를 통해 정의후 특정 컬럼의 속성 정의를 동적으로 변경
   * @param {Long / String} 대상이 되는 컬럼 또는 SaveName
   * @param {info} 컬럼의 속성 정의 객체
   * @example
   * // 3번째 컬럼의 콤보 목록을 변경 <br>
   * var info = {ComboText: "신규|진행중|완료 ", ComboCode: " 01|02|03" }; <br>
   * ibsheetObject.SetColProperty(3, info);
   */  
  ibsheetObject.prototype.SetColProperty = function(Col, info){};
  
  /** 
   * SetConfig : 시트 초기화시 조회 방식와 틀고정 위치 및 기본적인 설정을 처리한다.
   * @param {json} JSON 형태로 구성하여 전달한다.
   * @example
   * // 페이징 모드 조회 예제 <br>
   * var cfg= {SearchMode:1, Page:20}; <br>
   * ibsheetObject.SetConfig(cfg);
   */  
  ibsheetObject.prototype.SetConfig = function(cfg){};  
 
  /** 
   * SetEndEdit : 셀 편집을 종료 한다.
   * @param {Boolean} 편집중인 내용 저장 여부 (0:false, 1:true) 
   * @example
   * // 저장 관련 로직 처리 함수 <br>
   * var result = ibsheetObject.SetEndEdit(1); <br>
   * if (!result) { <br>
   * return; <br>
   * } 	
   */  
  ibsheetObject.prototype.SetEndEdit = function(Save){};
  
  /** 
   * SetFilterOption : 필터행 사용시 컬럼의 필터 옵션값을 설정할 때 사용한다.
   * @param {Long} Column Index 또는 SaveName
   * @param {Integer} 설정 할 Option 값
   * @example
   * // 필터행이 1행일 경우 2컬럼의 필터링 할 값 설정 <br>
   * ibsheetObject.SetCellValue(1, 2, "포함");
   * // 문자열 '포함' 과 같은 단어 필터링.
   * ibsheetObject.SetFilterOption (2, 1);
   */  
  ibsheetObject.prototype.SetFilterOption = function(Col, Option){};
  
  /** 
   * SetFilterValue : 필터행 사용시 컬럼의 필터 옵션값을 설정할 때 사용한다.
   * @param {Long} Column Index 또는 SaveName
   * @param {String} 필터에 설정할 값
   * @param {Integer} 설정 할 Option 값
   * @example
   * // 5컬럼에 "서울"이 포함된 문자열 필터링하기 <br>
   * ibsheetObject.SetFilterValue(5, "서울", 11);
   */  
  ibsheetObject.prototype.SetFilterValue = function(Col, Value, Option){};  
  
  /** 
   * SetFocus : 시트에 포커스를 설정 한다.
   * @example
   * // 시트에 포커스를 설정 한다. <br>
   * ibsheetObject.SetFocus();
   */  
  ibsheetObject.prototype.SetFocus = function(){};   

  /** 
   * SetMergeCell : 특정 셀을 기준으로 인접한 셀과 강제로 머지한다.
   * @param {Long} 강제머지할 셀의 Row Index
   * @param {Long} 강제머지할 셀의 Column Index
   * @param {Long} 강제머지할 셀의 Row 개수
   * @param {Long} 강제머지할 셀의 Col 개수
   * @example
   * // (1,10)부터(2,11)까지 2x2 창문형태의 셀을 강제로 머지하여 표시한다. <br>
   * ibsheetObject.SetMergeCell(1, 10, 2, 2);
   */  
  ibsheetObject.prototype.SetMergeCell = function(Row, Col, Rows, Cols){};
  
  /** 
   * SetRowHaveChildValue : 트리구조에서 조회시 HaveChild 속성 설정값을 변경한다.
   * @param {Long} 대상 행의 Index
   * @param {Boolean} 속성 설정값
   * @example
   * // 3행의 HaveChild 속성을 0으로 변경한다. <br>
   * ibsheetObject.SetRowHaveChildValue(3, 0);
   */  
  ibsheetObject.prototype.SetRowHaveChildValue = function(Row, HaveChild){};
  
  /** 
   * SetSheetFontName : 전체 시트 글자체를 설정한다.
   * @param {String} 설정하고자 하는 글꼴
   * @example
   * // 전체 시트 글꼴을 설정한다. <br>
   * ibsheetObject.SetSheetFontName("Arial");
   */  
  ibsheetObject.prototype.SetSheetFontName = function(FontName){};
  
  /** 
   * GetSheetFontName : 전체 시트 글자체를 확인한다.
   * @returns {String} 설정되어 있는 글꼴
   */  
  ibsheetObject.prototype.GetSheetFontName = function(){};
  
  /** 
   * SetSheetFontSize : 전체 시트 글자체를 설정한다.
   * @param {Integer} 설정하고자 하는 글자크기
   * @example
   * // 전체 시트 글자 크기를 설정한다. <br>
   * ibsheetObject.SetSheetFontSize(10);
   */  
  ibsheetObject.prototype.SetSheetFontSize = function(FontSize){};
  
  /** 
   * GetSheetFontSize : 전체 시트 글자체를 확인한다.
   * @returns {Integer} 설정되어 있는 글자크기
   */  
  ibsheetObject.prototype.GetSheetFontSize = function(){};  
  
  /** 
   * SetSheetWidth : 전체 너비를 설정한다. 값은 픽셀
   * @param {Integer} 설정하고자 하는 시트 너비 픽셀값
   * @example
   * // 전체 너비를 800px로 설정한다. <br>
   * ibsheetObject.SetSheetWidth(800);
   */  
  ibsheetObject.prototype.SetSheetWidth = function(FontSize){};
  
  /** 
   * GetSheetWidth : 전체 너비를 확인한다.
   * @example
   * // 현재 설정되어있는 전체 너비를 확인한다.
   * alert(ibsheetObject.GetSheetWidth());
   * @returns {Integer} 설정되어 있는 너비 픽셀값
   */  
  ibsheetObject.prototype.GetSheetWidth = function(){};
  
  /** 
   * SetShowButtonImage : 팝업과 콤보의 버튼 이미지를 표시하는 종류를 설정한다(초기로드시)
   * @param {Integer} 설정 값 (Default =3) <br>
   * 0: 포커스시 /콤보/달력/팝업 <br>
   * 1: Edit가능일때 /달력/팝업 <br>
   * 2: 항상 달력 <br>
   * 3: Edit가능일때 콤보/달력/팝업 <br>
   * 4: 항상 콤보/달력/팝업 이미지 표시 <br>
   * @example
   * // Edit가 가능할 때 팝업이미지가 표시된다. <br> 
   * ibsheetObject.SetShowButtonImage(1);
   */  
  ibsheetObject.prototype.SetShowButtonImage = function(type){};
  
  /** 
   * GetShowButtonImage : 팝업과 콤보의 버튼 이미지를 표시하는 종류를 확인한다
   * @returns {Integer} 현재 설정 값
   */  
  ibsheetObject.prototype.GetShowButtonImage = function(){};
  
  /** 
   * ShowDebugMsg : 디버깅용 메시지의 표시여부를 확인하거나 설정한다.
   * @param {Integer} 디버깅용 메시지 표시여부 설정 (Default=0) <br>
   * -1: 시스템 팝업 디버그 시작<br>
   *  0: 모든 디버그 종료 (Default=0) 
   * @example
   * // 저장 처리 과정을 디버깅 메시지를 팝업으로 표시 <br> 
   * ibsheetObject.ShowDebugMsg(-1);
   */  
  ibsheetObject.prototype.ShowDebugMsg = function(Msg){};
  
  /** 
   * ShowColumnPopup : InitColumns 함수를 이용하여 컬럼 팝업 기능이
   * 설정된 컬럼에서 함수를 이용하여 강제로 팝업을 열어주는 기능이다.
   * @param {Long} 선택할 셀의 Row Index <br>
   * @param {Long / String} 선택할 셀의 Column Index 또는 SaveName <br>
   * @param {Boolean} 마지막 마우스 위치 사용 여부 (Default=1)<br>
   * @example
   * // 현재 셀 위치에 팝업 열기 <br> 
   * ibsheetObject.ShowColumnPopup(1, 4, 0);
   */  
  ibsheetObject.prototype.ShowColumnPopup = function(Row, Col, MousePos){};
  
  /** 
   * ShowFilterRow : IBSheet 상단 고정행으로 필터행을 추가한다.
   * 함수의 호출 시점은 초기화 이후 조회 처리전에 호출
   * @example
   * // 필터행 추가하기 <br> 
   * ibsheetObject.ShowFilterRow();
   */  
  ibsheetObject.prototype.ShowFilterRow = function(){};  
  
  /** 
   * ShowFindDialog : ctrl+shift+F 입력시 표시되는 찾기 창을 표시한다.
   * @example
   * // 찾기창을 표시한다.<br> 
   * ibsheetObject.ShowFindDialog();
   */  
  ibsheetObject.prototype.ShowFindDialog = function(){}; 
  
  /** 
   * ShowGroupRow : IBSheet 헤더 상단에 그룹행을 추가한다.
   * @param {Long/String} 그룹핑 하고자 하는 컬럼의 Index 또는 SaveName을 "|"로 연결한 문자열
   * @example
   * // 그룹행 추가하기 <br> 
   * ibsheetObject.ShowGroupRow();
   */  
  ibsheetObject.prototype.ShowGroupRow = function(Cols){};

  /** 
   * SetShowMsgMode : 이벤트방식 지정 (0:OnMessage Event 1:시스템 팝업 발생)
   * @param {Boolean} 메시지 표시 여부
   * @example
   * // 메시지 모드를 설정한다. <br> 
   * ibsheetObject.SetShowMsgMode(0);
   */  
  ibsheetObject.prototype.SetShowMsgMode = function(Mode){};
  
  /** 
   * GetShowMsgMode : 이벤트방식 지정 확인
   * @returns {Boolean} 현재 설정 값
   */  
  ibsheetObject.prototype.GetShowMsgMode = function(){};
  
  /** 
   * SetShowSortArrow : 소트되는 방향을 화살표 이미지로 표시할지 여부를 설정한다.
   * @param {Boolean} 화살표 이미지 표시여부
   * @example
   * // 소트 방향을 표시한다. <br> 
   * ibsheetObject.SetShowSortArrow(1);
   */  
  ibsheetObject.prototype.SetShowSortArrow = function(Arrow){};
  
  /** 
   * GetShowSortArrow : 소트되는 방향을 화살표 이미지로 표시할지 여부를 확인한다.
   * @example
   * // 설정되어 있는 소트 방향 표시여부를 확인한다.
   * alert(ibsheetObject.GetShowSortArrow());	
   * @returns {Boolean} 현재 설정 값
   */  
  ibsheetObject.prototype.GetShowSortArrow = function(){};
  
  /** 
   * ShowSubSum : 특정 컬럼의 데이터를 기준으로 소계와 누계를 계산하여 표시한다.
   * @param {Long/String} StdCol : 기준 컬럼 Index 또는 SaveName <br>
   * @param {String} SumCols : 소계가 계산되어야 할 컬럼 Index를 "|"로 연결한 문자열 <br>
   * @param {Boolean} Sort : 기준 컬럼의 Sort 처리 여부 <br>
   * @param {Boolean} ShowCumulate : 소계에 대한 누계 표시 여부 <br>
   * @param {Long} CaptionCol : 소계 대표 글자인 "소계:" + 기준값을 설정할 컬럼 <br>
   * @param {String} CaptionText : 소계 대표 글자 포맷을 설정 <br>
   * @param {String} AvgCols 소계 행에 평균으로 계산되어야 할 컬럼 Index를 "|"로 연결한 문자열 <br>
   * @example
   * // 1컬럼(용량)을 중심으로 소계만 계산하여 표시<br> 
   * var info = [ <br>
   * {StdCol:1, SumCols:"2|3|4|5|6|7", Sort:1} <br>
   * ]; <br>
   * ibsheetObject.ShowSubSum(info); <br>
   */  
  ibsheetObject.prototype.ShowSubSum = function(info){};
  
  /** 
   * ShowToolTip : 모든 데이터 셀에 대한 툴팁을 설정한다.
   * SetConfig 의 ToolTip 인자를 이용하여 설정 할 수도 있다.
   * @param {Boolean} 툴팁 표시 여부 <br>
   * @example
   * //툴팁 설정<br> 
   * ibsheetObject.ShowToolTip(1); <br>
   */  
  ibsheetObject.prototype.ShowToolTip = function(ToolTip){};

  /** 
   * ShowTreeSubSum : 트리구조에서 소계를 계산하여 표시한다.
   * @param {String} SumCols 합계가 계산되어야 할 컬럼의 Index또는 SaveName을 "|"로 연결한 문자열<br>
   * @param {String} AvgCols 평균이 계산되어야 할 컬럼의 Index 또는 SaveName을 "|"로 연결한 문자열<br>
   * @param {String} CountCols 개수가 계산되어야 할 컬럼의 Index 또는 SaveName을 "|"로 연결한 문자열<br>
   * @param {Boolean} SumEx 상태값이 "삭제"인 행에 대한 계산 포함 여부 (Default=0)<br>
   * @param {Boolean} 평균 컬럼에서 Null 값 포함 계산 여부 (Default=0)<br>
   * @example
   * // 삭제행은 계산에서 제외하기<br> 
   * var info = {SumCols:"2, SumEx:1}; <br>
   * ibsheetObject. ShowTreeSubSum (info);
   */  
  ibsheetObject.prototype.ShowTreeSubSum = function(Info){};
  
  /** 
   * SetSubSumBackColor : 소계 행의 배경 색상을 설정한다
   * @param {String} 설정하고자 하는 WebColor 값 <br>
   * @example
   * //소계 행 배경색상을 녹색으로 설정
   * ibsheetObject.SetSubSumBackColor("#00FF00");
   * @returns {String} 현재 설정된 값
   */  
  ibsheetObject.prototype.SetSubSumBackColor = function(Color){};
  
  /** 
   * GetSubSumBackColor : 소계 행의 배경 색상을 확인한다.
   * @param {String} 설정하고자 하는 WebColor 값 <br>
   * @example
   * //소계 행 배경색상을 녹색으로 설정
   * ibsheetObject.SetSubSumBackColor("#00FF00");
   * @returns {String} 현재 설정된 값
   */  
  ibsheetObject.prototype.GetSubSumBackColor = function(){};  
  
  /** 
   * ShowSum : 합계를 계산하지 않은 경우
   * AutoSum 컬럼의 합계를 계산하여 한번만 보여주거나 재계산을 한다. 
   * @example
   * ibsheetObject.ShowSum();
   * @returns {String} 현재 설정된 값
   */  
  ibsheetObject.prototype.ShowSum = function(){};  
  
  /** 
   * ShowTreeLevel : 데이터가 트리 형태일 때 보여질 트리 레벨을 설정한다. 
   * @param {Integer} 보여질 트리 레벨 수준 (Default=-1) <br>
   * 0:모두접기 -1:모두펼치기 그외:해당레벨만큼 <br>
   * @param {Integer} 보여질 트리 레벨 이하 레벨의 펼침 상태를 설정한다 (Default=0) <br>
   * 0:이전 상태 유지(Default) 1:모두접음 2:모두펼침 <br>
   * @example
   * //모두 접기
   * ibsheetObject.ShowTreeLevel(0, 1);
   */  
  ibsheetObject.prototype.ShowTreeLevel = function(Level, ChildStatus){};
  
  /** 
   * SetSumBackColor : 합계 행의 배경 색상을 설정한다.
   * @param {String} WebColor 값 <br>
   * @example
   * // 합계 행 배경색상을 녹색으로 설정
   * ibsheetObject.SetSumBackColor("#00FF00");
   */  
  ibsheetObject.prototype.SetSumBackColor = function(Color){};
  
  /** 
   * GetSumBackColor : 합계 행의 배경 색상을 확인한다.
   * @example
   * // 합계행 배경색상 구하기
   * ibsheetObject.GetSumBackColor();
   * @returns {String} WebColor 값
   */  
  ibsheetObject.prototype.GetSumBackColor = function(){};

  /** 
   * SetSumFontBold : 합계 행의 글자를 굵게 할지 여부를 설정한다.
   * @param {Boolean} 폰트 굵기 여부 <br>
   * @example
   * // 합계 행의 글자 볼드를 설정한다.
   * ibsheetObject.SetSumFontBold(1);
   */  
  ibsheetObject.prototype.SetSumFontBold = function(Bold){};
  
  /** 
   * GetSumFontBold : 합계 행의 글자를 굵게 할지 여부를 확인한다.
   * @example
   * // 합계행 글자 볼드 설정 확인한다.
   * ibsheetObject.GetSumFontBold();
   * @returns {Boolean} 현재 폰트 굵기 여부
   */  
  ibsheetObject.prototype.GetSumFontBold = function(){};
  
  /** 
   * SetSumFontColor : 합계 행의 글자 색상을 설정한다.
   * @param {String} WebColor 값
   * @example
   * // 합계 행 폰트색상을 녹색으로 설정
   * ibsheetObject.SetSumFontColor("#00FF00");
   */  
  ibsheetObject.prototype.SetSumFontColor = function(Color){};
  
  /** 
   * GetSumFontColor : 합계 행의 글자 색상을 확인한다.
   * @example
   * // 합계행 폰트색상을 확인한다.
   * ibsheetObject.GetSumFontColor();
   * @returns {String} 현재 합계행 글자 색상
   */  
  ibsheetObject.prototype.GetSumFontColor = function(){};
  
  /** 
   * SetSumRowHidden : 합계행의 숨기여부를 설정한다.
   * @param {Boolean} 숨김여부
   * @example
   * // 숨겨진 경우 표시되도록 설정한다.
   * ibsheetObject.SetSumRowHidden(0);
   */  
  ibsheetObject.prototype.SetSumRowHidden = function(Hidden){};
  
  /** 
   * GetSumRowHidden :합계행의 숨기여부를 확인한다.
   * @returns {Boolean} 숨김 설정 값
   */  
  ibsheetObject.prototype.GetSumRowHidden = function(){}; 
  
  /** 
   * SetSumText : 합계 셀의 값을 Format이 적용된 형태로 화면에 보여지는 값 그대로 설정한다.
   * @param {Long / String} 합계 셀의 Column Index 또는 SaveName
   * @param {String} 포맷 적용된 형태의 CellValue 값
   * @example
   * //합계 행의 2컬럼의 값을 5,432.12 로 바꾼다.
   * ibsheetObject.SetSumText(2,"5,432.12");
   */  
  ibsheetObject.prototype.SetSumText = function(Col,Value){};
  
  /** 
   * GetSumText : 합계 셀의 값을 Format이 적용된 형태로 화면에 보여지는 값 그대로 확인한다.
   * @param {Long / String} 합계 셀의 Column Index 또는 SaveName
   * @example
   * //합계 행의 2컬럼의 값을 읽어온다. 
   * ibsheetObject.GetSumText(2)
   * @returns {String} 합계 셀의 Text값
   */  
  ibsheetObject.prototype.GetSumText = function(Col){}; 

  /** 
   * SetSumValue : 합계 셀의 값을 Format이 적용된 형태로 화면에 보여지는 값 그대로 설정한다.
   * @param {Long / String} 합계 셀의 Column Index 또는 SaveName
   * @param {String} 포맷 적용 안된 형태의 CellValue 값
   * @example
   * // 합계 행의 2컬럼의 값을 5432.12 로 바꾼다.
   * ibsheetObject.SetSumValue(2, 5432.12);
   */  
  ibsheetObject.prototype.SetSumValue = function(Col,Value){};
  
  /** 
   * GetSumValue : 합계 셀의 값을 Format이 적용된 형태로 화면에 보여지는 값 그대로 확인한다.
   * @param {Long / String} 합계 셀의 Column Index 또는 SaveName
   * @example
   * // 첫번째 합계 행의 2컬럼의 값을 읽어온다 
   * ibsheetObject.GetSumValue(2)
   * @returns {String} 합계 셀의 Value값
   */  
  ibsheetObject.prototype.GetSumValue = function(Col){};
  
  /** 
   * SetTheme : IBSheet 의 테마 디자인을 설정한다.
   * @param {String} 테마의 Prefix 값
   * @param {String} 테마의 폴더 명
   * @example
   * //Gray 테마를 적용한다.
   * ibsheetObject.SetTheme("GG”, "Gray");
   */  
  ibsheetObject.prototype.SetTheme = function(Prefix, Folder){};
  
  /** 
   * GetTheme : IBSheet 의 테마 디자인을 확인한다.
   * @example
   * // 현재 설정되어 있는 테마를 확인 
   * var Prefix = ibsheetObject.GetTheme();
   * @returns {String} 현재 테마의 Prefix 값
   */  
  ibsheetObject.prototype.GetTheme = function(){};
  
  /** 
   * SetToolTipText : 셀의 풍선도움말을 설정한다.
   * @param {String} 해당 셀의 Row Index
   * @param {Long / String} 해당 셀의 Column Index 또는 SaveName
   * @param {String} 풍선 도움말 설정 값
   * @example
   * //셀에 풍선 도움말 설정
   * ibsheetObject.SetToolTipText(1,1, "셀 풍선 도움말");
   */  
  ibsheetObject.prototype.SetToolTipText = function(Row, Col, ToolTip){};
  
  /** 
   * GetToolTipText : 셀의 풍선도움말을 확인한다.
   * @example
   * // 풍선 도움말 설정값을 확인
   * alert(ibsheetObject.GetToolTipText(1, 1));
   * @returns {String} 현재 테마의 Prefix 값
   */  
  ibsheetObject.prototype.GetToolTipText = function(Row, Col){};
  
  /** 
   * SetTopRow : 최상단의 행 번호를 설정한다.
   * @param {Long} Row Index
   * @example
   * // 최상단 행 번호를 설정한다.
   * ibsheetObject.SetTopRow(100);
   */  
  ibsheetObject.prototype.SetTopRow = function(Row){};
  
  /** 
   * GetTopRow : 최상단의 행 번호를 확인한다.
   * @example
   * // 최상단 행 번호를 확인한다.
   * ibsheetObject.GetTopRow();
   * @returns {Long} 최상단의 행 번호
   */  
  ibsheetObject.prototype.GetTopRow = function(){};
  
  /** 
   * SetTotalRows : 조회 조건에 따라 전체 조회해야 할 DB의 레코드 건수를 설정한다.
   * @param {Long} 전체 건수 설정값
   * @example
   * // 전체 데이터 건수를 1000으로 설정한다.
   * ibsheetObject.SetTotalRows(1000);
   */  
  ibsheetObject.prototype.SetTotalRows = function(Count){};
  
  /** 
   * GetTotalRows : 조회 조건에 따라 전체 조회해야 할 DB의 레코드 건수를 확인한다.
   * @example
   * // 전체 데이터 건수를 확인한다.
   * alert(ibsheetObject.GetTotalRows());
   * @returns {Long} 현재 설정된 값
   */  
  ibsheetObject.prototype.GetTotalRows = function(){};
  
  /** 
   * SetTreeActionMode : 트리 형태일때 각종 기능 처리 관련 속성을 설정한다.
   * @param {Integer} TreeActionMode 값
   * 0:자식이 있으면 삭제 안됨(Default), 1: 삭제 체크시 자식까지 삭제 체크됨
   * @example
   * //삭제 체크를 눌렀을 때 자식레벨까지 삭제되도록 한다.
   * ibsheetObject.SetTreeActionMode(1);
   */  
  ibsheetObject.prototype.SetTreeActionMode = function(Value){};
  
  /** 
   * GetTreeActionMode : 트리 형태일때 각종 기능 처리 관련 속성을 확인한다.
   * @example
   * //현재 설정되어 있는 TreeActionMode 값 확인한다.
   * alert(ibsheetObject.GetTreeActionMode());
   * @returns {Integer} 설정 값
   */  
  ibsheetObject.prototype.GetTreeActionMode = function(){};
  
  /** 
   * SetUnicodeByte : 한글 1자리의 바이트 수를 설정 한다.
   * @param {Integer} 설정할 바이트 수 (Default=1)
   * @example
   * // 한글 1자리의 바이트수를 3으로 설정한다.
   * ibsheetObject.SetUnicodeByte(3);
   */  
  ibsheetObject.prototype.SetUnicodeByte = function(byte){};
  
  /** 
   * GetUnicodeByte : 한글 1자리의 바이트 수를 확인한다.
   * @example
   * // 설정된 바이트 수를 확인한다.
   * ibsheetObject.GetUnicodeByte();
   * @returns {Integer} 현재 설정 값
   */  
  ibsheetObject.prototype.GetUnicodeByte = function(){};
  
  /** 
   * SetUseDefaultTime : 공백인 (Hms,Hm)셀을 Edit하려할때 시스템 현재시간을 표시한다.
   * @param {Boolean} 현재시간 표시 유무 (Default=1)
   * @example
   * // 현재 시간을 표시하지 않도록 설정
   * ibsheetObject.SetUseDefaultTime(0);
   */  
  ibsheetObject.prototype.SetUseDefaultTime = function(Value){};
  
  /** 
   * GetUseDefaultTime : 시스템 현재시간 표시 여부를 확인한다.
   * @returns {Boolean} 현재 설정 값
   */  
  ibsheetObject.prototype.GetUseDefaultTime = function(){};
  
  /** 
   * SetUserAgent : 조회나 저장시 HTTP 헤더 정보에 포함되어 
   * 넘어가는 IBUserAgent의 값을 설정한다.
   * @param {String} User-Agent 설정값
   * @example
   * // HTTP 헤더정보의 IBUserAgent 값을 My Agent Name 으로 전송
   * ibsheetObject.SetUserAgent("My Agent Name");
   */  
  ibsheetObject.prototype.SetUserAgent = function(Value){};
  
  /** 
   * GetUserAgent : 조회나 저장시 HTTP 헤더 정보에 포함되어
   * 넘어가는 IBUserAgent의 값을 확인한다.
   * @returns {String} 현재 설정 값
   */  
  ibsheetObject.prototype.GetUserAgent = function(){};
  
  /** 
   * SetUploadingImage : 파일 업로드 중 대기 이미지 파일의 위치를 설정한다.
   * @param {String} 이미지 URL
   * @example
   * //업로드 중 대기 이미지를 변경한다.
   * ibsheetObject.SetUploadingImage("/sheet/imgUpload.gif");
   */  
  ibsheetObject.prototype.SetUploadingImage = function(Url){};
  
  /** 
   * GetUploadingImage : 파일 업로드 중 대기 이미지 파일의 위치를 확인한다.
   * @example
   * //현재 설정되어있는 업로드 중 대기 이미지 경로를 확인한다.
   * alert(ibsheetObject.GetUploadingImage());
   * @returns {String} 현재 설정 값
   */  
  ibsheetObject.prototype.GetUploadingImage = function(){};
  
  /** 
   * ValidateFail :Validation 확인을 위한 OnValidation 이벤트에서
   * 유효하지 않은 데이터를 발견하여 저장처리를 중단하고자 할 때
   * 이 속성을 설정하여 처리를 중단한다.
   * @param {Boolean} 저장 처리 중단 여부
   */  
  ibsheetObject.prototype.ValidateFail = function(Flag){};
  
  /** 
   * SetVisible : IBSheet의 표시 여부를 설정한다.
   * @param {Boolean} 화면에 시트 표시 여부 (0:숨김 1:보임)
   * @example
   * // 시트를 안보이게 설정
   * ibsheetObject.SetVisible(0);
   * @returns {String} 현재 설정 값
   */  
  ibsheetObject.prototype.SetVisible = function(Visible){};
  
  /** 
   * GetVisible : IBSheet의 표시 여부를 확인한다.
   * @example
   * // 시트 표시 여부를 확인
   * alert(ibsheetObject.GetVisible());
   * @returns {String} 현재 설정 값
   */  
  ibsheetObject.prototype.GetVisible = function(){};
  
  /** 
   * SetWaitImage : 처리 중 대기 이미지 파일의 위치를 설정한다.
   * @param {String} 이미지 Url
   * @example
   * // 처리 중 대기 이미지를 변경한다.
   * ibsheetObject.SetWaitImage("/sheet/imgWait.gif");
   * @returns {String} 현재 설정 값
   */  
  ibsheetObject.prototype.SetWaitImage = function(Url){};
  
  /** 
   * GetWaitImage : 처리 중 대기 이미지 파일의 위치를 확인한다.
   * @returns {String} 현재 설정 되어 있는 URL
   */  
  ibsheetObject.prototype.GetWaitImage = function(){};
  
  /** 
   * SetWaitImageVisible : 각종 처리 중 대기 이미지의 표시여부를 설정한다.
   * @param {Boolean} 각종 대기 이미지 표시 여부
   * @example
   * //처리 중 대기 이미지를 표시하지 않도록 설정한다.
   * ibsheetObject.SetWaitImageVisible(0);
   */  
  ibsheetObject.prototype.SetWaitImageVisible = function(Visible){};
  
  /** 
   * GetWaitImageVisible : 각종 처리 중 대기 이미지의 표시여부를 확인한다.
   * @example
   * //처리 중 대기 이미지 표시 여부를 확인한다.
   * alert(ibsheetObject.GetWaitImageVisible());
   * @returns {Boolean} 현재 설정 값
   */  
  ibsheetObject.prototype.GetWaitImageVisible = function(){};
  
  /** 
   * SetWaitTimeOut : 서버에 연결하여 응답을 대기하는 시간을 설정한다.
   * @param {Integer} 설정할 초시간 (Default=60)
   * @example
   * // 서버에 연결하여 응답을 대기하는 시간을 확인하거나 설정
   * ibsheetObject.SetWaitTimeOut(120);
   * @returns {String} 현재 설정 값
   */  
  ibsheetObject.prototype.SetWaitTimeOut = function(time){};
  
  /** 
   * GetWaitTimeOut : 서버에 연결하여 응답을 대기하는 시간을 확인한다.
   * @example
   * // 서버에 연결하여 응답을 대기하는 시간을 확인
   * alert(ibsheetObject.GetWaitTimeOut());
   * @returns {Integer} 현재 설정 값
   */  
  ibsheetObject.prototype.GetWaitTimeOut = function(){};
  
 
