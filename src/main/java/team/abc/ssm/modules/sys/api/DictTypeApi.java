package team.abc.ssm.modules.sys.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.sys.entity.DictType;
import team.abc.ssm.modules.sys.service.DictTypeService;

import java.util.List;

@Controller
@RequestMapping("api/sys/dictType")
public class DictTypeApi extends BaseApi {

    @Autowired
    private DictTypeService dictTypeService;

    @RequestMapping(value = "insert", method = RequestMethod.POST)
    @ResponseBody
    public Object insert(@RequestBody DictType dictType) {
        try {
            if (dictTypeService.insert(dictType))
                return retMsg.Set(MsgType.SUCCESS);
            return retMsg.Set(MsgType.ERROR);
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR);
        }
    }

    @RequestMapping(value = "deleteListByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteListByIds(@RequestBody List<DictType> dictTypeList) {
        try {
            if (dictTypeService.deleteListByIds(dictTypeList))
                return retMsg.Set(MsgType.SUCCESS);
            return retMsg.Set(MsgType.ERROR);
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR);
        }
    }

    @RequestMapping(value = "update", method = RequestMethod.POST)
    @ResponseBody
    public Object update(@RequestBody DictType dictType) {
        try {
            if (dictTypeService.update(dictType))
                return retMsg.Set(MsgType.SUCCESS);
            return retMsg.Set(MsgType.ERROR);
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR);
        }
    }

    @RequestMapping(value = "selectListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectListByPage(@RequestBody DictType dictType) {
        try {
            Page<DictType> page = new Page<>();
            page.setTotal(dictTypeService.selectSearchCount(dictType));
            page.setResultList(dictTypeService.selectListByPage(dictType));
            return retMsg.Set(MsgType.SUCCESS, page);
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR, e.getMessage());
        }
    }

    @RequestMapping(value = "selectAllList", method = RequestMethod.POST)
    @ResponseBody
    public Object selectAllList(){
        try {
            return retMsg.Set(MsgType.SUCCESS, dictTypeService.selectAllList());
        } catch (Exception e){
            return retMsg.Set(MsgType.ERROR, e.getMessage());
        }
    }
}
