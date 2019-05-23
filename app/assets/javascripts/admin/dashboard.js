$(document).ready(function(){
    $('#contest_type').on('change', function(){
        if ($(this).val() == "NFL_FF") {
            $('.selection').append('<input type="number" name="budget" id="budget" placeholder="Budnget $">');
        } else {
            $('#budget').remove();
        }
    });
    
    $('.add-option').click(function(){
        var last_option = $('.option').last();
        $('<input type="text" name="options[]" id="option" placeholder="Option" multiple="">').insertAfter(last_option); 
    }); 
});