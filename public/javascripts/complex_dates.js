function toggle_end_date(select_element, end_date_wrapper_id){
	// Get the value of the select element
	var select_element_value = $(select_element).find("option:selected").text();
	// Show the end date element if the select element's value is either "Probable" or "Estimated"; hide it otherwise 
	if(select_element_value == "Probable" || select_element_value == "Estimated"){
		$('#'+end_date_wrapper_id).show();
	}else{
		$('#'+end_date_wrapper_id).hide();
		// Reset the field's value
		if($('#'+end_date_wrapper_id+' select').length > 0){
			var value = $('#'+end_date_wrapper_id+' select option:first').val();
			$('#'+end_date_wrapper_id+' select').val(value);
		}
		if($('#'+end_date_wrapper_id+' input').length > 0){
			$('#'+end_date_wrapper_id+' input').val('');
		}
	}
	return true;
}