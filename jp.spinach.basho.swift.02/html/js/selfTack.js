
var domain = "";
var urlGetList = "";
var urlGetBgImage = "";
var snsId = "";
var snsType = "";
var snsToken = "";

var getSelfTackCount = 0;

var article = "<article tack_id=''>\
    <div class='tack_date_time'></div>\
    <div class='tack food'>\
        <div class='tack_inner_wrapper'>\
            <div class='tack_body_pin pin_food'></div>\
            <div class='tack_header'>\
                <div class='tack_to_detail_label'>詳しく見る! ></div>\
            </div>\
            <div class='tack_body'>\
                <div class='tack_body_title'></div>\
                <div class='tack_body_message'></div>\
            </div>\
            <div class='tack_image_wrapper'>\
                <img class='tack_image'>\
            </div>\
            <div class='tack_footer'>\
                <div class='tack_good_label'>\
                    Good <span class='tack_good_count'></span>\
                </div>\
                <div class='tack_comment_label'>\
                    コメント <span class='tack_comment_count'></span>\
                </div>\
            </div>\
        </div>\
    </div>\
</article>";



var tack = {
      
    objectId : "",
    tackId : "",
    snsId : "",
    snsCategory : "",
    category : "",
    placeName : "",
    comment : "",
    goodTackCount : "",
    commentCount : "",
    cityCode : "",
    lat : "",
    lng : "",
    hasFileFlg : "",
    filePath : "",
    date : "",
    token : ""
    
};

/*
    1.setUrl         //POST先のURLをセット
    2.setSNSID　     //SNSのIDをセット
    3.setSNSType    //SNSのタイプをセット
    //4.getSNSData    //SNS情報の取得
    5.setName       //SNSの名前をセット
    6.setImage      //SNSの画像をセット
    7.getTackList   //Tackリストを取得
    8.createArticle //表示項目を作成する
*/

var setDomain = function(domain){
    this.domain = domain;   
}

var setUrlGetList = function(urlGetList){
    this.urlGetList = urlGetList;   
}

var setUrlGetBgImage = function(urlGetBgImage){
    this.urlGetBgImage = urlGetBgImage;   
}

//自身のIDをネイティブから受け取りセットする
var setSNSID = function(snsId){
    this.snsId = snsId
}

//自身のSNSTypeをセットすりセットする
var setSNSType = function(snsType){
    this.snsType = snsType
}

var setSNSToken = function(token){
    this.token = token
}

var getBgImage = function(){
    $.ajax({
        type: "GET",
        url: urlGetBgImage,
        dataType: 'json', 
        data: { 
            sns_id   : snsId   ,
            token : token,
        }
    }).done(function( items ) {
        $(".bg_blue").css("background",'url(' + domain + items["items"][0]["file_path"] + ")");
    });
}


//自身のTackを取得する
var getTackList = function(){
    $.ajax({
        type: "GET",
        url: urlGetList,
        dataType: 'json', 
        data: { 
            sns_id   : snsId   ,
            sns_type : snsType ,
            start   : 0       , 
            count   : 30      ,
            token : token,
        }
    }).done(function( items ) {
        for(var i = 0 ; i < items["items"].length ; i++){
            createArticle(items["items"][i]);
        }
        location.href = "native://loadFinished"
        getSelfTackCount = 30;
    });
}

var setName = function(snsName){
    $(".sns_name").html(snsName);
}

var setImage = function(imageUrl){
    $(".sns_icon").attr("src",imageUrl);
}

var createArticle = function(tackData){
    
    var articleQuery = $(article)
    var content = $(".contents").append(articleQuery);
    
    articleQuery.attr("tack_id",tackData["tack_id"]);
    var date = Date.parse(tackData["date"]);
//    console.log(date.getDay());
//    var dateString = date.toLocaleDateString();
    articleQuery.find(".tack_date_time").html(tackData["date"]);
    articleQuery.find(".tack").addClass(tackData["category"]);
    articleQuery.find(".tack_body_pin").addClass("pin_" + tackData["category"]);
    articleQuery.find(".tack_body_title").html(tackData["place_name"]);
    articleQuery.find(".tack_body_message").html(tackData["comment"]);
    articleQuery.find(".tack_good_count").html(tackData["good_tack"]);
    articleQuery.find(".tack_comment_count").html(tackData["message"]);
    if(tackData["has_file_flg"]){
        articleQuery.find(".tack_image").attr("src",domain+tackData["file_path"]);
    }else{
        articleQuery.find(".tack_image").remove();
    }
    
    //要素をタップしたら画面遷移
    articleQuery.tap(function(obj){
        window.open("native://" + obj.attr("tack_id"));
    });
    
}


var getNextTack = function(){
    
    $.ajax({
        type: "GET",
        url: urlGetList,
        dataType: 'json', 
        data: { 
            sns_id   : snsId   ,
            sns_type : snsType ,
            start   : getSelfTackCount + 1, 
            count   : 30      ,
            token : token,
        }
    }).done(function( items ) {
        for(var i = 0 ; i < items["items"].length ; i++){
            createArticle(items["items"][i]);
        }
        //location.href = "native://loadFinished"
        getSelfTackCount = getSelfTackCount + 30;
    });
    
}