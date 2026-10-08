<%

/**
*	The purpose of this file is to rename a node in the database 
*	
*	Input : $_GET['renameId']
*			$_GET['newName']
*		OR
*			$_GET['deleteIds'] 
*		If a delete request is sent
**/

if(request.getParameter("addNewId")!=null && request.getParameter("addNewIds")!=null)	{	// variables are set

	// Typical code
/*	
	$res = mysql_query("select * from category where ID='".$_GET['renameId']."'");
	if($inf = mysql_fetch_array($res)){
		mysql_query("update category set categoryName='".$_GET['newName']."' where ID='".$inf["ID"]."'") or die("NOT OK");
		echo "OK";	// OK when everything is ok
	}
	echo "NOT OK";	// Node didn't exist -> Message not ok
*/
	out.print("OK");
}

if(request.getParameter("renameId")!=null && request.getParameter("newName")!=null)	{	// variables are set

	// Typical code
/*	
	$res = mysql_query("select * from category where ID='".$_GET['renameId']."'");
	if($inf = mysql_fetch_array($res)){
		mysql_query("update category set categoryName='".$_GET['newName']."' where ID='".$inf["ID"]."'") or die("NOT OK");
		echo "OK";	// OK when everything is ok
	}
	echo "NOT OK";	// Node didn't exist -> Message not ok
*/
	out.print("OK");
}

if(request.getParameter("deleteIds")!=null){	// Format of $_GET['deleteIds'] : A comma separated list of ids to delete, example: 1,2,3,4,5,6,7
	
	// Typical code
/*	
	mysql_query("delete from category where ID IN(".$_GET['deleteIds']."')") or die("NOT OK");
*/
	out.print("OK");
}

%>
 