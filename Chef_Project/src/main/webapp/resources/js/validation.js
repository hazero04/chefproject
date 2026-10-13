function CheckAddFood() {
	
	var f_foodname=document.getElementById("f_foodname");
	var f_description=document.getElementById("f_description");
	var f_price=document.getElementById("f_price");
	var f_date=document.getElementById("f_date");
	var f_place=document.getElementById("f_place");
	var unitsInStock=document.getElementById("unitsInStock");
	var f_filename=document.getElementById("f_filename");
	
	//식재료명 체크
	if (f_foodname.value.length < 1 || f_foodname.value.length > 20) {
		alert("[식재료명]\n최소 1자에서 최대 20자까지 입력하세요");
		f_foodname.focus();
		return false;
	}
	
	//식재료 설명 체크 
	if (f_description.value.length < 10) {
			alert("[상세설명]\n최소 10자 이상 입력하세요");
			f_description.focus();
			return false;
	}
		
	//식재료 가격 체크 
	if (f_price.value.length==0 || isNaN(f_price.value)) {
		alert("[가격]\n숫자만 입력하세요");
		f_price.focus();
		return false;
	}
	
	if (f_price.value < 0) {
		alert("[가격]\n음수를 입력할 수 없습니다");
		f_price.focus();
		return false;
	}
	
	//식재료 재고 체크
	if (isNaN(unitsInStock.value)) {
		alert("[재고 수]\n숫자만 입력하세요");
		unitsInStock.focus();
		return false;
	}
	
	//식재료 유통기한 체크 
	var ExpDate = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/;	//유통기한 기재형식

	if (!check(ExpDate, f_date, "[유통기한]\n올바른 날짜 형식(YYYY-MM-DD)으로 입력하세요.\n")) {
	    return false;
	}
	
		// 사용자가 입력한 글자(예: "2026-06-05")를 날짜로 만들기
		var inputDate = new Date(f_date.value);
		
		//오늘 날짜 불러오기
		var today = new Date();
		
		// 오늘 날짜의 시간을 0시 0분 0초로 맞추기
		today.setHours(0, 0, 0, 0);
		
		// 4. 입력한 날짜가 오늘보다 과거라면, 에러창 띄움.
		if (inputDate < today) {
			alert("[유통기한]\n이미 지난 날짜는 입력할 수 없습니다.\n오늘 이후의 날짜를 입력해 주세요.");
			f_date.focus();
			return false;
		}
		
	//사용자가 잘 입력했는지 마지막으로 체크
	function check(regExp,f,msg) {
		if (regExp.test(f.value)) {
			return true;
		}
		alert(msg);
		f.focus();
		return false;
	}
	document.newFood.submit();
}