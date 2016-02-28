
//Tack情報
var domain = "";
var urlGetList = "";
var urlSendReply = "";
var urlGoodTack = "";
var ownerSnsId = "";
var ownerToken = "";
var tackId = "";
var snsId = "";
var snsName = "";
var snsImage = "";
var snsType = "";
var category = "";
var placeName = "";
var comment = "";
var goodTack = "";
var cityCode = "";
var lat = "";
var lng = "";
var hasFileFlg = "";
var filePath = "";
var date = "";

//ログイン中の操作者のSNSID
var operatorSnsId = "";

var article = "<article tack_id=''>\
    <div class='tack'>\
        <div class='tack_inner_wrapper'>\
            <div class='tack_body'>\
                <div class='tack_body_message'></div>\
            </div>\
            <div class='tack_date_time'></div>\
        </div>\
    </div>\
</article>";

/*
    1.setDomain         //POST先のURLをセット
    1.1. setUrlGetList //同上
    2.setTackInfo_   //表示するTack詳細情報を表示する
        7.setSnsId
        7.setSnsName
        7.setSnsImage
        7.setSnsCategory
        7.setCategory
        7.setPlaceName
        7.setComment
        7.setGoodTack
        7.setCityCode
        7.setLat
        7.setLng
        7.setHasFileFlg
        7.setFilePath
        7.setDate
    3.getReplyList   //Tackリストを取得
    4.createArticle //表示項目を作成する
*/



var setDomain = function(domain){
    this.domain = domain;   
}

var setUrlGetList = function(urlGetList){
    this.urlGetList = urlGetList;   
}

var setUrlSendReply = function(urlSendReply){
    this.urlSendReply = urlSendReply;   
}

var setUrlGoodTack = function(urlSendGood){
    this.urlGoodTack = urlSendGood;   
}

var setOwnerSnsId = function(ownerSnsId){
    this.ownerSnsId = ownerSnsId;   
}

var setOwnerToken = function(ownerToken){
    this.ownerToken = ownerToken;   
}
    
var setTackId = function(tackId){
    this.tackId = tackId;
    if(localStorage.getItem('good' + tackId) != null){
        $(".button_bg").addClass("gooded");
    }
}

var setSNSId = function(snsId){
    this.snsId = snsId;
}

var setSnsName = function(snsName){
    this.snsName = snsName;
    $(".sns_name_text").html(this.snsName);
}

var setImage = function(imageUrl){
    this.snsImage = imageUrl;
    $(".sns_icon").attr("src",this.snsImage);
}

var setSNSCategory = function(snsType){
    this.snsType = snsType
}

var setPlaceName = function(placeName){
    this.placeName = placeName
//    $("#place_name").append(this.placeName);
}

var setComment = function(comment){
    this.comment = comment
    $("#comment").html(this.comment);
}

var setGoodTack = function(goodTack){
    this.goodTack = goodTack
    $("#good_tack_count").html(this.goodTack);
}

var setCityCode = function(cityCode){
    this.cityCode = cityCode
}

var setLat = function(lat){
    this.lat = lat
}

var setLng = function(lng){
    this.lng = lng
}

var setHasFileFlg = function(hasFileFlg){
    this.hasFileFlg = hasFileFlg
}

var setFilePath = function(filePath){
    this.filePath = filePath
    $("#tack_image").attr("src",this.filePath);
}

var setDate = function(date){
    this.date = date
    $("#date").html(this.date);
}


var getReplyList = function(){
    
    $.ajax({
        type: "GET",
        url: urlGetList,
        dataType: 'json', 
        data: { 
            sns_id   : ownerSnsId,
            token : ownerToken,
            tack_id   : tackId   ,
            start   : 0       ,
            count   : 30      ,
        }
    }).done(function( items ) {
        
        //リプライリストを空に。
        $("#reply_list").html("");
        
        //リプライリストの作成
        for(var i = 0 ; i < items["items"].length ; i++){
            createArticle(items["items"][i]);
        }
        
        //更新の終了をネイティブに通知。
        location.href = "native://loadFinished"

    });
}

var createArticle = function(tackData){
    
    var articleQuery = $(article)
    var content = $("#reply_list").append(articleQuery);
    
    var date = new Date(tackData["date"]);
//    var date = Date.parse(tackData["date"]);
    articleQuery.find(".tack_body_message").html(tackData["comment"]);
    articleQuery.find(".tack_date_time").html(formatDate(date,"YYYY/MM/DD hh:mm:ss"));
    
}


var formatDate = function (date, format) {
  if (!format) format = 'YYYY-MM-DD hh:mm:ss.SSS';
  format = format.replace(/YYYY/g, date.getFullYear());
  format = format.replace(/MM/g, ('0' + (date.getMonth() + 1)).slice(-2));
  format = format.replace(/DD/g, ('0' + date.getDate()).slice(-2));
  format = format.replace(/hh/g, ('0' + date.getHours()).slice(-2));
  format = format.replace(/mm/g, ('0' + date.getMinutes()).slice(-2));
  format = format.replace(/ss/g, ('0' + date.getSeconds()).slice(-2));
  if (format.match(/S/g)) {
    var milliSeconds = ('00' + date.getMilliseconds()).slice(-3);
    var length = format.match(/S/g).length;
    for (var i = 0; i < length; i++) format = format.replace(/S/, milliSeconds.substring(i, i + 1));
  }
  return format;
};
