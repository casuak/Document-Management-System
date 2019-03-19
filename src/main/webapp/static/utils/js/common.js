// 依赖于jquery

/**
 * 通用Get方法
 * @param url 后端接口地址
 * @param data 传送的数据
 * @param successCallback 成功回调函数（可选）
 * @param errorCallBack 失败回调函数（可选）
 */
function ajaxGet(url, data, successCallback, errorCallback) {
    $.ajax({
        type: 'GET',
        url: url,
        data: data,
        cache: false,
        success: successCallback,
        error: errorCallback
    })
}

/**
 * 通用POST方法
 * @param url 后端接口地址
 * @param data 传送的数据
 * @param successCallback 成功回调函数（可选）
 * @param errorCallback 失败回调函数（可选）
 */
function ajaxPost(url, data, successCallback, errorCallback, async=true) {
    $.ajax({
        type: 'POST',
        url: url,
        data: data,
        cache: false,
        success: successCallback,
        error: errorCallback,
        async: async
    })
}

/**
 * 通用POST方法，data会被自动转化为json格式的字符串
 * @param url 后端接口地址
 * @param data 传送的数据
 * @param successCallback 成功回调函数（可选）
 * @param errorCallback 失败回调函数（可选）
 */
function ajaxPostJSON(url, data, successCallback, errorCallback, async=true) {
    $.ajax({
        type: 'POST',
        url: url,
        data: JSON.stringify(data),
        cache: false,
        success: successCallback,
        error: errorCallback,
        dataType: 'json',
        contentType: 'application/json;charset=utf-8',
        async: async
    })
}

/**
 * 格式化时间戳，返回格式 YYYY-MM-DD HH:mm:ss
 * @param timestamp
 */
function formatTimestamp(timestamp) {
    let date = new Date(timestamp); // 时间戳为10位需*1000，时间戳为13位的话不需乘1000
    let Y = date.getFullYear() + '-';
    let M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-';
    let D = (date.getDate() < 10 ? '0' : '') + date.getDate() + ' ';
    let h = (date.getHours() < 10 ? '0' : '') + date.getHours() + ':';
    let m = (date.getMinutes() < 10 ? '0' : '') + date.getMinutes() + ':';
    let s = (date.getSeconds() < 10 ? '0' : '') + date.getSeconds();
    return Y + M + D + h + m + s;
}

function copy(object){
    return JSON.parse(JSON.stringify(object));
}

// 文件上传状态
const UploadStatus = {
    QUEUED: 0, // 队列中（尚未开始）
    UPLOADING: 1, // 上传中
    DONE: 2, // 完成
    FAILED: 3, // 失败
    PAUSE: 4 // 暂停
};

// 后端返回状态
const MsgType = {
    SUCCESS: 0,
    ERROR: 1,
    WARNING: 2,
    INFO: 3
};