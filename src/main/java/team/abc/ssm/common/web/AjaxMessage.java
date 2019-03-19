package team.abc.ssm.common.web;

/**
 * 后端返回前端的标准信息格式
 */
public class AjaxMessage {

    private String code; // 状态码，从枚举MsgType转换而来，全小写
    private Object data; // 数据
    private String message; // 提示信息

    public AjaxMessage Set(MsgType msgType, Object data, String message){
        this.code = msgType.toString().toLowerCase();
        this.data = data;
        this.message = message;
        return this;
    }

    public AjaxMessage Set(MsgType msgType, Object data){
        this.code = msgType.toString().toLowerCase();
        this.data = data;
        this.message = "";
        return this;
    }

    public AjaxMessage Set(MsgType msgType){
        this.code = msgType.toString().toLowerCase();
        this.data = "";
        this.message = "";
        return this;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
