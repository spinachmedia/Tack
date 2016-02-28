(function($) {
    $.fn.tap = function( func ){
        var touchTime,touchX,touchY;
        $(this).bind("touchstart", function(e){ 
            touchTime = new Date();
            touchX = event.changedTouches[0].pageX;
            touchY = event.changedTouches[0].pageY;
        });
        $(this).bind("touchend", function(e){ 
            if((new Date) - touchTime < 400 &&
               Math.abs(touchX - event.changedTouches[0].pageX) < 10 &&
               Math.abs(touchY - event.changedTouches[0].pageY) < 10){
                func($(this));
            }
        });
//        $(this).bind("mousedown", function(e){ 
//            touchTime = new Date();
//            if( typeof event == "undefined"){
//                touchX = e.screenX;
//                touchY = e.screenY;
//                return;
//            }
//            touchX = event.screenX;
//            touchY = event.screenY;
//        });
//        $(this).bind("mouseup", function(e){ 
//            if( typeof event == "undefined"){
//                if((new Date) - touchTime < 400 &&
//                    Math.abs(touchX - e.screenX) < 10 &&
//                    Math.abs(touchY - e.screenY) < 10){
//                    func($(this));
//                }
//                    return;
//                }
//            if((new Date) - touchTime < 400 &&
//               Math.abs(touchX - event.screenX) < 10 &&
//               Math.abs(touchY - event.screenY) < 10){
//                func($(this));
//            }
//        });
    }
    
})(jQuery);