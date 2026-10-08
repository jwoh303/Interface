<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<script type="text/javascript">

function init(){
<%--    $("#st_btoa_remark").val(<%=st_btoa_remark%>); --%>
//    $("#st_atob_remark").val("");
   
//   opener.setPopupReturn(value1,"");
//   this.close();
	$("#st_loan_amt").focus();
}

function kepConfirm()
{ 
  if($("#st_loan_amt").val()==null||$("#st_loan_amt").val()==""){
	  alert("추가여신 금액입력바랍니다.");
	  $("#st_loan_amt").focus();
	  return;
  }
  if($("#st_add_loan_remark").val()==null||$("#st_add_loan_remark").val()==""){
	  alert("추가여신 요청사유 입력바랍니다.");
	  $("#st_add_loan_remark").focus();
	  return;
  }
  var value1 = $("input[name=st_loan_type]:checked").val()+$("#st_loan_amt").val();
  var value2 = $("#st_add_loan_remark").val();
  value2 = value2.replace(/\r?\n/g, '<br>');  
  opener.setPopupReturn(value1,value2);
  this.close();
}


</script>  
<body onload="init(); " >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:214px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">추가여신등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<table class="cont_t_list05" >
				<tr > 
					<td style="width:100px;background-color:#dae4f0;">추가여신금액</td>
					<td style="width:150px">
		              <input type="radio" class="Noborder"  name="st_loan_type" id="st_loan_type" value=""  checked="checked" >
		              증액(+)&nbsp;
		              <input type="radio" class="Noborder" name="st_loan_type" id="st_loan_type" value="-" >
		              감액(-)&nbsp;
					</td>
					<td >
						<input type="text" name="st_loan_amt"  id="st_loan_amt" style="text-align:right;width:160px"  value=""  class="input_type_text" >
					</td>
				</tr>

            </table>
 			<table >
                <tr>
                    <td height="4"></td>
                </tr>
            </table >
             <table class="cont_t_list05">
                <tr> 
                	<td style="width:100px;background-color:#dae4f0;">요청사유 </td>
                    <td>
                        <textarea name="st_add_loan_remark" id="st_add_loan_remark"  style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0;" rows="4" cols="35" ></textarea>
                    </td>
                </tr>
            </table>
            <table >
                <tr>
                    <td height="4"></td>
                </tr>
            </table >
	       	<div class="btnArea ac" style="margin-bottom:0px;"> 
			     <span class="fr btn_04"><a href="javascript:kepConfirm()">품의상신</a></span> 
			</div> 		
        </div>
    </div>
</body>
</html>
