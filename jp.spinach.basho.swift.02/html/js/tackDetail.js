
//Tack情報
var domain = "";
var urlGetList = "";
var urlSendReply = "";
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
        </div>\
    </div>\
    <div class='tack_date_time'></div>\
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

var setTackId = function(tackId){
    this.tackId = tackId;
}

var setSNSId = function(snsId){
    this.snsId = snsId;
}

var setName = function(snsName){
    this.snsName = snsName;
    $("#sns_name").append(this.snsName);
}

var setImage = function(imageUrl){
    this.snsImage = imageUrl;
}

var setSNSCategory = function(snsType){
    this.snsType = snsType
}

var setPlaceName = function(placeName){
    this.placeName = placeName
    $("#place_name").append(this.placeName);
}

var setComment = function(comment){
    this.comment = comment
    $("#comment").append(this.comment);
}

var setGoodTack = function(goodTack){
    this.goodTack = goodTack
    $("#good_tack").append(this.goodTack);
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
    $("#file_path").append(this.filePath);
}

var setDate = function(date){
    this.date = date
}


var getReplyList = function(){
    
    $.ajax({
        type: "GET",
        url: urlGetList,
        dataType: 'json', 
        data: { 
            tack_id   : tackId   ,
            start   : 0       , 
            count   : 30      ,
        }
    }).done(function( items ) {
        
        for(var i = 0 ; i < items["items"].length ; i++){
            createArticle(items["items"][i]);
        }
        
        location.href = "native://loadFinished"

    });
}

var createArticle = function(tackData){
    
    var articleQuery = $(article)
    var content = $("#reply_list").append(articleQuery);
    
    var date = Date.parse(tackData["date"]);
    articleQuery.find(".tack_body_message").html(tackData["comment"]);
    articleQuery.find(".tack_date_time").html(date);
    
}


